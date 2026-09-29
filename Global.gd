extends Node

var pet_type: String = ""
var coins: float = 50.0
var savings: float = 0.0
var experience: int = 0


var period: int = 1
var max_periods: int = 5
var stage: int = 1                 # 1, 2, 3
var pet_chosen: bool = false
var game_over: bool = false
var demo_mode: bool = true


var pet_hunger: float = 100.0
var pet_happiness: float = 100.0


var completed_tasks: Array = []
var current_task: String = ""


var tasks = {
 "income_1": {
  "theme": "Доход",
  "question": "Питомец может поработать. Что выберешь?",
  "options": ["Пойти на подработку (+15 монет)", "Отдохнуть (+5 монет)"],
  "reward_good": 8,
  "reward_bad": 3,
  "hint": "Совет: работа — это источник дохода."
 },
 "income_2": {
  "theme": "Доход",
  "question": "Тебе подарили 20 монет. Что сделать?",
  "options": ["Отложить 10 монет в копилку", "Потратить всё на сладости"],
  "reward_good": 8,
  "reward_bad": 3,
  "hint": "Совет: часть дохода лучше откладывать."
 },
 "expense_1": {
  "theme": "Расход",
  "question": "Питомец голоден. Что купить?",
  "options": ["Простую еду (5 монет)", "Дорогую еду (20 монет)"],
  "reward_good": 6,
  "reward_bad": 2,
  "hint": "Совет: иногда простая еда полезнее."
 },
 "expense_2": {
  "theme": "Расход",
  "question": "Питомец просит игрушку за 30 монет.",
  "options": ["Купить, если есть деньги", "Подождать и накопить"],
  "reward_good": 6,
  "reward_bad": 2,
  "hint": "Совет: крупные покупки лучше планировать."
 },
 "savings_1": {
  "theme": "Накопления",
  "question": "У тебя 50 монет. Что сделаешь?",
  "options": ["Отложить 20 монет в копилку", "Потратить всё"],
  "reward_good": 6,
  "reward_bad": 2,
  "hint": "Совет: накопления — залог будущего."
 },
 "savings_2": {
  "theme": "Накопления",
  "question": "Цель — накопить 100 монет.",
  "options": ["Работать и откладывать", "Ждать"],
  "reward_good": 8,
  "reward_bad": 3,
  "hint": "Совет: цель требует действий."
 }
}

func reset_for_new_game():
 coins = 50.0
 savings = 0.0
 experience = 0
 period = 1
 stage = 1
 pet_chosen = false
 game_over = false
 pet_hunger = 100.0
 pet_happiness = 100.0
 completed_tasks.clear()
 current_task = ""
