params ["_briefcase"];

private _owner = _briefcase getVariable ["mitm_briefcase_owner", objNull];
if (!isNull _owner) exitWith {};

private _position = getPosASL _briefcase;
_position params ["_posx", "_posy"];

private _dummy = "Land_Balloon_01_air_F" createVehicle [0,0,0];
_dummy setPos _position;

_briefcase attachto [_dummy, [0,0,0]];



[{
    params ["_args", "_handle"];
    _args params ["_briefcase", "_dummy"];

    // delete debris if briefcase is picked up again or deleted
    if (!isNull (_briefcase getVariable ["mitm_briefcase_owner", objNull]) || isNull _briefcase) exitWith {
        [_handle] call CBA_fnc_removePerFrameHandler;
		deleteVehicle _dummy;
    };

}, .5, [_briefcase, _dummy]] call CBA_fnc_addPerFrameHandler;