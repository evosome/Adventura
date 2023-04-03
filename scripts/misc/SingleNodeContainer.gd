extends Node
class_name SingleNodeContainer

var current_node: Node


func switch_node(new_node: Node) -> void:
	if current_node:
		remove_child(current_node)
	add_child(new_node)
	current_node = new_node
