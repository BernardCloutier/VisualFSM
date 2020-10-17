tool
class_name VisualFiniteStateMachine
extends Resource

var _states := {} # name to VisualFiniteStateMachineState
var _events := {} # name to VisualFiniteStateMachineEvent
var _transitions := {
#	from_state_name_1: {
#		event_name_1: to_state_name_1,
#		event_name_2: to_state_name_2
#		etc...
#	},
#	from_state_name_1: {
#		etc...
#	},
#	etc...
}


func has_state(name: String) -> bool:
	return _states.has(name)


func get_state(name: String) -> VisualFiniteStateMachineState:
	return _states[name]


func get_state_event_names(name: String) -> Array:
	assert(_transitions.has(name), "Missing state: %s" % name)
	return _transitions[name].keys()


func get_states() -> Array:
	return _states.values()


func add_state(state: VisualFiniteStateMachineState) -> void:
	if not _transitions.has(state.name):
#		print("Added transition for state %s" % state.name)
		_transitions[state.name] = {}
	_states[state.name] = state
	emit_signal("changed")


func remove_state(state_name: String) -> void:
	assert(_states.has(state_name), "Missing state: %s" % state_name)
	_states.erase(state_name)
	_transitions.erase(state_name)
	for from in _transitions.keys():
		for event in _transitions[from].keys():
			if state_name == _transitions[from][event]:
				_transitions[from][event] = ""
	emit_signal("changed")


func rename_state(name: String, new_name: String) -> void:
	var state: VisualFiniteStateMachineState = _states[name]
	state.name = new_name
	_states.erase(name)
	_states[new_name] = state
	var transitions: Dictionary = _transitions[name]
	_transitions.erase(name)
	_transitions[new_name] = transitions
	emit_signal("changed")


func has_event(name: String) -> bool:
	return _events.has(name)


func get_event(name: String) -> VisualFiniteStateMachineEvent:
	return _events[name]


func get_event_names() -> Array:
	return _events.keys()


func add_event(event: VisualFiniteStateMachineEvent) -> void:
	_events[event.name] = event
	emit_signal("changed")


func remove_event(event: VisualFiniteStateMachineEvent) -> void:
	_events[event.name] = null
	for state_name in _states.keys():
		_states[state_name].erase(event.name)
	emit_signal("changed")


func remove_state_event(state_name: String, event_name: String) -> void:
	assert(_transitions.has(state_name))
	_transitions[state_name].erase(event_name)
	emit_signal("changed")


func get_transitions() -> Array:
	var transitions := []
	for from in _transitions.keys():
		for event in _transitions[from].keys():
			transitions.push_back({
				"from": from,
				"event": event,
				"to": _transitions[from][event]
			})
	return transitions


func add_transition(from: String, event_name: String, to: String = ""):
	assert(_states.has(from), "Missing state: %s" % from)
	assert(_transitions.has(from), "Missing state: %s" % from)
	assert(_events.has(event_name), "Missing event: %s" % event_name)

	_transitions[from][event_name] = to
	emit_signal("changed")


func remove_transition(from: String, event_name: String):
	add_transition(from, event_name)


func _get(property: String):
#	print("FSM: Getting property: %s" % property)
	match property:
		"states":
#			var name: String = parts[1]
#			return _states[name]
			return _states.values()
		"events":
			return _events.values()
		"transitions":
			var transitions := []
			for from in _transitions.keys():
				if 0 == _transitions[from].keys().size():
					transitions += [from, "", ""]
				for event in _transitions[from].keys():
					var to = _transitions[from][event]
					transitions += [
						from,
						event,
						to
					]
			return transitions
	return null


func _set(property: String, value) -> bool:
	match property:
		"states":
			for state in value:
				add_state(state)
			return true
		"events":
			for event in value:
				add_event(event)
			return true
		"transitions":
			var num_transitions = value.size() / 3
			for idx in range(num_transitions):
				var from = value[3 * idx]
				var event = value[3 * idx + 1]
				var to = value[3 * idx + 2]
				if event.empty():
					_transitions[from] = {}
				else:
					add_transition(from, event, to)
			return true
	return false


func _get_property_list() -> Array:
	var property_list := []
#	for stat
	property_list += [
			{
				"name": "states",
				"type": TYPE_ARRAY,
				"hint": PROPERTY_HINT_NONE,
				"hint_string": "",
				"usage": PROPERTY_USAGE_NOEDITOR
			},
			{
				"name": "events",
				"type": TYPE_ARRAY,
				"hint": PROPERTY_HINT_NONE,
				"hint_string": "",
				"usage": PROPERTY_USAGE_NOEDITOR
			},
			{
				"name": "transitions",
				"type": TYPE_ARRAY,
				"hint": PROPERTY_HINT_NONE,
				"hint_string": "",
				"usage": PROPERTY_USAGE_NOEDITOR
			}
		]

	return property_list