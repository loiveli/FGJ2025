extends StaticBody2D

var collisionType = "MEME"

var nodeList: Array
    
func _ready():
    nodeList = $"..".get_children().filter(func(child): return child is StaticBody2D).filter(func(node): return node.collisionType == "BUBBLE")
    resetPosition(nodeList)
    
func resetPosition(nodes = nodeList):
    var node1 = nodes.pick_random()
    nodes.remove_at( nodes.find(node1))
    var node2 = nodes.pick_random()

    position = (node1.position - node2.position) * randf_range(0.2,0.8)

    
    
    

