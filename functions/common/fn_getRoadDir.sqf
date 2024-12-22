#include "component.hpp"

params ["_road"];

if (_road isEqualType []) then {
    _road = roadAt _road;
};
if (isNull _road) exitWith {-1};

(roadsConnectedTo _road) params [["_nextRoad",objNull]];
if (isNull _nextRoad) exitWith {-1};

private _roadDir = _road getDir _nextRoad;

_roadDir
