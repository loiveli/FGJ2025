extends StaticBody2D

var collisionType = "MEME"

var nodeList: Array
	
func _ready():
    resetPosition(nodeList)
	
func resetPosition(nodes = nodeList):
    nodeList= nodes
    var node1 = nodes.pick_random()
    nodes.remove_at( nodes.find(node1))
    var node2 = nodes.pick_random()

    position = (node1.position - node2.position) * randf_range(0.2,0.8)


func initializeNodes(nodes):
    nodeList = nodes
