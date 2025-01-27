# Avoiding bubbles
FGJ2025 game where you move around a social media landscape by tweeting about different topics, and collect content that makes you slightly exhale from your nose while avoiding filter bubbles. Our game uses a local language model to parse which topics your tweet is related to and you move towards the related topics. You still need to be careful as tweeting too much about a single topic could lead to getting sucked into a social media bubble.
How to run the game:
1. Download the game executable .zip from [GlobalGameJam](https://globalgamejam.org/games/2025/aivoiding-bubbles-8), which contains both the game and the server running the language model. We cant actually use github releases as the server EXE is over 4GB
2. Run the Avoiding_bubbles_server.exe
    Few disclaimers:
    1. On first launch, the server needs to download the model and save it in C:\Users\<UserName>\.cache for future use
    2. You might see some errors, but unless the console window crashes/closes the server should be working
    3. Unfortunately we could not find a way to package our most powerful model, so you need to be quite literal for the model to register the topic
    4. You will still need quite a beefy computer to run the model, as it will using your CPU for processing. 
    5. We had a lot of trouble with CUDA on windows, but there might be a guide coming later on how to run the more poweful models on your GPU
3. Once you get the message "Uvicorn running on http://127.0.0.1:8000" you can start the game.
4. You can test if the API connection is working by writing one of topics in the text box and pressing enter, you should start moving towards the topic once the server has responded.

How to play:
Movement is very simple, you write a tweet on the phone and post it. Once the API responds, you will start moving towards the topics in your tweet
If you stay still, your sanity starts to go down. You can gain more sanity by collecting good content that makes you slightly exhale from your nose
When you tweet about a topic, that topic will get bigger. Once a topic gets large enough, it will start spawning trolls and bots to bother you.
If you get sucked into a social media bubble, your sanity (and the game) will crash and the game is over.


## Credit:
https://openmoji.org/library/emoji-2764/
https://openmoji.org/library/emoji-1F4A9/
https://huggingface.co/nvidia/NV-Embed-v2
https://huggingface.co/NovaSearch/stella_en_1.5B_v5
https://huggingface.co/sentence-transformers/all-mpnet-base-v2