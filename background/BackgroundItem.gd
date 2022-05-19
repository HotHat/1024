extends Node2D


# Declare member variables here. Examples:

const RADIUS = 5
const POSITION = Vector2(0, 0)


var width = 150
var style = StyleBoxFlat.new()
var size = Vector2(width, width)
# Called when the node enters the scene tree for the first time.
func _ready():
	style.set_corner_radius_all(RADIUS)
	style.bg_color = Color("d6cdc4")

func set_size(size):
	self.size = size

func set_color(color):
	style.bg_color = color


func _draw():
	draw_style_box(style, Rect2(POSITION, size))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
