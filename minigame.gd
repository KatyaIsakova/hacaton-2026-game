extends Node2D

var score = 0
var time_left = 15
var coin_speed = 500.0

@onready var coin = $Coin
@onready var basket = $Basket
@onready var score_label = $ScoreLabel
@onready var time_label = $TimeLabel
@onready var timer = $Timer

func _ready():
 timer.timeout.connect(_on_timer_tick)
 timer.start()
 _reset_coin()
 _hide_hint_after_delay()

func _hide_hint_after_delay():
 await get_tree().create_timer(4.0).timeout
 if is_instance_valid($HintLabel):
  $HintLabel.visible = false

func _process(delta):
 coin.position.y += coin_speed * delta
 
 if coin.position.y > basket.position.y - 30 and coin.position.y < basket.position.y + 30:
  if abs(coin.position.x - basket.position.x) < 70:
   score += 3
   score_label.text = "Монеты: " + str(score)
   _reset_coin()
 
 if coin.position.y > 1280:
  _reset_coin()

func _input(event):
 if event is InputEventKey and event.pressed:
  if event.keycode == KEY_LEFT:
   basket.position.x -= 80
  elif event.keycode == KEY_RIGHT:
   basket.position.x += 80
  basket.position.x = clamp(basket.position.x, 60, 660)
 
 if event is InputEventScreenTouch and event.pressed:
  basket.position.x = clamp(event.position.x, 60, 660)
 elif event is InputEventScreenDrag:
  basket.position.x = clamp(event.position.x, 60, 660)

func _reset_coin():
 coin.position = Vector2(randf_range(80, 640), -50)

func _on_timer_tick():
 time_left -= 1
 time_label.text = "Время: " + str(time_left)
 if time_left <= 0:
  _end_game()

func _end_game():
 timer.stop()
 Global.coins += score
 Global.experience += 2
 get_tree().change_scene_to_file("res://main.tscn")
