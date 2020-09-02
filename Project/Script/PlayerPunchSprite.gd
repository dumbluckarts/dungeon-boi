extends AnimatedSprite

func _ready():
	$Timer.connect("timeout", self, "fade")

func fade():
	for i in range(0, modulate.a8):
		var t = Timer.new()
		
		add_child(t)
		
		t.connect("timeout", self, "adjust_alpha")
		t.connect("timeout", t, "queue_free")
		
		t.set_wait_time(i * 0.001)
		t.set_one_shot(true)
		t.start()

func adjust_alpha():
	modulate.a8 -= 1
