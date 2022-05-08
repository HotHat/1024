extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (Vector2) var ps = Vector2()
export (int) var target = 0
export (Vector2) var target_pos = Vector2()
export (bool) var is_update = false
export (bool) var is_finish = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_num():
	return int($Label.text)

func set_text(txt):
	$Label.text = txt
	
func update_text():
	var x = int($Label.text)
	x += x
	$Label.text = str(x)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

