extends Node2D

## Sequence of images
@export var images: Array[Texture2D] = []
@export var delay: float = 5.0
@export var fade_duration: float = 0.5

func _ready():
	play_seq()

func play_seq():
	for img in images:
		var sprite = Sprite2D.new()
		sprite.texture = img
		sprite.position = Vector2(0, -4.0)
		sprite.scale = Vector2(3.7, 3.6)
		sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		sprite.modulate.a = 0.0 
		add_child(sprite)
		
		var tween = create_tween()
		tween.tween_property(sprite, "modulate:a", 1.0, fade_duration)
		await tween.finished
		
		await get_tree().create_timer(delay).timeout
		
		tween = create_tween()
		tween.tween_property(sprite, "modulate:a", 0.0, fade_duration)
		tween.connect("finished", Callable(self, "on_tween_finished").bind(sprite))
		
func on_tween_finished(sprite: Sprite2D):
	sprite.queue_free()
