extends Node2D
var meme = preload("res://sanity_up.tscn")


func _ready():
    var nodes = $"..".get_children().filter(func(child): return child is StaticBody2D).filter(func(node): return node.collisionType == "BUBBLE")
    for node in nodes:
        var meemi = meme.instantiate()
        meemi.initializeNodes(nodes)
        add_child(meemi)