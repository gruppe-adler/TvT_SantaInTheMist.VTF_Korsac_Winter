#include "component.hpp"

params ["_lastPos","_thisPos","_locMinDist","_locMaxDist","_locMinAngle","_locMaxAngle"];

private _lastDir = _lastPos getDir _thisPos;

private _nextPos = [_thisPos,[_locMinDist,_locMaxDist],[_lastDir + _locMinAngle,_lastDir + _locMaxAngle],"",false,true] call mitm_common_fnc_findRandomPos;
if (count _nextPos == 0) exitWith {[]};

_nextPos
