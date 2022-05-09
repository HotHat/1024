extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (Vector2) var ps = Vector2()
export (int) var target = 0
export (Vector2) var target_pos = Vector2()
export (bool) var is_update = false
export (bool) var is_finish = false

const FIRST = 2
const SECOND = 4

var cls = {
	2: Color("#eee4da"),
	4: Color("#ede0c8"),
	8: Color("#f2b179"),
	16: Color("#f59563"),
	32: Color("#f67c5f"),
	64: Color("#f65e3b"),
	128: Color("#edcf72"),
	256: Color("#edcc61"),
	512: Color("#edc850"),
	1024: Color("#edc53f")
}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_first():
	$Label.text = str(FIRST)
	$Sprite.self_modulate = cls[FIRST]
	
func set_second():
	$Label.text = str(SECOND)
	$Sprite.self_modulate = cls[SECOND]

func get_num():
	return int($Label.text)

func set_text(txt):
	$Label.text = str(txt)
	print(cls)
	$Sprite.self_modulate = cls[int($Label.text)]
	
func update_text():
	var x = int($Label.text)
	x += x
	set_text(x)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

