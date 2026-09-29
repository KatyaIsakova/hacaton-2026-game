extends Node2D

@onready var title_label = $TitleLabel
@onready var task1 = $Task1
@onready var task2 = $Task2
@onready var task3 = $Task3
@onready var task4 = $Task4
@onready var task5 = $Task5
@onready var task6 = $Task6
@onready var back_button = $BackButton

func _ready():
 var keys = Global.tasks.keys()
 var buttons = [task1, task2, task3, task4, task5, task6]
 
 for i in range(buttons.size()):
  var key = keys[i]
  var task = Global.tasks[key]
  
  var done = key in Global.completed_tasks
  var status = "✅ ВЫПОЛНЕНО • " if done else "🍀 "
  buttons[i].text = status + "[" + task["theme"] + "] " + task["question"]
 
  if done:
   buttons[i].modulate = Color(0.6, 1.0, 0.6, 0.7)
  else:
   buttons[i].modulate = Color.WHITE
  

  buttons[i].pressed.connect(_open_task.bind(key))
 
 title_label.text = "📋 Задания (" + str(Global.completed_tasks.size()) + " / 6)"
 
 back_button.pressed.connect(_on_back_pressed)

func _open_task(task_id: String):
 Global.current_task = task_id
 get_tree().change_scene_to_file("res://task_screen.tscn")

func _on_back_pressed():
 get_tree().change_scene_to_file("res://main.tscn")
