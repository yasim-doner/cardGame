extends Node2D

@export var card_scene : PackedScene

var slot_data = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for slot in $Slots.get_children():
		slot_data[slot] = null
	
	var card = card_scene.instantiate()
	add_child(card)
	card.dropped_on_slot.connect(_on_card_dropped_on_slot.bind(card))

func _on_card_dropped_on_slot(slot, card):
	if slot_data.has(slot) and slot_data[slot] == null:
		slot_data[slot] = card
		card.place_on_slot(slot.global_position)
		spawn_card()
	else:
		card.return_to_start()

func spawn_card():
	var card = card_scene.instantiate()
	add_child(card)
	card.dropped_on_slot.connect(_on_card_dropped_on_slot.bind(card))
	return card
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

	
