extends Area2D

var player = null
var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var speed = 4

func _ready() -> void:
	look_at(player.global_position)
	direction = player.global_position - global_position

func _physics_process(delta: float) -> void:
	velocity = velocity.move_toward(direction , delta)
	velocity = velocity.normalized() * speed
	position += velocity

