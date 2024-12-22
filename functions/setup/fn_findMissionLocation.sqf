#include "component.hpp"

params ["_lastPos","_thisPos","_locMinDist","_locMaxDist","_locMinAngle","_locMaxAngle"];

private _lastDirVector = _lastPos vectorFromTo _thisPos;
private _possibleLocations = (nearestLocations [_thisPos,["NameVillage","NameCity","NameCityCapital","NameLocal"],_locMaxDist * MITM_MISSIONPARAM_SIZEFACTOR]) select {_thisPos distance (locationPosition _x) > _locMinDist};
_possibleLocations = _possibleLocations select {
    _locPos = locationPosition _x;
    _distance = _thisPos distance _locPos;
    _thisDirVector = _thisPos vectorFromTo _locPos;
    _angle = if (_lastPos isEqualTo [0,0,0]) then {(_locMinAngle + _locMaxAngle)/2} else {[_lastDirVector,_thisDirVector] call mitm_common_fnc_getVectorAngle};

    _angle > _locMinAngle &&
    _angle < _locMaxAngle
};
if (count _possibleLocations == 0) exitWith {[]};
private _nextPosition = locationPosition (selectRandom _possibleLocations);

_nextPosition
