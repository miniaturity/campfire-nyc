extends Line2D

@onready var static_body = $"../StaticBody2D"
@onready var collision_shape = $"../StaticBody2D/CollisionShape2D"
var cached_collision_shape: SegmentShape2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# NOTE: Make sure that Line2D only has 2 points
	if points.size() != 2:
		return
	
	var p1 = points[0]
	var p2 = points[1]
	
	var segment = SegmentShape2D.new()
	segment.a = p1
	segment.b = p2
		
	if !cached_collision_shape || cached_collision_shape != collision_shape.shape:
		collision_shape.shape = segment
		cached_collision_shape = segment
