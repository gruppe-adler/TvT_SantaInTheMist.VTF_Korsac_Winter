#include "component.hpp"


//create start position
private _islandCenter = [worldSize/2,worldSize/2,0];
private _thisPos = [];
for [{_i=0}, {_i<20}, {_i=_i+1}] do {
    _thisPos = [_islandCenter,[0,worldSize/2.3],[0,360],"",false,true] call EFUNC(common,findRandomPos);
    if (count _thisPos > 0) exitWith {};
};
if (count _thisPos == 0) exitWith {[false,"Could not find start position."]};
MITM_STARTPOSITION_COURIER = _thisPos;


//create 7 mission positions
MITM_MISSIONPOSITIONSDATA = [];
private _nextPos = [];
private _locationProbability = ["locationProbability",100] call EFUNC(common,getMissionConfigEntry);
(["locationDistances",[]] call EFUNC(common,getMissionConfigEntry)) params ["_locMinDist","_locMaxDist"];
(["locationAngles",[]] call EFUNC(common,getMissionConfigEntry)) params ["_locMinAngle","_locMaxAngle"];
for [{_i=0}, {_i<7}, {_i=_i+1}] do {

    private ["_thisMinAngle","_thisMaxAngle","_lastPos","_thisPos"];

    switch (_i) do {
        case (0): {
            _thisMinAngle = _locMinAngle;
            _thisMaxAngle = _locMaxAngle;
            _lastPos = [0,0,0];
            _thisPos = MITM_STARTPOSITION_COURIER;
        };
        case (1): {
            _thisMinAngle = _locMinAngle;
            _thisMaxAngle = _locMaxAngle;
            _lastPos = MITM_STARTPOSITION_COURIER;
            _thisPos = MITM_MISSIONPOSITIONSDATA select 0 select 0;
        };
        case (2): {
            _thisMinAngle = -50;
            _thisMaxAngle = -40;
            _lastPos = MITM_MISSIONPOSITIONSDATA select 0 select 0;
            _thisPos = MITM_MISSIONPOSITIONSDATA select 1 select 0;
        };
        case (3): {
            _thisMinAngle = 40;
            _thisMaxAngle = 50;
            _lastPos = MITM_MISSIONPOSITIONSDATA select 0 select 0;
            _thisPos = MITM_MISSIONPOSITIONSDATA select 1 select 0;
        };
        case (4): {
            _thisMinAngle = 40;
            _thisMaxAngle = 50;
            _lastPos = MITM_MISSIONPOSITIONSDATA select 1 select 0;
            _thisPos = MITM_MISSIONPOSITIONSDATA select 2 select 0;
        };
        case (5): {
            _thisMinAngle = -50;
            _thisMaxAngle = -40;
            _lastPos = MITM_MISSIONPOSITIONSDATA select 1 select 0;
            _thisPos = MITM_MISSIONPOSITIONSDATA select 3 select 0;
        };
        case (6): {
            _thisMinAngle = _locMinAngle;
            _thisMaxAngle = _locMaxAngle;
            _lastPos = [MITM_MISSIONPOSITIONSDATA select 2 select 0,MITM_MISSIONPOSITIONSDATA select 3 select 0] call EFUNC(common,getAveragePosition);
            _thisPos = [MITM_MISSIONPOSITIONSDATA select 4 select 0,MITM_MISSIONPOSITIONSDATA select 5 select 0] call EFUNC(common,getAveragePosition);
        };
    };

    _nextPos = if (_locationProbability < random 100) then {
        [_lastPos,_thisPos,_locMinDist,_locMaxDist,_thisMinAngle,_thisMaxAngle] call EFUNC(setup,findMissionLocation);
    } else {
        [_lastPos,_thisPos,_locMinDist,_locMaxDist,_thisMinAngle,_thisMaxAngle] call EFUNC(setup,findMissionRoadPosition);
    };
    if (count _nextPos == 0) exitWith {};

    MITM_MISSIONPOSITIONSDATA pushBack [_nextPos];
};
if (count _nextPos == 0) exitWith {[false,"Could not find suitable next location."]};


//create startpositions
private _remainingSides = [WEST,EAST,INDEPENDENT];
private _lastMissionPos = MITM_MISSIONPOSITIONSDATA select (count MITM_MISSIONPOSITIONSDATA - 1) select 0;
private _middleMissionPos = [MITM_MISSIONPOSITIONSDATA select 2 select 0,MITM_MISSIONPOSITIONSDATA select 3 select 0,MITM_MISSIONPOSITIONSDATA select 4 select 0,MITM_MISSIONPOSITIONSDATA select 5 select 0] call EFUNC(common,getAveragePosition);
private _courierDir = [MITM_STARTPOSITION_COURIER,MITM_MISSIONPOSITIONSDATA apply {_x select 0}] call EFUNC(common,getAverageDirection);
private _startPos = [];
{
    _side = _remainingSides deleteAt (round random (count _remainingSides - 1));
    _startPos = [_middleMissionPos,["teamStartDistances",[]] call mitm_common_fnc_getMissionConfigEntry,[_x-15,_x+15],"",false,true] call EFUNC(common,findRandomPos);

    if (count _startPos == 0) exitWith {};

    _varName = ["MITM_STARTPOSITION_WEST","MITM_STARTPOSITION_EAST","MITM_STARTPOSITION_INDEP"] select ([WEST,EAST,INDEPENDENT] find _side);
    missionNamespace setVariable [_varName,_startPos];

    false
} count [_courierDir,_courierDir+90,_courierDir+270];
if (count _startPos == 0) exitWith {[false,"Could not find start position for a team."]};

MITM_PLAYZONE_CENTER = _middleMissionPos;

publicVariable "MITM_STARTPOSITION_COURIER";
publicVariable "MITM_MISSIONPOSITIONSDATA";
publicVariable "MITM_STARTPOSITION_WEST";
publicVariable "MITM_STARTPOSITION_EAST";
publicVariable "MITM_STARTPOSITION_INDEP";
publicVariable "MITM_PLAYZONE_CENTER";


[true,"Play area setup successful"]
