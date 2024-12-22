params ["_player"];

private _positionASL = getPosASL _player;

private _ho = selectRandom ["ho1", "ho2", "ho3", "ho4"];
private _sound = _player say3d _ho;

[{
	params ["_sound", "_player"];
	isNull _sound || !alive _player
},{
	params ["_sound", "_player"];

	private _ho2 = "hoend";
	_player say3d _ho2;

}, [_sound, _player]] call CBA_fnc_waitUntilAndExecute;


private _particlesSources = [];
{
	private _positionAGL = ASLToAGL _positionASL;
	private _particleSource = "#particlesource" createVehicleLocal _positionAGL;
	private _type = _x;
	// _particleSource attachTo [_vehicle, [0,0,0]];
	_particleSource setParticleCircle [0, [0, 0, 0]];  
	_particleSource setParticleRandom [0, [1, 1, 0], [2, 2, 2.35], 0, 0, [0, 0, 0, 0.1], 0, 0];  
	_particleSource setParticleParams [
		[_type, 1, 0, 1], "", "SpaceObject", 0.5, 3, 
		[0, 0, 0.3], [0, 0, (random 10) max 5], 0.5, 200, 0.2, 0.075, [1, 1, 1], [[0.3, 0.3, 0.3, 1], [0.3, 0.3, 0.3, 0.3], [0.3, 0.3, 0.3, 0]], 
		[0.08], 1, 0, "", "", _this,0,true,0.2
	];  
	_particleSource setDropInterval 0.1; 
	_particlesSources pushBackUnique _particleSource;
} forEach [
	selectRandom ["\xmas\weapons_xmas\present.p3d", "\xmas\weapons_xmas\present_2.p3d"]
];

[{
	params ["_particlesSources"];
	{ deleteVehicle _x; } forEach _particlesSources;
}, [_particlesSources], 0.7] call CBA_fnc_waitAndExecute;