extends Sprite2D

@export var objectToOrbit : Node2D;
@export var orbitDistance = 10;
var nearestGate = null;

func _ready():
	pass # Replace with function body.


func _process(_delta):

	var gates = get_tree().get_nodes_in_group("gates");

	var gatesToTheRight = [];
	for gate in gates:
		var gatePosition = gate.get_node("GateCenter").global_position;

		if((gatePosition - global_position).normalized().x > 0):
			gatesToTheRight.append(gate);

	if(gatesToTheRight.size() > 0):
		nearestGate  = gates[0];

		for gate in gatesToTheRight:
			var gatePosition = gate.get_node("GateCenter").global_position;
			var nearestGatePosition = nearestGate.get_node("GateCenter").global_position;

			#gate marked as nearest is now on the left
			if((nearestGatePosition - global_position).normalized().x < 0):
				nearestGate = gate;

			if(gatePosition.distance_to(global_position) < nearestGatePosition.distance_to(global_position)):
					nearestGate = gate;
	else:
		nearestGate = null;

	if(nearestGate != null):
		# look_at(nearestGate.get_node("GateCenter").global_position);
		pointAtTarget(nearestGate.get_node("GateCenter").global_position, objectToOrbit.global_position);
		self_modulate.a = 1;
	else:
		self_modulate.a = 0;


func pointAtTarget(targetPosition, objectToOrbitPosition):
	var direction = (targetPosition - objectToOrbitPosition);
	var angleInRadians = atan2(direction.x, direction.y);

	var newX = orbitDistance * sin(angleInRadians);
	var newY = orbitDistance * cos(angleInRadians);

	position = Vector2(newX, newY);
	look_at(targetPosition);


	
