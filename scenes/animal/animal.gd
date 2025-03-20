extends RigidBody2D


enum AnimalState {Ready, Drag, Release}


const DRAG_LIM_MAX: Vector2 = Vector2(0, 60)
const DRAG_LIM_MIN: Vector2 = Vector2(-60, 0)
const IMPULSE_MULT: float = 20.0
const IMPULSE_MAX: float = 1200.0

@onready var debug_label: Label = $DebugLabel
@onready var arrow: Sprite2D = $Arrow
@onready var stretch_sound: AudioStreamPlayer2D = $StretchSound
@onready var launch_sound: AudioStreamPlayer2D = $LaunchSound
@onready var kick_sound: AudioStreamPlayer2D = $KickSound

var _state: AnimalState = AnimalState.Ready
var _start: Vector2 = Vector2.ZERO
var _dragged_vector: Vector2 = Vector2.ZERO
var _drag_start: Vector2 = Vector2.ZERO
var _arrow_scale_x: float = 0.0

func _unhandled_input(event: InputEvent) -> void:
	if _state == AnimalState.Drag and event.is_action_released("drag"):
		#make sure thread is finished before change state
		call_deferred("change_state", AnimalState.Release)
		

func _ready() -> void:
	setup() # Replace with function body.

func setup() -> void:
	print("Arrow Scale: " + str( arrow.scale.x))
	_arrow_scale_x = arrow.scale.x
	arrow.hide()
	_start = position

func _physics_process(delta: float) -> void:
	update_state()
	update_debug_label()

#region misc
func update_debug_label() -> void:
	var ds: String = "ST:%s SL:%s FR:%s\n" % [
		AnimalState.keys()[_state], sleeping, freeze
	]
	ds += "_drag_start: %.1f, %.1f\n" % [_drag_start.x, _drag_start.y]
	ds += "_dragged_vector: %.1f, %.1f" % [_dragged_vector.x, _dragged_vector.y]
	debug_label.text = ds
	
#endregion

#region drag

func update_arrow_scale() -> void:
	#cal the hypothenus of the impulse
	var imp_len: float = calculate_impulse().length()
	var perc: float = clamp(imp_len / IMPULSE_MAX, 0.0, 1.0)
	arrow.scale.x = lerp(_arrow_scale_x , _arrow_scale_x * 2, perc)
	arrow.rotation = (_start - position).angle()

func start_dragging() -> void:
	arrow.show()
	_drag_start =  get_global_mouse_position()

func handle_dragging() -> void: 
	var new_drag_vector: Vector2 = get_global_mouse_position() - _drag_start
	
	_dragged_vector = new_drag_vector.clamp(
		DRAG_LIM_MIN, DRAG_LIM_MAX
	)
	
	var diff: Vector2 = new_drag_vector - _dragged_vector
	
	if diff.length() > 0 and not stretch_sound.playing:
		stretch_sound.play()
		
	
	_dragged_vector = new_drag_vector
	position = _start + _dragged_vector
	
	update_arrow_scale()
#endregion

#region release

func calculate_impulse() -> Vector2:
	return _dragged_vector * -IMPULSE_MULT

func start_release() -> void:
	arrow.hide()
	launch_sound.play()
	freeze = false
	apply_central_impulse(calculate_impulse())
	SignalHub.emit_on_attempt_made()

#endregion
#region state

func update_state() -> void:
	match _state: 
		AnimalState.Drag:
			handle_dragging()

func change_state(new_state: AnimalState) -> void:
	if _state == new_state:
		return
		
	_state = new_state
	match _state: 
		AnimalState.Drag:
			start_dragging()
		AnimalState.Release:
			start_release()

#endregion

#region signals
	
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("drag") and _state == AnimalState.Ready:
		change_state(AnimalState.Drag)


func die() -> void:
	SignalHub.emit_on_animal_died()
	queue_free()

func _on_screen_exited() -> void:
	die() # Replace with function body.


func _on_sleeping_state_changed() -> void:
	if sleeping:
		for body in get_colliding_bodies():
			if body is Cup:
				body.die()	
		call_deferred("die")



func _on_body_entered(body: Node) -> void:
	if body is Cup and not kick_sound.playing:
		kick_sound.play() # Replace with function body.
