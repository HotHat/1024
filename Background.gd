extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Title.position = $Pos00.position
	$Title2.position = $Pos10.position
	$Title3.position = $Pos20.position
	$Title4.position = $Pos30.position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
