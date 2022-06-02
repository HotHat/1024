extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (String) var id = "4x4"

var check_status = true




# Called when the node enters the scene tree for the first time.
func _ready():
	checked()
	pass

func set_alpha(v=1):
	$TextureRect.get_material().set_shader_param("alpha", v)

func checked():
	set_alpha()
	check_status = true

func unchecked():
	set_alpha(0.3)
	check_status = false

func is_checked():
	return check_status

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_L3x5_pressed():
	var Scene = preload("res://level/L4x4.tscn")
	# s.init(5, 3)
	get_tree().change_scene_to(Scene)
	pass # Replace with function body.


func _on_L4x6_pressed():
	var Scene = preload("res://level/L3x5.tscn")
	get_tree().change_scene_to(Scene)
	pass # Replace with function body.


func _on_L4x4_pressed():
	var Scene = preload("res://level/L4x4.tscn")
	get_tree().change_scene_to(Scene)
	pass # Replace with function body.


func _on_L5x5_pressed():
	var Scene = preload("res://level/L5x5.tscn")
	get_tree().change_scene_to(Scene)
	pass # Replace with function body.


func _on_L6x6_pressed():
	var Scene = preload("res://level/L6x6.tscn")
	get_tree().change_scene_to(Scene)
	pass # Replace with function body.


func _on_L8x8_pressed():
	var Scene = preload("res://level/L8x8.tscn")
	get_tree().change_scene_to(Scene)
	pass # Replace with function body.
