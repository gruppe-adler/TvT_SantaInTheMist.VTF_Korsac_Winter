#include "component.hpp"

params ["_civ"];

[_civ getVariable ["mitm_courierTasks_task",""],"SUCCEEDED",true] call BIS_fnc_taskSetState;
deleteVehicle (_civ getVariable ["mitm_courierTasks_trigger",objNull]);
[] call mitm_courierTasks_fnc_checkCourierTasksComplete;

[group _civ] call CBA_fnc_clearWaypoints;

_civ doWatch objNull;
_civ enableAI "PATH";

private _civVehicle = _civ getVariable ["mitm_courierTasks_civOwnedVehicle",objNull];
private _moveDir = [0,360];
private _speedMode = "LIMITED";
if (!isNull _civVehicle) then {
    _civVehicle lock 0;
    _civ assignAsDriver _civVehicle;
    [group _civ,_civVehicle,0,"GETIN","UNCHANGED","NO CHANGE","LIMITED"] call CBA_fnc_addWaypoint;

    _moveDir = [getDir _civVehicle - 90,getDir _civVehicle + 90];
    _speedMode = "NORMAL";
};

private _pos = [getPos _civ,[500,1500],_moveDir] call mitm_common_fnc_findRandomPos;
if (count _pos == 0) then {
    _moveDir = [0,360];
    _pos = [getPos _civ,[500,1500],_moveDir] call mitm_common_fnc_findRandomPos;
};

if (count _pos == 0) exitWith {
    [group _civ,getPos _civ,100,"GETOUT","UNCHANGED","NO CHANGE",_speedMode] call CBA_fnc_addWaypoint;
};

[group _civ,_pos,100,"MOVE","UNCHANGED","NO CHANGE",_speedMode] call CBA_fnc_addWaypoint;
[group _civ,_pos,100,"GETOUT","UNCHANGED","NO CHANGE",_speedMode] call CBA_fnc_addWaypoint;

[CIVILIAN,5,"Customer Deliveries"] call mitm_points_fnc_addPoints;
