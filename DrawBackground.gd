extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(float) var width =  500
var style = StyleBoxFlat.new()
const RADIUS = 1
const POSITION = Vector2(0, 0)
var size = Vector2(width, width)
export(int) var tile_row = 4
export(int) var tile_column = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	style.set_corner_radius_all(RADIUS)
	style.bg_color = Color(1, 0, 0, 1)
	
	
	pass # Replace with function body.


func _draw():

    draw_style_box(style, Rect2(POSITION, size))
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
