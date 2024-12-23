

if (player getvariable ["tauntCooldown", false]) exitWith {};
if (isNull (missionNamespace getVariable ["mitm_briefcase",objNull])) exitWith {};

[player] remoteExec ["mitm_courierTasks_fnc_createParticlesLocalTaunt", 0];

private _briefcase = missionNamespace getVariable ["mitm_briefcase",objNull];
private _currentInterval = _briefcase getVariable ["mitm_briefcase_currentInterval", 0]; 
_briefcase setVariable ["mitm_briefcase_lastMarkerTime", CBA_missionTime - _currentInterval, true];

// CBA_missionTime - mitm_briefcase_lastMarkerTime < _currentInterval

[position player] remoteExec ["mitm_briefcase_fnc_showTracker",0,false];

// 20 is max delay, so marker script should send a new one almost instantly

player setvariable ["tauntCooldown", true];

	
for "_i" from 1 to (floor (random 10 max 3)) do 
{
	private _positionASL = getPosASL player;
	private _positionAGL = ASLToAGL _positionASL;
	_positionAGL set [2, _positionAGL#2 + 2]; // above head
	private _present = objNull;

	if (random 3 > 2.5) then {
		_present = "xmas_exposive_present_ammo" createVehicle _positionAGL;
		// "explosive created" call CBA_fnc_notify;
	} else {
		_present = "xmas_exposive_present_ammo" createVehicle _positionAGL;
		

		[{
			params ["_present"];
			(getPosATL _present)#2 < 0.1
		},{
			params ["_present"];
			// systemchat "is touching ground";
			[_present] call BIS_fnc_replaceWithSimpleObject;

			// "non-explosive created" call CBA_fnc_notify;
		}, [_present]] call CBA_fnc_waitUntilAndExecute;
	};
	private _velocity = velocity player; // Get player's movement direction and speed
	private _randomX = random 20 - 10;
	private _randomY = random 20 - 10;

	_velocity set [0, _velocity#0 + _randomX];
	_velocity set [1, _velocity#1 + _randomY];
	_velocity set [2, random 5 + 0.1];

	_present setVelocity _velocity;
};


player setVariable ["tauntCooldownValue", 10];

[{
	params ["_args", "_handle"];

	if (
		!(player getVariable ["tauntCooldown", false]) || 
		player getVariable ["tauntCooldownValue", -1] < 1
	) exitWith {
		[_handle] call CBA_fnc_removePerFrameHandler;
		player setVariable ["tauntCooldownValue", -1];
		player setvariable ["tauntCooldown", false];
	};

	private _cooldown = player getVariable ["tauntCooldownValue", 10];
	player setVariable ["tauntCooldownValue", _cooldown - 1];

}, 1, []] call CBA_fnc_addPerFrameHandler;
