#include "component.hpp"

params ["_entryName","_defaultValue"];

private _return = [missionConfigFile >> "cfgMission",_entryName,_defaultValue] call BIS_fnc_returnConfigEntry;

if (_defaultValue isEqualType false && {_return isEqualTo "true" || _return isEqualTo "false"}) then {_return = call compile _return};

_return
