extends Node

class_name ButtonPlatformPair

# TODO: Create tileset and set source id.
const source_id: int = -999

# ID that defines the pair.
var id: int

# Whether button activates or deactivates platform
# true = activates
var activatePlatform: bool

# Atlas positions of the buttons within the tileset
var button_pos: Vector2i
var active_button_pos: Vector2i

# Atlas positions of the platforms within the SAME tileset.
var inactive_platform_pos: Vector2i
var platform_pos: Vector2i




func _init(id_: int, 
activate: bool, 
bp: Vector2i, 
abp: Vector2, 
ipp: Vector2i,
pp: Vector2i
):
	id = id_
	activatePlatform = activate
	button_pos = bp
	active_button_pos = abp
	inactive_platform_pos = ipp
	platform_pos = pp
