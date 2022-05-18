extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


const RADIUS = 0
const POSITION = Vector2(0, 0)


export(int) var width =  500
export(int) var height =  500
export(int) var tile_row = 4
export(int) var tile_column = 4

var item_temp = preload("res://background/BackgroundItem.tscn")
var style = StyleBoxFlat.new()
var size = Vector2(width, width)
var margin = 10
var sub_tile_width = 0
var sub_tile_height = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	style.set_corner_radius_all(RADIUS)
	style.bg_color = Color(1, 0, 0, 1)
	
	sub_tile_width = int((width - (tile_row+1)*margin) / tile_row)
	sub_tile_height = int((height - (tile_column+1)*margin) / tile_column)
	
	for row in range(tile_row):
		for colomn in range(tile_column):
			var item = item_temp.instance()
			item.size = Vector2(sub_tile_width, sub_tile_height)
			item.position = Vector2(colomn*sub_tile_height+(colomn+1)*margin, row*sub_tile_width+(row+1)*margin)
			add_child(item)
	
	pass # Replace with function body.

func get_tile_width():
	return sub_tile_width
	
func get_tile_height():
	return sub_tile_height
	

func _draw():
    draw_style_box(style, Rect2(POSITION, size))
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
