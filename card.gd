extends Area2D

signal dropped_on_slot(slot)

var is_dragging = false
var start_position # sürükleme başarısız olursa buraya geri dönecek

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	print("annesi kaşar")
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed() and not is_dragging:
			print("merhaba orospu çocuğu")
			is_dragging = true
			start_position = global_position
			z_index = 10
		elif  not event.is_pressed() and is_dragging:
			print("Merga")
			is_dragging = false
			z_index = 0 
			handle_drop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if is_dragging:
		global_position = get_global_mouse_position()

func handle_drop():
	var overlapping_slots = get_overlapping_areas()
	
	var best_slot = null
	var max_overlap_area = 0.0
	
	var card_rect = $CollisionShape2D.shape.get_rect()
	card_rect.position = global_position - card_rect.size / 2
	
	for slot in overlapping_slots:
		var slot_rect = slot.get_node("CollisionShape2D").shape.get_rect()
		slot_rect.position = slot.global_position - slot_rect.size / 2
		
		var intersection = card_rect.intersection(slot_rect)
		
		if intersection != null:
			var current_overlap_area = intersection.size.x * intersection.size.y
			
			# Eğer bu slotun kesişim alanı, şu ana kadar bulduğumuz en büyük alandan daha büyükse:
			if current_overlap_area > max_overlap_area:
				# Yeni en büyük alanı ve en iyi slotu güncelle.
				max_overlap_area = current_overlap_area
				best_slot = slot
	# 3. EŞİK KONTROLÜ (YETERİNCE ÜST ÜSTE Mİ?):
	var card_total_area = card_rect.size.x * card_rect.size.y	
	
	
	# Eğer en iyi slot bulunduysa VE kesişim alanı kartın toplam alanının %50'sinden fazlaysa:
	if best_slot != null and max_overlap_area > (card_total_area * 0.5):
		# O zaman bu geçerli bir bırakmadır. Sinyali en iyi slota gönder.
		dropped_on_slot.emit(best_slot)
		print("Geçerli bırakma! En iyi slot: ", best_slot.name)
	else:
		# Değilse, bu geçersiz bir bırakmadır. Kartı geri gönder.
		print("Geçersiz bırakma! Eşik aşılamadı.")
		return_to_start()

func place_on_slot(slot_global_position):
	is_dragging = false
	$CollisionShape2D.disabled = true
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", slot_global_position, 0.15).set_trans(Tween.TRANS_SINE)

func return_to_start():
	#animaasyon ekliyor
	print("annen")
	#global_position = start_position
	var tween = create_tween()
	tween.tween_property(self, "global_position",start_position,0.2).set_trans(Tween.TRANS_SINE)
	
