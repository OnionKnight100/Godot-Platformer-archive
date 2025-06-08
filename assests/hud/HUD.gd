extends CanvasLayer

var Current_health = 0
var Max_health = 0
var slot_num = null

func _ready() -> void:
	$cover/actions.visible = false

func _process(delta: float) -> void:
	_Slot_changes()
	$cover/HP_Bar.max_value = Max_health
	$cover/HP_Bar.value = Current_health
	$cover/Mana_Bar2.value = 100


func _take_values(max_H , cur_H , slotnum):
	slot_num = slotnum
	Max_health = max_H
	Current_health = cur_H

func _Save_Label_anim():
	$AnimationPlayer.play("Save_Animation")

func _Slot_changes():
	if slot_num == 1:
		$cover/slots/Sword._glow()
		$cover/slots/Bow._dark()
		$cover/slots/Spell._dark()
	elif slot_num == 2:
		$cover/slots/Sword._dark()
		$cover/slots/Bow._glow()
		$cover/slots/Spell._dark()
	elif slot_num == 3:
		$cover/slots/Sword._dark()
		$cover/slots/Bow._dark()
		$cover/slots/Spell._glow()
