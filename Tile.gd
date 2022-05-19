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
const RADIUS = 5

var POSITION = Vector2(0, 0)
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
var style = StyleBoxFlat.new()
var color = null
var size = Vector2(142, 142)

# Called when the node enters the scene tree for the first time.
func _ready():
	style.set_corner_radius_all(RADIUS)
	if randf() > 0.95:
		set_second()
	else:
		set_first()
	#style.bg_color = Color(0, 1, 0.8, 1)
	self.size = size
	POSITION = Vector2(-(size.x/2), -(size.y/2))
	$Label.rect_size = size
	$Label.rect_position = POSITION
	pass # Replace with function body.

func set_size(size):
	self.size = size
	pass

func set_first():
	set_text(str(FIRST))
	
func set_second():
	set_text(str(SECOND))

func get_num():
	return int($Label.text)

func set_text(txt):
	$Label.text = str(txt)
	style.bg_color = cls[int($Label.text)]
	update()
	
func update_text():
	var x = int($Label.text)
	x += x
	set_text(x)


func _draw():
	draw_style_box(style, Rect2(POSITION, size))
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

