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
const API_URL = "http://localhost:8000/sim"


func _ready() -> void:
	http.request_completed.connect(_on_request_completed)

func get_similarity(input: String, bubbles: Array[String] = ["Rock","Sports","Memes"]):
	var headers: Array[String] = ["user-text: %s" % input]
	if bubbles.size() > 0:
		headers.append("new-bubbles: %s" % ",".join(bubbles))
	
	var result = http.request(API_URL, headers, HTTPClient.METHOD_GET)
	
	if result != OK:
		print("API error")

func get_similarity_async(input):
	self.get_similarity(input)
	var response = await self.similarity_response
	return response

@warning_ignore("unused_parameter")
func _on_request_completed(result, response_code, headers, body):
	var similarities: Array[Similarity] = _parse_response_json(body)
	similarity_response.emit(similarities)

func _parse_response_json(body) -> Array:
	var json = JSON.new()
	print(body)
	var parse_result = json.parse(body.get_string_from_utf8())
	
	var result = []
	
	if parse_result != OK:
		print("Could not parse JSON")
		return []
		
	for v in json.data:
		var similarity = similarity_from_dict(v)
		result.append(similarity)
	
	return result
