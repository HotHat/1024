extends Node2D


enum {LEFT, RIGHT, UP, DOWN}
const SWIPE_MINI_LENGTH = 100
var GAME_TARGET = 128
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
var TileData = preload("res://TileData.gd")

var velocity = Vector2()

var touch_start_pos
var is_pause = false

var pos_matrix = []
var tile_size = Vector2()
export (int) var tile_row = 8
export (int) var tile_column = 8
var tile_matrix = []

var pre_instance_list = []

func pause():
	$UI/Dialog.visible = true
	is_pause = true
	set_process(false)

func win_pause():
	$UI/Win.visible = true
	is_pause = true
	set_process(false)
	
func recover():
	$UI/Dialog.visible = false
	is_pause = false
	set_process(true)

func win_recover():
	$UI/Win.visible = false
	is_pause = false
	set_process(true)

func gg_pause():
	$UI/GG.visible = true
	is_pause = true
	set_process(false)
	
func gg_recover():
	$UI/GG.visible = false
	is_pause = false
	set_process(true)	

func is_pause():
	return is_pause

func rand_pos():
	var p = []
	for x in range(tile_row):
		for y in range(tile_column):
			if tile_matrix[x][y] == null:
				p.append(Vector2(x, y))
	var n = len(p)
	var rn = randi() % n
	return p[rn]

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
	
func is_end():
	for row in range(tile_row):
		for col in range(tile_column):
			# left
			var left =  null
			if col > 0:
				left = tile_matrix[row][col-1].get_num()
			# right
			var right = null
			if col < tile_column-1:
				right = tile_matrix[row][col+1].get_num()
			# up
			var up = null
			if row > 0:
				up = tile_matrix[row-1][col].get_num()
			# down	
			var down = null 
			if row < tile_row-1:
				down = tile_matrix[row+1][col].get_num()
				
			var n = tile_matrix[row][col].get_num()
			if n == left or n == right or n == up or n == down:
				print('continue...')
			else:
				print('GG......')
				return true
	return false

func init_tile_matrix():
	tile_matrix = []
	for x in range(tile_row):
		var i = []
		for y in range(tile_column):
			i.append(null)
		tile_matrix.append(i)
		
func print_tile_matrix():
	print("--------------show tile matrix-----------")
	for x in range(tile_row):
		for y in range(tile_column):
			var i = tile_matrix[x][y]
			if i == null:
				printt(null)
			else:
				printt("tile: ", i, " pos: ", i.ps, "num: ", i.get_num())
		print("-----------------------")
	
	print("-------------end------------")
		
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
	if is_full():
		return
		
	var t = Tile.instance()
	t.set_size(tile_size)
	if randf() > 0.95:
		t.set_second()
	else:
		t.set_first()
		
	var rp = rand_pos()
	while is_exist(rp):
		print("new tile againt")
		rp = rand_pos()
		
	t.position = pos_matrix[int(rp.x)][int(rp.y)]
	t.ps = rp
	$Tile.add_child(t)
	print("add tile at ", rp)
	# instance_list.append(t)
	tile_matrix[rp.x][rp.y] = t

func add_tile(row, col, text="2"):
	var t = Tile.instance()
	t.set_size(tile_size)
	if tile_row == 9:
		t.set_font_size(24)
	elif tile_row == 8:
		t.set_font_size(28)
	elif tile_row == 6:
		t.set_font_size(32)
	
	var rp = Vector2(row, col)
	t.set_text(text)
	t.position = pos_matrix[int(rp.x)][int(rp.y)]
	t.ps = rp
	$Tile.add_child(t)
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
	# is success
	if tile.get_num() >= GAME_TARGET:
		win_pause()
		GAME_TARGET *= 2
		print("Game Success")

func init_tile():
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
func init_fail_tiles():
	add_tile(0, 0, '16')
	add_tile(0, 1, '4')
	add_tile(0, 2, '1024')
	#####
	add_tile(1, 0, '64')
	add_tile(1, 1, '16')
	add_tile(1, 2, '8')
	#####
	add_tile(2, 0, '2')
	add_tile(2, 1, '32')
	add_tile(2, 2, '128')
	#####
	add_tile(3, 0, '16')
	add_tile(3, 1, '8')
	add_tile(3, 2, '4')
	#####
	#add_tile(4, 0, '8')
	#add_tile(4, 1, '4')
	#add_tile(4, 2, '2')

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	init_tile_matrix()
	# signal connect
	connect("swipe_ready", self, "_on_swipe_ready")
	$UI/Dialog.connect("confirm_pressed", self, "_on_Confirm_pressed")
	$UI/Dialog.connect("cancel_pressed", self, "_on_Cancel_pressed")
	$UI/Win.connect("confirm_pressed", self, "_on_win_Confirm_pressed")
	$UI/Win.connect("cancel_pressed", self, "_on_win_Cancel_pressed")
	$UI/GG.connect("confirm_pressed", self, "_on_gg_Confirm_pressed")
	
	print("view_port: ", get_viewport_rect().size)
	var sz = get_viewport_rect().size
	var margin = 50
	var wd = min(sz.x, sz.y) - margin*2
	var wh = sz.y - $DrawBackground.position.y
	
	#$DrawBackground.position = Vector2(margin, sz.y/2-wd/2)
	var bg_size = Vector2(wd, wd)
	if tile_row > tile_column:
		bg_size = Vector2(wd, wh)
	$DrawBackground.set_row_column(tile_row, tile_column, bg_size)
	tile_size = $DrawBackground.get_tile_size()

	print("draw_background position in playground: ", $DrawBackground.position)
	pos_matrix = $DrawBackground.get_pos_matrix()
	print(pos_matrix)
	
	#init_tile()
	init_fail_tiles()
	#print(point1)
	#print(point2)
	print_tile_matrix()


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

	if tile.is_update:
		_on_tile_update_text(tile)
		tile.zoom()
		play_match()
		
	if tile.is_finish:
		$Tile.remove_child(tile)
		tile.queue_free()
	else:
		tile.ps = tile.target_pos
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
	pre_instance_list = []
	for i in p:
		var t = TileData.new(i.ps, i.get_num())
		pre_instance_list.append(t)
		tile_matrix[i.ps.x][i.ps.y] = null
		
	for i in p:
		print("tile: ", i, " pos:", i.ps, " is_upadte: ", i.is_update, " is_fin: ", i.is_finish, "  target: ", i.target_pos)
		finish_tile(i)
	print_tile_matrix()
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
		return
		#get_input()


	time += delta * time_direction

	move_tile()

	if is_all_stop():
		print("all stop")
		start = false
		time = 0
		print_tile_matrix()
		if is_full():
			if is_end():
				print('game is end...')
				gg_pause()
		else:
			if is_move():
				new_tile()
				pass

			#print("---------after all stop------------")
			#for i in instance_list:
			#	print("vec: ", i.ps, "pos", i.position, "num: ", i.get_num())
			#pass

func _input(event):
	if is_pause():
		return
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

func delete_children():
	for n in $Tile.get_children():
		$Tile.remove_child(n)
		n.queue_free()

# Signal connect
func _on_HomeButton_pressed():
	print("HomeButton Pressed")
	pass
	
func _on_ResetButton_pressed():
	print("ResetButton Pressed")
	if pre_instance_list.empty() or is_pause():
		return
	init_tile_matrix()
	delete_children()
	for i in pre_instance_list:
		add_tile(i.pos.x, i.pos.y, str(i.num))
	pre_instance_list = []

func _on_ReloadButton_pressed():
	print("ReloadButton Pressed")
	pause()

func new_game():
	init_tile_matrix()
	delete_children()
	init_tile()
	print_tile_matrix()
	
func _on_Confirm_pressed():
	print("confirm pressed")
	new_game()
	recover()

func _on_Cancel_pressed():
	print("cancel pressed")	
	recover()
	
func _on_win_Confirm_pressed():
	print("confirm pressed")
	win_recover()

func _on_win_Cancel_pressed():
	print("cancel pressed")	
	new_game()
	win_recover()

func _on_gg_Confirm_pressed():
	new_game()
	gg_recover()
