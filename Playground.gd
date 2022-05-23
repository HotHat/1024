extends Node2D


enum {LEFT, RIGHT, UP, DOWN}
const SWIPE_MINI_LENGTH = 100
const GAME_TARGET = 8
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (int) var speed = 500

var move_dir = LEFT
var move_target = Vector2()
var start = false
var time = 0
var need_move = false
var time_direction = 1
var Tile = preload("res://Tile.tscn")
var CorrectSound = preload("res://audio/tile_match.wav")

var velocity = Vector2()

var touch_start_pos

var pos_matrix = []
var tile_size = Vector2()
var tile_row = 4
var tile_column = 4
var tile_matrix = []

var instance_list = []

func rand_pos():
	var rn = randi() % (tile_row*tile_column)
	return Vector2(int(rn/tile_row), rn%tile_column)

func play_match():
	$AudioStreamPlayer2D.stream = CorrectSound
	$AudioStreamPlayer2D.play()

func is_exist(vec):
	if tile_matrix[vec.x][vec.y] != null:
		return true
	return false
	
func is_move():
	if need_move:
		need_move = false
		return true
	else:
		return false
	
func is_success():
	pass
	
func set_move_status():
	for x in range(tile_row):
		for y in range(tile_column):
			var i = tile_matrix[x][y]
			if i != null and i.ps != i.target_pos:
				need_move = true
				return
	need_move = false
	
func is_fail():
	pass

func init_tile_matrix():
	for x in range(tile_row):
		var i = []
		for y in range(tile_column):
			i.append(null)
		tile_matrix.append(i)
		
func print_tile_matrix():
	for x in range(tile_row):
		for y in range(tile_column):
			var i = tile_matrix[x][y]
			if i == null:
				print(null)
			else:
				print(i.ps, i.get_num())
		print("-------------")
		
func move_tile():
	for x in range(tile_row):
		for y in range(tile_column):
			var tile = tile_matrix[x][y]
			if tile != null:
				move_target = get_target_vector(tile)
				tile.position = lerp(tile.position, move_target, time / 0.5)
	
func get_active_tile():
	var p = []
	for x in range(tile_row):
		for y in range(tile_column):
			var i = tile_matrix[x][y]
			if i != null:
				p.append(i)
	return p

func is_full():
	var i = 0
	for x in range(tile_row):
		for y in range(tile_column):
			if tile_matrix[x][y] != null:
				i = i + 1
	if i == (tile_row * tile_column):
		return true
	else:
		return false

func new_tile():
	var t = Tile.instance()
	t.set_size(tile_size)
	var rp = rand_pos()

	if is_full():
		return
	# if exist run againt/
	while is_exist(rp):
		print("new tile againt")
		rp = rand_pos()
		
	t.position = pos_matrix[int(rp.x)][int(rp.y)]
	t.ps = rp
	add_child(t)
	print("add tile at ", rp)
	# instance_list.append(t)
	tile_matrix[rp.x][rp.y] = t

func add_tile(row, col):
	var t = Tile.instance()
	t.set_size(tile_size)
	var rp = Vector2(row, col)
	t.set_text("2")
	t.position = pos_matrix[int(rp.x)][int(rp.y)]
	t.ps = rp
	add_child(t)
	# instance_list.append(t)
	tile_matrix[rp.x][rp.y] = t

# touch swape with direction
signal swipe_ready(dir)
signal tile_update_text(tile)

func _on_swipe_ready(dir):
	set_swipe(dir)

func _on_tile_update_text(tile):
	tile.is_update = false
	tile.update_text()
	print("tile number update to ", tile.get_num())
	if tile.get_num() >= GAME_TARGET:
		print("Game Success")


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	init_tile_matrix()
	connect("swipe_ready", self, "_on_swipe_ready")
	#var bg = $Background.position
	#pos_matrix = [
	#	[$Background/Pos00.position+bg, $Background/Pos01.position+bg, $Background/Pos02.position+bg, $Background/Pos03.position+bg],
	#	[$Background/Pos10.position+bg, $Background/Pos11.position+bg, $Background/Pos12.position+bg, $Background/Pos13.position+bg],
	#	[$Background/Pos20.position+bg, $Background/Pos21.position+bg, $Background/Pos22.position+bg, $Background/Pos23.position+bg],
	#	[$Background/Pos30.position+bg, $Background/Pos31.position+bg, $Background/Pos32.position+bg, $Background/Pos33.position+bg],
	#]
	print("view_port: ", get_viewport_rect().size)
	var sz = get_viewport_rect().size
	var margin = 50
	var wd = min(sz.x, sz.y) - margin*2
	
	#$DrawBackground.position = Vector2(margin, sz.y/2-wd/2)
	$DrawBackground.set_row_column(tile_row, tile_column, Vector2(wd, wd))
	tile_size = $DrawBackground.get_tile_size()

	print("draw_background position in playground: ", $DrawBackground.position)
	pos_matrix = $DrawBackground.get_pos_matrix()
	print(pos_matrix)
	
	
	new_tile()
	new_tile()
	#add_tile(2, 0)
	#add_tile(2, 1)
	#add_tile(2, 2)
	#add_tile(2, 3)
	#add_tile(1, 2)
	#add_tile(3, 2)
	#add_tile(0, 2)
	#add_tile(2, 2)
	#print(point1)
	#print(point2)
	print_tile_matrix()
#	for i in instance_list:
#		print(i.position)


	#$UI/HomeButton.set_modulate(Color("#ff0000"))
	pass # Replace with function body.


func set_swipe(dir):
	velocity = Vector2()
	if dir == RIGHT:
		#print("right pressed")
		time_direction = 1
		move_dir = RIGHT
		velocity.x += 1

	if dir == LEFT:
		#print("left pressed")
		time_direction = 1
		move_dir = LEFT
		velocity.x -= 1

	if dir == DOWN:
		time_direction = 1
		move_dir = DOWN
		velocity.y += 1

	if dir == UP:
		time_direction = 1
		move_dir = UP
		velocity.y -= 1

	if velocity.length() > 0:
		print("start move")
		start = true
		set_target_vector()
		set_move_status()
		print("move: ", need_move)


func finish_tile(tile):
	#print("pos: ", tile.ps, " --> ", tile.is_update, tile.is_finish)
	#print("ps: ", tile.ps)
	#print("---------finish tile-----------")
	#print(tile.ps, " to ", tile.target_pos, "; up: ", tile.is_update, " fin: ", tile.is_finish)
	tile_matrix[tile.ps.x][tile.ps.y] = null
	tile.ps = tile.target_pos
	if tile.is_update:
		_on_tile_update_text(tile)
		tile.zoom()
		play_match()
		
	if tile.is_finish:
		tile.queue_free()

	if not tile.is_finish:
		tile_matrix[tile.ps.x][tile.ps.y] = tile

func is_all_stop():
	var p = []
	var tile = null
	for x in range(tile_row):
		for y in range(tile_column):
			tile = tile_matrix[x][y]
			if tile == null:
				continue
				
			var n = tile.target_pos
			move_target = pos_matrix[n.x][n.y]
			#print("tile:", tile.ps, " forahead: ", n)
			if move_dir == LEFT:
				if tile.position.x > move_target.x:
					return false
				else:
					p.append(tile)

			elif move_dir == RIGHT:
				if tile.position.x < move_target.x:
					return false
				else:
					p.append(tile)

			elif move_dir == UP:
				if tile.position.y > move_target.y:
					return false
				else:
					p.append(tile)

			elif move_dir == DOWN:
				if tile.position.y < move_target.y:
					return false
				else:
					p.append(tile)
	for i in p:
		finish_tile(i)
		#print("is_finish: ", tile.is_finish, " is_update: ", tile.is_update)
	return true


func get_row(dir, row):
	var p = []
	for i in range(tile_column):
		if tile_matrix[row][i] != null:
			p.append(tile_matrix[row][i])
	if dir == LEFT and not p.empty():
		p.invert()
	return p

func get_column(dir, col):
	var p = []
	for i in range(tile_row):
		if tile_matrix[i][col] != null:
			p.append(tile_matrix[i][col])
	if dir == UP and not p.empty():
		p.invert()
	return p

func set_target_vector():
	var p = []
	if move_dir == LEFT or move_dir == RIGHT:
		for i in range(tile_row):
			p = get_row(move_dir, i)
			# show all target
			set_target_num(p, move_dir)
			print("------------------move target-------------------")
			for j in p:
				print(j.ps, " to ", j.target_pos, "; up: ", j.is_update, " fin: ", j.is_finish)
			print("------------------end move target---------------")
	if move_dir == UP or move_dir == DOWN:
		for i in range(tile_column):
			p = get_column(move_dir, i)
			# show all target
			set_target_num(p, move_dir)
			print("------------------move target-------------------")
			for j in p:
				print(j.ps, " to ", j.target_pos, "; up: ", j.is_update, " fin: ", j.is_finish)
			print("------------------end move target---------------")
		# if len(p) > 0:
	pass
 
# set
func set_target_num(p, dir):
	var lst_len = len(p) - 1
	var is_del = true
	var overlay = 0
	var ln = len(p)

	while lst_len > -1:
		# if lst_len < len(p) - 1:
		#print(lst_len, "----------", len(p)-2, "---------", p[lst_len].get_num(), "-------")
		if lst_len <= len(p) - 2 and p[lst_len].get_num() == p[lst_len + 1].get_num():
			if lst_len+2 < len(p) and p[lst_len].get_num() == p[lst_len + 2].get_num() and not is_del:
				#print('not need show')
				is_del = true
			else:
				is_del = false
				#print("index: ", lst_len, " value: ", p[lst_len])
				if dir == RIGHT:
					p[lst_len+1].is_update = true
					p[lst_len].is_finish = true
				else:
					p[lst_len+1].is_update = true
					p[lst_len].is_finish = true
				#print(p[lst_len+1].ps, "------",  p[lst_len].ps)
				#print(p[lst_len+1].is_update, "   ", p[lst_len+1].is_finish)
				#print(p[lst_len].is_update, "   ", p[lst_len].is_finish)
				overlay += 1
		# set target vector
		if dir == RIGHT:
			p[lst_len].target_pos.y = tile_column-(ln-lst_len)+overlay
			p[lst_len].target_pos.x = p[lst_len].ps.x

		elif dir == LEFT:
			p[lst_len].target_pos.y = ln-lst_len-overlay-1
			p[lst_len].target_pos.x = p[lst_len].ps.x
			#print(p[lst_len].ps, "---------", p[lst_len].target_pos)

		elif dir == DOWN:
			p[lst_len].target_pos.x = tile_row-(ln-lst_len)+overlay
			p[lst_len].target_pos.y = p[lst_len].ps.y
		elif dir == UP:
			p[lst_len].target_pos.x = ln-lst_len-overlay-1
			p[lst_len].target_pos.y = p[lst_len].ps.y
		# next one
		lst_len -= 1


func get_target_vector(tile):
	return pos_matrix[tile.target_pos.x][tile.target_pos.y]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# print(delta)
	if not start:
		pass
		#get_input()

	if start:
		time += delta * time_direction

		move_tile()

		if is_all_stop():
			print("all stop")
			start = false
			time = 0
			if is_move():
				#pass
				new_tile()
			print("---------after all stop------------")
			for i in instance_list:
				print("vec: ", i.ps, "pos", i.position, "num: ", i.get_num())
			pass

func _input(event):
	#print("touch detect")
	if event is InputEventScreenTouch and event.is_pressed():
		touch_start_pos = event.position
		print("touch start...")
	if event is InputEventScreenDrag:
		#print("screen drag")
		pass

	if event is InputEventScreenTouch and not event.is_pressed():
		print("touch end...")
		var cur = event.position
		var x = abs(cur.x - touch_start_pos.x)
		var y = abs(cur.y - touch_start_pos.y)
		# left or right
		if x > y:
			if x < SWIPE_MINI_LENGTH:
				return
			# right
			if cur.x > touch_start_pos.x:
				emit_signal("swipe_ready", RIGHT)
			else:
				emit_signal("swipe_ready", LEFT)
		# up or down
		else:
			if y < SWIPE_MINI_LENGTH:
				return
			# down
			if cur.y > touch_start_pos.y:
				emit_signal("swipe_ready", DOWN)
			else:
				emit_signal("swipe_ready", UP)



# Signal connect
func _on_HomeButton_pressed():
	print("HomeButton Pressed")
	pass
	
func _on_ResetButton_pressed():
	print("ResetButton Pressed")
	pass	

func _on_ReloadButton_pressed():
	print("ReloadButton Pressed")
	
	
