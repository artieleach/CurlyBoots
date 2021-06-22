extends Control

onready var liquid := get_node("Liquid")
onready var bubble := get_node("Bubble")
onready var splash := get_node("Splash")
onready var poof := get_node("Poof")
onready var tween := get_node("Tween")
onready var indicators := get_node("Indicators")
onready var potion := get_node("Potion_Bottle")


func _ready():
	set_indicators(true)


func finish_potion():
	display_potion()


func _process(_delta):
	potion.get_node("Spinner").rotate(0.02)
	potion.get_node("Spinner2").rotate(0.03)


func set_indicators(instant=false, current=[]):
	set_color()
	var new = GlobalVars.potion_balance
	for i in range(len(GlobalVars.potion_balance)):
		if not instant:
			if current[i] > new[i]:
				AudioHolder.play_audio('down', -4)
				if new[i] == 0:
					indicators.get_node("%s/indicator" % GlobalVars.POTION_VARS[i]).play("down")
				else:
					indicators.get_node("%s/indicator" % GlobalVars.POTION_VARS[i]).play("up", true)
			if current[i] < new[i]:
				AudioHolder.play_audio('up', -4)
				if new[i] == 2:
					indicators.get_node("%s/indicator" % GlobalVars.POTION_VARS[i]).play("up")
				else:
					indicators.get_node("%s/indicator" % GlobalVars.POTION_VARS[i]).play("down", true)
			if current[i] == new[i]:
				AudioHolder.play_audio('stay', -2)
		if instant:
			indicators.get_node("%s/indicator" % GlobalVars.POTION_VARS[i]).animation = 'lot'
			indicators.get_node("%s/indicator" % GlobalVars.POTION_VARS[i]).frame = new[i]
		if not instant:
			yield(get_tree().create_timer(0.2), "timeout")


func display_potion():
	tween.interpolate_property(potion, "position", potion.position, Vector2(24, 12), 2, Tween.TRANS_SINE, Tween.EASE_OUT, 1)
	tween.interpolate_property(potion, "position", Vector2(24, 12), Vector2(24, -60), 2, Tween.TRANS_SINE, Tween.EASE_IN, 3)


func set_color():
	GlobalVars.cauldron_color = Color(0, 0, 0, 1)
	GlobalVars.cauldron_color.r = GlobalVars.potion_balance[0] * 0.2 + 0.1
	GlobalVars.cauldron_color.g = GlobalVars.potion_balance[1] * 0.3 + 0.3
	GlobalVars.cauldron_color.b = GlobalVars.potion_balance[2] * 0.2 + 0.3
	GlobalVars.cauldron_color.a = 0.5
	#bottle.get_node("liquid").self_modulate = GlobalVars.cauldron_color
	tween.interpolate_property(liquid, "color", liquid.color, GlobalVars.cauldron_color, 0.3)
	tween.interpolate_property(bubble, "color", bubble.color, GlobalVars.cauldron_color, 0.3)
	tween.interpolate_property(splash, "color", splash.color, GlobalVars.cauldron_color, 0.3)
	tween.start()


func potion_splash(poof_color):
	splash.restart()
	poof.self_modulate = poof_color
	poof.restart()


func set_temp():
	tween.interpolate_property(liquid, "speed_scale", liquid.speed_scale, 0.4 + (GlobalVars.cauldron_temp * 0.1), 1)
	tween.interpolate_property(bubble, "amount", bubble.amount, 1 + GlobalVars.cauldron_temp, 1)
	tween.start()
