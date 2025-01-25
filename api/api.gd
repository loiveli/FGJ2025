extends Node2D


signal similarity_response(similarities: Array[Similarity])

class Similarity:
	var value: float
	var bubble: String
	
	func _init(v,t):
		value = v
		bubble = t
	
func similarity_from_dict(d) -> Similarity:
		return Similarity.new(d["value"], d["bubble"])


@onready
var http: HTTPRequest = $HTTPRequest
const API_URL = "http://localhost:9000/similarity"


func _ready() -> void:
	http.request_completed.connect(_on_request_completed)

func get_similarity(input):
	var result = http.request(
		API_URL,
		[],
		HTTPClient.METHOD_POST,
		JSON.new().stringify({ "input": input })
	)
	
	if result != OK:
		print("API error")

func get_similarity_async(input):
	self.get_similarity(input)
	var response = await self.similarity_response
	return response

func _on_request_completed(result, response_code, headers, body):
	var similarities: Array[Similarity] = _parse_response_json(body)
	similarity_response.emit(similarities)

func _parse_response_json(body) -> Array[Similarity]:
	var json = JSON.new()
	var parse_result = json.parse(body)
	
	var result = []
	
	if parse_result != OK:
		print("Could not parse JSON")
		return []
		
	for v in json.data:
		var similarity = similarity_from_dict(v)
		result.append(similarity)
	
	return result
