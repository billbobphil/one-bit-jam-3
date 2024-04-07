extends Node2D

@export var halfOpeningGap = 0;
@onready var bottomGate : Sprite2D = $BottomGate;
@onready var topGate : Sprite2D = $TopGate;


# Called when the node enters the scene tree for the first time.
func _ready():
	bottomGate.position.y += halfOpeningGap;
	topGate.position.y -= halfOpeningGap;
