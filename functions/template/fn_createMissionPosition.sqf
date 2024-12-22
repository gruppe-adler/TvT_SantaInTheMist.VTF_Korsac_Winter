#include "component.hpp"

if (!isServer) exitWith {};

params [["_gameLogic",objNull],["_isLastPosition",false],"_type"];

if (isNil "MITM_MISSIONPOSITIONSDATA") then {MITM_MISSIONPOSITIONSDATA = []};

private _synchronizedObjects = synchronizedObjects _gameLogic;
private "_taskObject";
if (count _synchronizedObjects > 0) then {
    _taskObject = _synchronizedObjects param [0,objNull];
    _type = ["DEADDROP","CIV"] select (_taskObject isKindOf "CaManBase");
};

if (_isLastPosition) then {
    MITM_MISSIONPOSITIONSDATA pushBack [getPos _gameLogic,_type,_taskObject];
} else {
    reverse MITM_MISSIONPOSITIONSDATA;
    MITM_MISSIONPOSITIONSDATA pushBack [getPos _gameLogic,_type,_taskObject];
    reverse MITM_MISSIONPOSITIONSDATA;
};

diag_log format ["position created: %1 - %2 - %3", getPos _gameLogic,_type,_taskObject];

if (count MITM_MISSIONPOSITIONSDATA == 7) then {
    publicVariable "MITM_MISSIONPOSITIONSDATA";

    INFO("Mission positions set up.")
};
