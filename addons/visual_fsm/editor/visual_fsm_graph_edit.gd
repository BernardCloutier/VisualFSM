tool
extends GraphEdit

var _fsm: VisualFiniteStateMachine
var _popup_options := ["New state", "New transition", "save", "load"]
var _popup: PopupMenu


func _ready() -> void:
	connect("popup_request", self, "_on_popup_request")

	_popup = PopupMenu.new()
	_popup.connect("index_pressed", self, "_on_popup_index_pressed")
	_popup.connect("focus_exited", _popup, "hide")
	for opt in _popup_options:
		_popup.add_item(opt)
	add_child(_popup)


func edit(fsm: VisualFiniteStateMachine) -> void:
	if _fsm:
		_fsm.disconnect("changed", self, "_on_fsm_changed")
	_fsm = fsm
	_fsm.connect("changed", self, "_on_fsm_changed")
	_redraw_graph()


func _on_fsm_changed():
	_redraw_graph()


func _redraw_graph():
	print("Redrawing fsm graph.............")
	# clear graph elements
	for child in get_children():
		if child is VisualFSMStateNode:
			remove_child(child)
			child.queue_free()

	# add state nodes
	for state in _fsm.get_states():
		print("VisualFSMGraphEdit: adding state node: " + state.name)
		var state_node = VisualFSMStateNode.new()
		state_node.name = state.name
		# center node on position
		state_node.offset = state.position - state_node.rect_size / 2
		add_child(state_node)

	# add transition nodes
	# for transition in _fsm.get_transition():
		# add_connection .... 

func _on_popup_request(position: Vector2) -> void:
	_popup.set_position(position)
	_popup.show()


func _on_popup_index_pressed(index: int) -> void:
	match index:
		0:
			print("adding new state...")
			var mouse_pos: Vector2 = get_parent().get_local_mouse_position()
			var base_name := "test"
			var state_name := base_name
			var suffix := 1
			while _fsm.has_state(state_name):
				state_name = base_name + str(suffix)
				suffix += 1
			_fsm.add_state(state_name, mouse_pos)
		1:
			print("adding new transition...")
