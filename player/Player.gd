extends Node2D

@export_category("Curve Speeds")
@export_subgroup("Vertical")
@export var riseSpeed : float = 300;
@export var fallSpeedVertical : float = 150;
@export var fallSpeedVerticalFallOff = 18;
@export var fallSpeedVerticalFallOffRate : float = 0.025;
@export var fallSpeedVerticalIncrement : float = 20;
@export var crashVerticalSpeed : float = 200;

@export_subgroup("Horizontal")
@export var fallSpeedHorizontal : float = 10;
@export var fallSpeedHorizontalFallOff = 10;
@export var fallSpeedHorizontalIncrementRate : float = 20;
@export var fallSpeedHorizontalFallOffRate : float = 0.025;
@export var crashHorizontalSpeed : float = 10;

@export_subgroup("Sequence Ticks")
@export var numberOfDiveTicks = 10;
@export var minimumNumberOfCurveTicks = 5;
@export var allowedTooSlowTicks = 25;
@export_subgroup("Too Slow")
@export var tooSlowRate : float = 0.025;

var tooSlowTicks = 0;
var timeFalling = 0;
var numberOfVerticalFallOffOccurences = 0;
var numberOfHorizontalFallOffOccurences = 0;
var currentVerticalFallSpeed;
var currentHorizontalFallSpeed;

var numberOfPostLevelOutVerticalTicks = 0;
var verticalTicksBeforeLevelOut = 0;

var hasLeftGround = false;
var shouldFall = false;

var wentToSlow = false;
var shouldLevelOut = false;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if(Input.is_action_pressed("rise")) :
		position += Vector2(0, -riseSpeed) * delta;
		hasLeftGround = true;
		shouldFall = false;
		wentToSlow = false;
		tooSlowTicks = 0;
		timeFalling = 0;
		numberOfVerticalFallOffOccurences = 0;
		numberOfHorizontalFallOffOccurences = 0;
		numberOfPostLevelOutVerticalTicks = 0;
		shouldLevelOut = false;
		verticalTicksBeforeLevelOut = 0;


	if(Input.is_action_just_released("rise")):
		shouldFall = true;
		currentVerticalFallSpeed = fallSpeedVertical;
		currentHorizontalFallSpeed = fallSpeedHorizontal;

	if(wentToSlow):
		position += Vector2(crashHorizontalSpeed, crashVerticalSpeed) * delta;
	elif(shouldFall):

		if(!shouldLevelOut && Input.is_action_just_pressed("levelOut")):
			shouldLevelOut = true;
			verticalTicksBeforeLevelOut = numberOfVerticalFallOffOccurences;

		timeFalling += delta;

		if(timeFalling > (numberOfVerticalFallOffOccurences + 1) * fallSpeedVerticalFallOffRate):
			numberOfVerticalFallOffOccurences += 1;
			
			if(!shouldLevelOut):
				currentVerticalFallSpeed = currentVerticalFallSpeed + fallSpeedVerticalIncrement
			elif(shouldLevelOut):
				numberOfPostLevelOutVerticalTicks += 1;
				if(numberOfPostLevelOutVerticalTicks <= verticalTicksBeforeLevelOut + minimumNumberOfCurveTicks):
					currentVerticalFallSpeed = currentVerticalFallSpeed - fallSpeedVerticalFallOff;
				else:
					currentVerticalFallSpeed = currentVerticalFallSpeed - fallSpeedVerticalFallOff;

			if(currentVerticalFallSpeed < 5):
				currentVerticalFallSpeed = 2;
		
		if(timeFalling > (numberOfHorizontalFallOffOccurences + 1) * fallSpeedHorizontalFallOffRate):
			numberOfHorizontalFallOffOccurences += 1;
			
			if(shouldLevelOut):
				if(numberOfPostLevelOutVerticalTicks <= verticalTicksBeforeLevelOut + minimumNumberOfCurveTicks):
					currentHorizontalFallSpeed = currentHorizontalFallSpeed + fallSpeedHorizontalIncrementRate;
				else:
					currentHorizontalFallSpeed = currentHorizontalFallSpeed - fallSpeedHorizontalFallOff;

			if(currentHorizontalFallSpeed < 5):
				currentHorizontalFallSpeed = 2;

		if(currentVerticalFallSpeed < 5 && currentHorizontalFallSpeed < 5):
			if(timeFalling > (tooSlowTicks + 1) * tooSlowRate):
				tooSlowTicks += 1;

			if(tooSlowTicks > allowedTooSlowTicks):
				wentToSlow = true;

		position += Vector2(currentHorizontalFallSpeed, currentVerticalFallSpeed) * delta;

