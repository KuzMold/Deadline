extends Area2D


var offset := Vector2.ZERO
var mouse_over  = false



var dragging = false

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# Проверяем, находится ли мышь на объекте
			if mouse_over:
				dragging = true
		else:
			dragging = false
	
	if event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position()



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
	mouse_over = true
	var tween = create_tween()
	tween.tween_property(animated_sprite_2d, "rotation_degrees", rotation_angle, animation_speed)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
		
func _on_mouse_exited():
	mouse_over = false
	var tween = create_tween()
	tween.tween_property(animated_sprite_2d, "rotation_degrees", 0.0, animation_speed)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
