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
	ENABLE,
}

class CachedTile:
	var tile_pos: Vector2i
	var source_id: int
	var atlas_coords: Vector2i
	var alternative_id: int
	
	func _init(tp: Vector2i, sid: int, ac: Vector2i, ai: int):
		tile_pos = tp
		source_id = sid
		atlas_coords = ac
		alternative_id = ai

## Is this button a "one and done" button?[br]
## [i]When this button is activated, it will stay activated forever.[/i]
@export var one_shot: bool = true

@export_group("Object")
## If it should enable/disable objects
@export var object_mode: bool = true
## What color should the highlight of this button be?
@export var button_color: Color = Color.WHITE
## How should this button be activated?
@export var trigger_type: TriggerType = TriggerType.PLAYER
## What should this button do when activated?
@export var effect_type: EffectType = EffectType.DISABLE
## What is this button's target?
@export var target: Node2D

@export_group("Tile")
## Whether you want to use tiles. Can be used in tangent with objects.
@export var tile_mode: bool = false
## What should this button do when activated? (Tile)
@export var tile_effect: EffectType = EffectType.DISABLE
## Tilemap
@export var tile_map_layer: TileMapLayer
## Targets
@export var tile_targets: Array[Vector2i]
var tile_targets_cache: Array[CachedTile]

@export_group("Laser")
## Whether the button affects lasers or not.
@export var laser_mode: bool = false
## What should this button do while active (Laser)
@export var laser_effect: EffectType = EffectType.DISABLE
## Connected Laser
@export var target_lasers: Array[Laser]

var active: bool = false

@onready var button_highlight_sprite: Sprite2D = $ButtonHighlightSprite
@onready var trigger_area: Area2D = $TriggerArea

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_highlight_sprite.self_modulate = button_color
	
	if object_mode:
		if effect_type == EffectType.ENABLE:
			_disable_target(target, false)
		
	if tile_mode:
		if tile_effect == EffectType.ENABLE:
			disable_tile_targets()
	
	if laser_mode:
		if laser_effect == EffectType.ENABLE:
			disable_lasers()

func disable_lasers():
	print("disabled")
	for laser in target_lasers:
		laser.disable()

func enable_lasers():
	print("enabled")
	for laser in target_lasers:
		laser.enable()

func _enable_target(e_target: Node2D, do_tween: bool = true):
	if !e_target: return
	var tween = create_tween()
	if do_tween:
		tween.tween_property(e_target, "modulate", Color(1,1,1,1), 0.5)
	else:
		target.modulate = Color(1,1,1,1)
	target.process_mode = Node.PROCESS_MODE_INHERIT
	
	if target is TileMapLayer:
		target.collision_enabled = true



func _disable_target(e_target: Node2D, do_tween: bool = true):
	if !e_target: return
	var tween = create_tween()
	if do_tween:
		tween.tween_property(e_target, "modulate", Color(1,1,1,0), 0.5)
	else:
		target.modulate = Color(1,1,1,0)
	target.process_mode = Node.PROCESS_MODE_DISABLED
	
	if target is TileMapLayer:
		target.collision_enabled = false
		e_target.modulate = Color(1,1,1,0)
	e_target.process_mode = Node.PROCESS_MODE_DISABLED


func _on_trigger_area_body_entered(body: Node2D) -> void:
	if trigger_type == TriggerType.PLAYER and not body.is_in_group(&"Players"):
		return
	if trigger_type == TriggerType.BOX and not body.is_in_group(&"Boxes"):
		return
	
	if object_mode and target == null:
		push_error("This button has no target!")
		return
	
	if tile_mode and tile_effect == null:
		push_error("This button has no tile target!")
		return
	
	button_highlight_sprite.frame = 1
	
	if object_mode:
		if effect_type == EffectType.DISABLE:
			_disable_target(target)
		else:
			_enable_target(target)
	
	if tile_mode:
		if tile_effect == EffectType.DISABLE:
			disable_tile_targets()
		else:
			enable_tile_targets()
	
	if laser_mode:
		if laser_effect == EffectType.DISABLE:
			disable_lasers()
		else:
			enable_lasers()
	


func _on_trigger_area_body_exited(body: Node2D) -> void:
	if trigger_type == TriggerType.PLAYER and not body.is_in_group(&"Players"):
		return
	if trigger_type == TriggerType.BOX and not body.is_in_group(&"Boxes"):
		return
	if one_shot:
		return
	
	if object_mode and target == null:
		push_error("This button has no target!")
		return
	
	if tile_mode and tile_targets.size() == 0:
		push_error("This button has no tile targets!")
		return
	
	if laser_mode and target_lasers.size() == 0:
		push_error("This button has no laser targets!")
		return
	
	button_highlight_sprite.frame = 0

	if object_mode:
		if effect_type == EffectType.ENABLE:
			_disable_target(target)
		else:
			_enable_target(target)
	
	if tile_mode:
		if tile_effect == EffectType.ENABLE:
			disable_tile_targets()
		else:
			enable_tile_targets()
	
	if laser_mode:
		if laser_effect == EffectType.ENABLE:
			disable_lasers()
		else:
			enable_lasers()

func disable_tile_targets():
	if !tile_mode || !tile_map_layer || !tile_targets || tile_effect != EffectType.DISABLE:
		return
	
	for tile_target in tile_targets:
		var sid = tile_map_layer.get_cell_source_id(tile_target)
		var ac = tile_map_layer.get_cell_atlas_coords(tile_target)
		var ai = tile_map_layer.get_cell_alternative_tile(tile_target)
		tile_targets_cache.append(CachedTile.new(tile_target, sid, ac, ai))
		tile_map_layer.set_cell(tile_target, -1)
		
func enable_tile_targets():
	if !tile_mode || !tile_map_layer || !tile_targets || tile_effect != EffectType.DISABLE:
		return
	
	for cached_tile in tile_targets_cache:
		tile_map_layer.set_cell(cached_tile.tile_pos, cached_tile.source_id, cached_tile.atlas_coords, cached_tile.alternative_id)
	
	tile_targets_cache = []
	
