tool
class_name VisualFiniteStateMachineEvent
extends Resource

export(String) var name: String


func enter() -> void:
	pass


func is_triggered(delta: float, object, params) -> bool:
	assert(false, "VisualFSM: Method \"is_triggered\" is unimplemented in event \"%s\"" % name)
	return false
