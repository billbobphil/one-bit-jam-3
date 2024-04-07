extends Node2D

@export var startingGatesToSpawn : int = 0;
@export var distanceBetweenGates : int = 0;
@export var minimumDistanceBetweenGates : int = 0;
@export var maximumDistanceBetweenGates : int = 0;
@export var minimumHalfOpeningGap : int = 0;
@export var maximumHalfOpeningGap : int = 0;
@export var minimumVerticalDifferenceBetweenGates : int = 0;
@export var maximumVerticalDifferenceBetweenGates : int = 0;
@export var gateScene : PackedScene;
var gateToSpawn : int = 1;
var lastGateSpawned;

func _ready():
	for i in range(startingGatesToSpawn):
		spawnGate()

func spawnGate():
	var gate = gateScene.instantiate();

	var randomDistanceBetweenGates = int(randf_range(minimumDistanceBetweenGates, maximumDistanceBetweenGates));
	var randomGapOpening = int(randf_range(minimumHalfOpeningGap, maximumHalfOpeningGap));
	var randomVerticalDifference = int(randf_range(minimumVerticalDifferenceBetweenGates, maximumVerticalDifferenceBetweenGates));

	if(lastGateSpawned != null):
		var coinFlip = randi() % 2;
		if(coinFlip == 0):
			randomVerticalDifference = randomVerticalDifference * -1;
		randomVerticalDifference = lastGateSpawned.position.y + randomVerticalDifference;

	if(lastGateSpawned != null):
		randomDistanceBetweenGates = lastGateSpawned.position.x + randomDistanceBetweenGates;

	gate.position = Vector2(randomDistanceBetweenGates, randomVerticalDifference);
	gateToSpawn += 1;
	gate.halfOpeningGap = randomGapOpening;
	lastGateSpawned = gate;
	add_child(gate);

func receiveSignalToSpawnGate():
	spawnGate();