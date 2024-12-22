params ["_positionASL"];

private _particlesSources = [];
{
	private _positionAGL = ASLToAGL _positionASL;
	private _particleSource = "#particlesource" createVehicleLocal _positionAGL;
	private _type = _x;
	// _particleSource attachTo [_vehicle, [0,0,0]];
	_particleSource setParticleCircle [0, [0, 0, 0]];  
	_particleSource setParticleRandom [0, [1, 1, 0], [1, 1, 0.35], 0, 0, [0, 0, 0, 0.1], 0, 0];  
	_particleSource setParticleParams [
		[_type, 1, 0, 1], "", "SpaceObject", 0.5, 120, 
		[0, 0, 0.3], [0, 0, (random 5) max 2.5], 0.5, 200, 0.2, 0.075, [1, 1, 1], [[0.3, 0.3, 0.3, 1], [0.3, 0.3, 0.3, 0.3], [0.3, 0.3, 0.3, 0]], 
		[0.08], 1, 0, "", "", _this,0,true,0.2
	];  
	_particleSource setDropInterval 1; 
	_particlesSources pushBackUnique _particleSource;
} forEach [
	"\xmas\weapons_xmas\present.p3d",
	"\xmas\weapons_xmas\present_2.p3d"
];

[{
	params ["_particlesSources"];
	{ deleteVehicle _x; } forEach _particlesSources;
}, [_particlesSources], 0.7] call CBA_fnc_waitAndExecute;