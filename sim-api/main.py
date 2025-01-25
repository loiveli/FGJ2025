from fastapi import FastAPI, Header, HTTPException
import numpy as np

from transformers import BitsAndBytesConfig
from transformers import AutoModel

from torch.nn.functional import cosine_similarity

from typing import Annotated

from fastapi import FastAPI, Header, HTTPException
import uvicorn
from sentence_transformers import SentenceTransformer
import torch
from settings import MODEL_NAME, DEVICE



class State():
    bubbles: list[str] | None = None
    embeddings: torch.FloatTensor | None = None

class EmbeddingModel():
    # These are in order of "fastest and smallest" to "slowest and biggest"
    # Dictionary of format {model_name, embedding_dim}
    _model_embed_dims = {"mpnet": 768, "stella_400M": 1024, "stella_1.5B": 1024, "nvembed": 4096}
    _supported_models = _model_embed_dims.keys()

    prompt: str | None = None
    model_name: str | None = None
    model = None
    device: str | None = None
    embed_dim: int | None = None
    
    def __init__(self, model_name: str, device: str):
        if model_name not in self._supported_models:
            raise RuntimeError(f"Model name {model_name} not supported. Use one of: {self._supported_models}")

        self.device = device
        self.model_name = model_name
        self.embed_dim = self._model_embed_dims[model_name]

        if model_name == "mpnet":
            self.model = SentenceTransformer("all-mpnet-base-v2")
        elif model_name == "stella_400M":
            self.prompt = "s2p_query"
            self.model = SentenceTransformer("dunzhang/stella_en_400M_v5", trust_remote_code=True, device=self.device)
        elif model_name == "stella_1.5B":
            self.prompt = "s2p_query"
            self.model = SentenceTransformer("dunzhang/stella_en_1.5B_v5", trust_remote_code=True, device=self.device)
        elif model_name == "nvembed":
            self.prompt = "Instruct: Given a question, retrieve passages that answer the question\nQuery: "
            bnb_config = BitsAndBytesConfig(
                load_in_4bit=True,
                bnb_4bit_use_double_quant=True,
                bnb_4bit_quant_type="nf4",
                bnb_4bit_compute_dtype=torch.float16
            )
            bnb_config = None
            self.model = AutoModel.from_pretrained('nvidia/NV-Embed-v2', trust_remote_code=True, quantization_config=bnb_config).to(device=self.device)

    def embed(self, text: str, use_prompt: bool):
        if self.model_name is None or self.model is None:
            raise RuntimeError("No model loaded...")

        if self.model_name == "nvembed":
            return self.model.encode(text, instruction=self.prompt if use_prompt else None)
        elif "stella" in self.model_name:
            return self.model.encode(text, prompt_name=self.prompt if use_prompt else None)
        elif self.model_name == "mpnet":
            return self.model.encode(text)

state = State()
app = FastAPI()
model = EmbeddingModel(MODEL_NAME, DEVICE)

@app.get("/sim")
async def get_sim(user_text: str = Header(), new_bubbles: Annotated[str | None, Header()] = None):
    # If client has specified "bubbles", we overwrite the previous value.
    # If not, reuse the previous value for this new user string. In that case, a previous value must exist.
    if new_bubbles:
        state.bubbles = new_bubbles.split(",")
        state.embeddings = torch.FloatTensor(len(new_bubbles), model.embed_dim)
        for i, bubble in enumerate(state.bubbles):
            new_embedding = model.embed(bubble, use_prompt=False)
            state.embeddings[i, :] = torch.FloatTensor(new_embedding)
    else:
        if not state.bubbles:
            raise HTTPException(status_code=404, detail="No previous bubbles found, nothing to compare user text against!")
    
    user_text_embedding = torch.Tensor(model.embed(user_text, use_prompt=True)).unsqueeze(0).to(model.device)
    similarities = torch.zeros([len(state.bubbles)]).to(model.device)

    max_batch_size = 1
    for i in range(0, len(state.bubbles), max_batch_size):
        batch = state.embeddings[i : i+max_batch_size].to(model.device)
        new_similarities = cosine_similarity(user_text_embedding, batch, dim=1)
        similarities[i : i+max_batch_size] = new_similarities

    similarities = similarities.cpu().numpy().astype(float)

    similarity_order = np.flip(np.argsort(similarities)).tolist()
    bubble_items = np.array([{"bubble": a, "value": b} for a, b in zip(state.bubbles, similarities)])

    return bubble_items[similarity_order].tolist()

if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000, reload=False)
