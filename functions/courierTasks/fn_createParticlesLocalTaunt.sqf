params ["_player"];

private _positionASL = getPosASL _player;

private _ho1 = selectRandom ["inthehole1", "inthehole2", "inthehole3", "inthehole4"];
private _sound = _player say3d [_ho1, 500, 1];

[{
	params ["_sound", "_player"];
	isNull _sound
},{
	params ["_sound", "_player"];

	private _ho2 = selectRandom ["ho1", "ho2", "ho3", "ho4"];
	private _sound2 = _player say3d [_ho2, 500, 1];
	[{
		params ["_sound2", "_player"];
		isNull _sound2
	},{
		params ["_sound2", "_player"];

		if (alive _player) then {
			private _ho3 = "hoend";
			_player say3d [_ho3, 500, 1];
		};

	}, [_sound2, _player]] call CBA_fnc_waitUntilAndExecute;

}, [_sound, _player]] call CBA_fnc_waitUntilAndExecute;

