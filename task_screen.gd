extends Control

@onready var theme_label = $ThemeLabel
@onready var question_label = $QuestionLabel
@onready var option1 = $Option1
@onready var option2 = $Option2
@onready var hint_label = $HintLabel

var task_data: Dictionary
var task_id: String

func _ready():
 task_id = Global.current_task
 if task_id == "":
  get_tree().change_scene_to_file("res://main.tscn")
  return
 task_data = Global.tasks[task_id]
 
 theme_label.text = "Тема: " + task_data["theme"]
 question_label.text = task_data["question"]
 option1.text = task_data["options"][0]
 option2.text = task_data["options"][1]
 hint_label.text = ""
 var dark_blue = Color(0.1, 0.15, 0.35)

 theme_label.add_theme_color_override("font_color", dark_blue)
 question_label.add_theme_color_override("font_color", dark_blue)
 option1.add_theme_color_override("font_color", dark_blue)
 option1.add_theme_color_override("font_hover_color", dark_blue)
 option1.add_theme_color_override("font_pressed_color", dark_blue)
 option2.add_theme_color_override("font_color", dark_blue)
 option2.add_theme_color_override("font_hover_color", dark_blue)
 option2.add_theme_color_override("font_pressed_color", dark_blue)
 hint_label.add_theme_color_override("font_color", dark_blue)
 
 option1.pressed.connect(_on_option1_pressed)
 option2.pressed.connect(_on_option2_pressed)

func _on_option1_pressed():
 complete_task(true)

func _on_option2_pressed():
 complete_task(false)

func complete_task(is_good: bool):
 var reward = task_data["reward_good"] if is_good else task_data["reward_bad"]
 Global.coins += reward
 Global.completed_tasks.append(task_id)
 Global.experience += 1
 Global.savings += reward * 0.3
 
 if is_good:
  hint_label.text = "✅ Отлично! +" + str(reward) + " монет."
 else:
  hint_label.text = "💡 " + task_data["hint"] + " +" + str(reward) + " монет."
 
 await get_tree().create_timer(2.0).timeout
 get_tree().change_scene_to_file("res://task_list.tscn")
