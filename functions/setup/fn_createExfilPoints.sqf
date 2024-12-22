#include "component.hpp"

if (!isServer) exitWith {};

["pickup_debug"] call mitm_common_fnc_clearMarkerCategory;

private _exfilDistances = ["teamPickupDistances",[1000,2000]] call mitm_common_fnc_getMissionConfigEntry;
_exfilDistances params ["_exfilDistanceMin","_exfilDistanceMax"];

private _exfilPoints = [];

{
    _successful = false;
    _currentMinDist = _exfilDistanceMin;
    _currentMaxDist = _exfilDistanceMax;
    _pos = [];
    while {!_successful} do {
        _pos = [MITM_PLAYZONE_CENTER,[_currentMinDist,_currentMaxDist],[0,360],"Land_HelipadCircle_F"] call mitm_common_fnc_findRandomPos;
        if (count _pos > 0) then {
            if ({_pos distance2D _x < _currentMinDist} count _exfilPoints == 0) then {_successful = true};
        };
        _currentMinDist = _currentMinDist * 0.8;
        _currentMaxDist = _currentMaxDist * 1.2;
    };

    _exfilPoints pushBack _pos;

    [_pos,[WEST,EAST,INDEPENDENT] select _forEachIndex] call EFUNC(template,createExfilPoint);    
} forEach ["MITM_EXFIL_WEST","MITM_EXFIL_EAST","MITM_EXFIL_GUER"];
