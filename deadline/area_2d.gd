extends Area2D

var selected_object: Area2D = null
var is_dragging := false
var offset := Vector2.ZERO

func _input (event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Проверяем, кликнули ли на объект
				var space_state = get_world_2d().direct_space_state
				var query = PhysicsPointQueryParameters2D.new()
				query.position = get_global_mouse_position()
				query.collide_with_areas = true
				query.collide_with_bodies = true
				
				var result = space_state.intersect_point(query)
				if result.size() > 0:
					selected_object = result[0].collider
					offset = selected_object.global_position - get_global_mouse_position()
					is_dragging = true
			else:
				is_dragging = false
				selected_object = null
				
	elif event is InputEventMouseMotion and is_dragging and selected_object:
		selected_object.global_position = get_global_mouse_position() + offset

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var rotation_angle: float = 15  # Угол в градусах
@export var animation_speed: float = 0.3

func _ready():
	# Убедимся, что смещение (offset) в центре
	if has_method("set_offset"):
		offset = Vector2.ZERO
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	var tween = create_tween()
	tween.tween_property(animated_sprite_2d, "rotation_degrees", rotation_angle, animation_speed)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
		
func _on_mouse_exited():
	var tween = create_tween()
	tween.tween_property(animated_sprite_2d, "rotation_degrees", 0.0, animation_speed)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
