extends Node2D

# Used to skip querying the similarity API
@export var RETURN_HARDCODED_VALUE = false
var TEST_RESPONSES: Array = [[
	Similarity.new(0.9, "Movies"),
	Similarity.new(0.1, "Games")
],[
	Similarity.new(0.9, "Games"),
	Similarity.new(0.1, "NBA")
],[
	Similarity.new(0.9, "NBA"),
	Similarity.new(0.1, "Games")
],[
	Similarity.new(0.7, "Movies"),
	Similarity.new(0.6, "Games"),
	Similarity.new(0.9, "Nascar"),
	Similarity.new(0.5, "Rock")
]]

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
const API_URL = "http://127.0.0.1:8000/sim"


func _ready() -> void:
	http.request_completed.connect(_on_request_completed)

func get_similarity(input: String, bubbles: Array = []):
	var headers: Array[String] = ["user-text: %s" % input.uri_encode()]
	if bubbles.size() > 0:
		headers.append("new-bubbles: %s" % ",".join(bubbles))
		
	var result = http.request(API_URL, headers, HTTPClient.METHOD_GET)
	
	if result != OK:
		print("API error")

func get_similarity_async(input, bubbles: Array = []):
	if RETURN_HARDCODED_VALUE:
		
		return TEST_RESPONSES[randi_range(0,TEST_RESPONSES.size())]
	
	self.get_similarity(input, bubbles)
	var response = await self.similarity_response
	return response

@warning_ignore("unused_parameter")
func _on_request_completed(result, response_code, headers, body):
	var similarities: Array = _parse_response_json(body)
	similarity_response.emit(similarities)

func _parse_response_json(body) -> Array:
	var json = JSON.new()
	var parse_result = json.parse(body.get_string_from_utf8())
	
	var result = []
	
	if parse_result != OK:
		print("Could not parse JSON")
		return []
		
	for v in json.data:
		var similarity = similarity_from_dict(v)
		result.append(similarity)
	
	return result
