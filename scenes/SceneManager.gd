extends Node2D
func _ready():
	GameManager.register_level(
		$StarviaTileMapLayer,
		$RobotTileMapLayer,
		$StarviaPlayer,
		$RobotPlayer
	)
