/*  Suppress function by bux and PabstMirror, ACE Mod
*   modified by McDiod
*/


#include "component.hpp"

params ["_unit","_targetPos"];

private _vehicle = vehicle _unit;
private _targetASL = _targetPos vectorAdd [0,0,0.6]; // mouse pos is at ground level zero, raise up a bit;
private _artilleryMag = "";


// Direct fire - Get a target position that will work
private _lis = lineIntersectsSurfaces [eyePos _unit, _targetASL, _unit, _vehicle];
if ((count _lis) > 0) then {
    _targetASL = ((_lis select 0) select 0);
};

if (_unit isEqualTo _vehicle) then {
    private _distance =  _targetASL vectorDistance eyePos _unit;
    private _maxWeaponRange = getNumber (configFile >> "CfgWeapons" >> (currentWeapon _unit) >> "maxRange");

    if (_distance > (_maxWeaponRange - 50)) then {
        if (_distance > (2.5 * _maxWeaponRange)) then {
            _targetASL = [];
        } else {
            private _fakeElevation = (_distance / 100000) * (_distance - _maxWeaponRange);
            _targetASL = (eyePos _unit) vectorAdd (((eyePos _unit) vectorFromTo _targetASL) vectorMultiply (_maxWeaponRange - 50)) vectorAdd [0,0,_fakeElevation];
        };
    };
};

if (_targetASL isEqualTo []) exitWith {};

private _units = [_unit];
if (_unit == (leader _unit)) then {_units = units _unit;};

{
    if ((_unit distance _x) < 30) then {
        ["ace_zeus_suppressiveFire", [_x, _targetASL, _artilleryMag], _x] call CBA_fnc_targetEvent;
    };
} forEach _units;
