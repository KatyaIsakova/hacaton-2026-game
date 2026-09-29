extends Node2D

func _style_button(button: Button, color: Color):
 var style = StyleBoxFlat.new()
 style.bg_color = color
 style.corner_radius_top_left = 20
 style.corner_radius_top_right = 20
 style.corner_radius_bottom_left = 20
 style.corner_radius_bottom_right = 20
 style.content_margin_left = 20
 style.content_margin_right = 20
 style.content_margin_top = 10
 style.content_margin_bottom = 10
 button.add_theme_stylebox_override("normal", style)
 
 var hover = style.duplicate()
 hover.bg_color = color.lightened(0.15)
 button.add_theme_stylebox_override("hover", hover)
 
 var pressed = style.duplicate()
 pressed.bg_color = color.darkened(0.2)
 button.add_theme_stylebox_override("pressed", pressed)
 
 button.add_theme_color_override("font_color", Color.WHITE)
 button.add_theme_color_override("font_hover_color", Color.WHITE)
 button.add_theme_color_override("font_pressed_color", Color.WHITE)
 button.add_theme_font_size_override("font_size", 26)

@export var money_label: Label
@export var savings_label: Label
@export var period_label: Label
@export var stage_label: Label
@export var hunger_bar: ProgressBar
@export var happiness_bar: ProgressBar
@export var pet: Sprite2D
@export var mood_bubble: TextureRect
@export var experience_label: Label

@export var feed_button: Button
@export var treat_button: Button
@export var play_button: Button
@export var work_button: Button
@export var tasks_button: Button
@export var end_period_button: Button

@export var start_screen: Control
@export var panda_button: Button
@export var penguin_button: Button
@export var giraffe_button: Button
@export var panda_texture: Texture2D
@export var penguin_texture: Texture2D
@export var giraffe_texture: Texture2D

@export var stage1_texture: Texture2D
@export var stage2_texture: Texture2D
@export var stage3_texture: Texture2D

@export var tex_happy: Texture2D
@export var tex_angry: Texture2D
@export var tex_sad: Texture2D
@export var tex_cash: Texture2D
@export var tex_hearts: Texture2D


func _ready():
 if Global.pet_chosen:
  start_screen.visible = false
  update_stage()
 else:
  start_screen.visible = true
 _style_button(feed_button, Color(0.4, 0.75, 0.4))       # зелёный — покормить
 _style_button(treat_button, Color(0.9, 0.55, 0.7))      # розовый — вкусняшка
 _style_button(play_button, Color(0.4, 0.65, 0.9))       # синий — поиграть
 _style_button(work_button, Color(0.85, 0.65, 0.2))      # золотой — работать
 _style_button(tasks_button, Color(0.6, 0.45, 0.85))     # фиолетовый — задания
 _style_button(end_period_button, Color(0.85, 0.4, 0.4)) # красный — завершить период


 feed_button.pressed.connect(_on_feed_pressed)
 treat_button.pressed.connect(_on_treat_pressed)
 play_button.pressed.connect(_on_play_pressed)
 work_button.pressed.connect(_on_work_pressed)
 tasks_button.pressed.connect(_on_tasks_pressed)
 end_period_button.pressed.connect(_on_end_period_pressed)

 panda_button.pressed.connect(_on_panda_chosen)
 penguin_button.pressed.connect(_on_penguin_chosen)
 giraffe_button.pressed.connect(_on_giraffe_chosen)


 update_ui()
 update_stage()
 check_status()


func update_ui():
 money_label.text = "🪙 " + str(int(Global.coins))
 if savings_label:
  savings_label.text = "💰 Копилка: " + str(int(Global.savings))
 if period_label:
  period_label.text = "Период: " + str(Global.period) + "/" + str(Global.max_periods)
 if stage_label:
  stage_label.text = "Стадия: " + str(Global.stage)
 if experience_label:
  var next_need = 0
  if Global.stage == 1:
   next_need = 6
  elif Global.stage == 2:
   next_need = 15
  else:
   next_need = Global.experience
 
  if Global.stage >= 3:
   experience_label.text = "⭐ Опыт: " + str(Global.experience) + " (максимум)"
   experience_label.add_theme_color_override("font_color", Color(0.2, 0.6, 0.2))
  else:
   experience_label.text = "⭐ Опыт: " + str(Global.experience) + " / " + str(next_need)
   if Global.experience >= next_need:
    experience_label.add_theme_color_override("font_color", Color(0.2, 0.7, 0.2))
   else:
    experience_label.add_theme_color_override("font_color", Color(0.1, 0.15, 0.35))
 hunger_bar.value = Global.pet_hunger
 happiness_bar.value = Global.pet_happiness

func update_stage():
 match Global.pet_type:
  "panda":
    pet.texture = panda_texture
  "penguin":
    pet.texture = penguin_texture
  "giraffe":
    pet.texture = giraffe_texture
  _:
    pet.texture = panda_texture
 var s = 0.7 + (Global.stage - 1) * 0.15
 pet.scale = Vector2(s,s)

func check_status():
 if Global.pet_hunger < 30:
  mood_bubble.texture = tex_angry
 elif Global.pet_happiness < 30:
  mood_bubble.texture = tex_sad
 else:
  mood_bubble.texture = tex_happy

func _on_feed_pressed():
 if Global.coins >= 5:
  Global.coins -= 5
  Global.pet_hunger = min(100, Global.pet_hunger + 15)
  mood_bubble.texture = tex_hearts
  update_ui()
  await get_tree().create_timer(1.0).timeout
  check_status()
 else:
  _show_no_money()

func _on_treat_pressed():
 if Global.coins >= 20:
  Global.coins -= 20
  Global.pet_hunger = min(100, Global.pet_hunger + 50)
  mood_bubble.texture = tex_hearts
  update_ui()
  await get_tree().create_timer(1.0).timeout
  check_status()
 else:
  _show_no_money()

func _on_play_pressed():
 if Global.coins >= 30:
  Global.coins -= 30
  Global.pet_happiness = min(100, Global.pet_happiness + 40)
  mood_bubble.texture = tex_hearts
  update_ui()
  await get_tree().create_timer(1.0).timeout
  check_status()
 else:
  _show_no_money()

func _show_no_money():
 print("Недостаточно монет!")
 if mood_bubble:
  mood_bubble.texture = tex_sad

func _on_work_pressed():
 Global.pet_hunger = max(10, Global.pet_hunger - 20)
 Global.pet_happiness = max(10, Global.pet_happiness - 15)
 update_ui()
 check_status()
 get_tree().change_scene_to_file("res://minigame.tscn")

func _on_tasks_pressed():
 get_tree().change_scene_to_file("res://task_list.tscn")


func _on_panda_chosen():
 Global.pet_chosen = true
 Global.pet_type = "panda"
 Global.stage = 1
 start_screen.visible = false
 update_stage()

func _on_penguin_chosen():
 Global.pet_chosen = true
 Global.pet_type = "penguin"
 Global.stage = 1
 start_screen.visible = false
 update_stage()

func _on_giraffe_chosen():
 Global.pet_chosen = true
 Global.pet_type = "giraffe"
 Global.stage = 1
 start_screen.visible = false
 update_stage()

func _on_end_period_pressed():
 var bonus = Global.completed_tasks.size() * 2
 Global.coins += bonus
 Global.savings += bonus * 0.5
 
 Global.pet_hunger = max(30, Global.pet_hunger - 50)
 Global.pet_happiness = max(30, Global.pet_happiness - 40)
 
 Global.experience += Global.completed_tasks.size()
 if Global.experience >= 6 and Global.stage == 1:
  Global.stage = 2
 elif Global.experience >= 15 and Global.stage == 2:
  Global.stage = 3
 
 Global.period += 1
 Global.completed_tasks.clear()
 
 if Global.period > Global.max_periods:
  Global.game_over = true
  print("Демо завершено! Молодец!")
  await get_tree().create_timer(2.0).timeout
  Global.reset_for_new_game()
  get_tree().reload_current_scene()
  return
 
 update_ui()
 update_stage()
 check_status()
 print("Период " + str(Global.period) + " начался!")
