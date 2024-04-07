extends Node2D

@onready var score : Label = $CanvasLayer/Score;
var gatesPassedThrough : int = -1;


func _on_passed_through_gate():
	gatesPassedThrough += 1;
	score.text = str(gatesPassedThrough);
