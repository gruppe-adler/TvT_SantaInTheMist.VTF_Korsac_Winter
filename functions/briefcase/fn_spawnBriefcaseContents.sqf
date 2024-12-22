// remote executed by fn_dropBriefcase

if (!hasInterface) exitWith {};

params [["_briefcase", objNull], ["_posX", 0], ["_posY", 0], ["_type", ""]];

private _owner = _briefcase getVariable ["mitm_briefcase_owner", objNull];
if (!isNull _owner) exitWith {};

private _debris = _type createVehicleLocal [_posX, _posY, 0];
_debris enableSimulation false;
_debris setPos [_posX, _posY, 0]; // necessary
_debris setDir (random 360);

[{
    params ["_args", "_handle"];
    _args params ["_debris", "_briefcase", "_posX", "_posY"];

    // delete debris if briefcase is picked up again or deleted
    if (!isNull (_briefcase getVariable ["mitm_briefcase_owner", objNull]) || isNull _briefcase) exitWith {
        [_handle] call CBA_fnc_removePerFrameHandler;
        deleteVehicle _debris;
    };

    // slowly rotate to give at least some visual eye candy
    _debris setPos [_posX, _posY, 0];
    _debris setDir ((getDir _debris) + 0.05);
}, 0.01, [_debris, _briefcase, _posX, _posY]] call CBA_fnc_addPerFrameHandler;
