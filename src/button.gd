extends Node2D

enum TriggerType { 
	## When the player steps on this button, it is activated.
	PLAYER, 
	## When a box is on top of this button, it is activated.
	BOX 
	}

## What color should the highlight of this button be?
@export var button_color: Color = Color.WHITE
## How should this button be activated?
@export var trigger_type: TriggerType = TriggerType.PLAYER
## Is this button a "one and done" button?[br]
## [i]When this button is activated, it will stay activated forever.[/i]
@export var one_shot: bool = true

@onready var button_highlight_sprite: Sprite2D = $ButtonHighlightSprite
@onready var trigger_area: Area2D = $TriggerArea

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_highlight_sprite.self_modulate = button_color


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
