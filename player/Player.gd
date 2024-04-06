extends Node2D


@onready var sprite : Sprite2D = $Sprite2D;
@export var canRiseColor : Color = Color(0, 1, 0, 1);
@export var isFallingColor : Color = Color(1, 0, 0, 1);

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
@export var minimumLevelOutTicksBeforeCanRise = 20;
@export_subgroup("Too Slow")
@export var tooSlowRate : float = 0.025;

var tooSlowTicks = 0;
var timeFalling = 0;
var numberOfVerticalFallOffOccurences = 0;
var numberOfHorizontalFallOffOccurences = 0;
var currentVerticalFallSpeed;
var currentHorizontalFallSpeed;
var leveledOutTicks = 0;

var numberOfPostLevelOutVerticalTicks = 0;
var verticalTicksBeforeLevelOut = 0;

var hasLeftGround = false;
var shouldFall = false;
var canRise = true;
var isRising = false;

var wentToSlow = false;
var shouldLevelOut = false;

func _ready():
	sprite.modulate = canRiseColor;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if(wentToSlow):
		print('too slow')
		position += Vector2(crashHorizontalSpeed, crashVerticalSpeed) * delta;
	elif(shouldFall):
		print('falling');
		if(!shouldLevelOut && Input.is_action_just_pressed("toggle")):
			print('trigger level out');
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
					leveledOutTicks += 1;
					currentHorizontalFallSpeed = currentHorizontalFallSpeed - fallSpeedHorizontalFallOff;
					if(leveledOutTicks > minimumLevelOutTicksBeforeCanRise):
						canRise = true;
						sprite.modulate = canRiseColor;

			if(currentHorizontalFallSpeed < 5):
				currentHorizontalFallSpeed = 2;

		if(currentVerticalFallSpeed < 5 && currentHorizontalFallSpeed < 5):
			if(timeFalling > (tooSlowTicks + 1) * tooSlowRate):
				tooSlowTicks += 1;

			if(tooSlowTicks > allowedTooSlowTicks):
				wentToSlow = true;

		position += Vector2(currentHorizontalFallSpeed, currentVerticalFallSpeed) * delta;

	if(isRising):
		print('rising');
		position += Vector2(0, -riseSpeed) * delta;

	if(isRising && Input.is_action_just_pressed("toggle")):
		print('trigger falling')
		canRise = false;
		isRising = false;
		shouldFall = true;
		currentVerticalFallSpeed = fallSpeedVertical;
		currentHorizontalFallSpeed = fallSpeedHorizontal;
		sprite.modulate = isFallingColor;
		
	if(canRise && !isRising && Input.is_action_just_pressed("toggle")):
		print('trigger rising')
		# position += Vector2(0, -riseSpeed) * delta;
		isRising = true;
		hasLeftGround = true;
		shouldFall = false;
		wentToSlow = false;
		tooSlowTicks = 0;
		timeFalling = 0;
		leveledOutTicks = 0;
		numberOfVerticalFallOffOccurences = 0;
		numberOfHorizontalFallOffOccurences = 0;
		numberOfPostLevelOutVerticalTicks = 0;
		shouldLevelOut = false;
		verticalTicksBeforeLevelOut = 0;

	

