extends Node2D

enum TriggerType { 
	## When the player steps on this button, it is activated.
	PLAYER, 
	## When a box is on top of this button, it is activated.
	BOX 
	}

enum EffectType {
	## Makes an object invisible, and disables its collision.
	DISABLE,
	## Makes an object visible, and enables its collision.
	ENABLE
}

## What color should the highlight of this button be?
@export var button_color: Color = Color.WHITE
## How should this button be activated?
@export var trigger_type: TriggerType = TriggerType.PLAYER
## Is this button a "one and done" button?[br]
## [i]When this button is activated, it will stay activated forever.[/i]
@export var one_shot: bool = true
## What should this button do when activated?
@export var effect_type: EffectType = EffectType.DISABLE
## What is this button's target?
@export var target: Node2D

var active: bool = false

@onready var button_highlight_sprite: Sprite2D = $ButtonHighlightSprite
@onready var trigger_area: Area2D = $TriggerArea

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_highlight_sprite.self_modulate = button_color
	
	if target == null:
		push_error("No target!!")
		return
	
	if effect_type == EffectType.ENABLE:
		_disable_target(target, false)
	
	if effect_type == EffectType.ENABLE:
		_enable_target(target, false)

func _enable_target(target: Node2D, do_tween: bool = true):
	var tween = create_tween()
	if do_tween:
		tween.tween_property(target, "modulate", Color(1,1,1,1), 0.5)
	else:
		target.modulate = Color(1,1,1,1)
	target.process_mode = Node.PROCESS_MODE_INHERIT
	
	if target is TileMapLayer:
		target.collision_enabled = false

func _disable_target(target: Node2D, do_tween: bool = true):
	var tween = create_tween()
	if do_tween:
		tween.tween_property(target, "modulate", Color(1,1,1,0), 0.5)
	else:
		target.modulate = Color(1,1,1,0)
	target.process_mode = Node.PROCESS_MODE_DISABLED
	
	if target is TileMapLayer:
		target.collision_enabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_trigger_area_body_entered(body: Node2D) -> void:
	if trigger_type == TriggerType.PLAYER and not body.is_in_group(&"Players"):
		return
	if trigger_type == TriggerType.BOX and not body.is_in_group(&"Boxes"):
		return
	
	if target == null:
		push_error("This button has no target!")
		return
	
	button_highlight_sprite.frame = 1
	
	if effect_type == EffectType.DISABLE:
		_disable_target(target)
	else:
		_enable_target(target)


func _on_trigger_area_body_exited(body: Node2D) -> void:
	if trigger_type == TriggerType.PLAYER and not body.is_in_group(&"Players"):
		return
	if trigger_type == TriggerType.BOX and not body.is_in_group(&"Boxes"):
		return
	if one_shot:
		return
	
	if target == null:
		push_error("This button has no target!")
		return
	
	button_highlight_sprite.frame = 0
	
	if effect_type == EffectType.ENABLE:
		_disable_target(target)
	else:
		_enable_target(target)
