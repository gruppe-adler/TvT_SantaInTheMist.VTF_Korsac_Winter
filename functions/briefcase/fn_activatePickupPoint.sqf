#include "component.hpp"

#define PREVENT(var1,var2) (format ["mitm_prevent_%1_%2",var1,var2])
#define SIDEUNITS(var1) (allGroups select {side _x == var1})

params ["_side"];

/*private _previousSide = missionNamespace getVariable ["mitm_briefcase_carryingSide",sideUnknown];
if (_side == _previousSide) exitWith {};*/
missionNamespace setVariable ["mitm_briefcase_carryingSide",_side];

private _otherSides = [WEST,EAST,INDEPENDENT,CIVILIAN] - [_side];

// civ tasks ===================================================================
private _civDeliverTasks = MITM_SETUP_TASKSNAMESPACE getVariable "courier_deliverTasks";
private _civDeliverTaskStatus = ["CANCELED","AUTOASSIGNED"] select (_side == CIVILIAN);
{
    if ([_x] call BIS_fnc_taskState != "SUCCEEDED") then {
        [_x,_civDeliverTaskStatus,false] call BIS_fnc_taskSetState;
    };
    false
} count _civDeliverTasks;

private _reclaimTask = MITM_SETUP_TASKSNAMESPACE getVariable ["reclaim",""];
if (_side == SIDEUNKNOWN) then {
    if (_reclaimTask == "") then {
        _task = [CIVILIAN,"mitm_reclaim_" + (str CIVILIAN),["You lost the sack. Get it back.","Pick up Sack",""],missionNamespace getVariable ["mitm_briefcase",objNull],"ASSIGNED",5,true,"default"] call BIS_fnc_taskCreate;
        MITM_SETUP_TASKSNAMESPACE setVariable ["reclaim",_task];
    } else {
        [_reclaimTask,"ASSIGNED",false] call BIS_fnc_taskSetState;
    };
} else {
    if (_reclaimTask != "") then {[_reclaimTask,["CANCELED","SUCCEEDED"] select (_side == CIVILIAN),false] call BIS_fnc_taskSetState};
};



if (_side == SIDEUNKNOWN) exitWith {};


// prevent and exfil tasks =====================================================
private _taskPos = switch (_side) do {
    case (WEST): {getPos MITM_EXFIL_WEST};
    case (EAST): {getPos MITM_EXFIL_EAST};
    case (INDEPENDENT): {getPos MITM_EXFIL_GUER};
    default {objNull};
};

// update seize and exfil tasks
{
    _curSide = _x;
    _sideUnits = SIDEUNITS(_curSide);

    _assign = _side == CIVILIAN && {_curSide != CIVILIAN};
    ["mitm_seize_" + str _curSide,_sideUnits,[localize "str_mitm_task_seize",localize "str_mitm_task_seize_title",""],objNull,["CANCELED","ASSIGNED"] select _assign,3,_assign,true,"default"] call BIS_fnc_setTask;
    _assign = _side == _curSide && {_side != CIVILIAN};
    ["mitm_exfil_" + str _curSide,_sideUnits,[localize "str_mitm_task_exfil",localize "str_mitm_task_exfil_title",""],_taskPos,["CANCELED","ASSIGNED"] select _assign,3,_assign,true,"default"] call BIS_fnc_setTask;

    {
        _taskName = PREVENT(str _curSide,str _x);
        _prevTaskPos = switch (_x) do {
            case (WEST): {getPos MITM_EXFIL_WEST};
            case (EAST): {getPos MITM_EXFIL_EAST};
            case (INDEPENDENT): {getPos MITM_EXFIL_GUER};
            default {objNull};
        };
        if (_curSide != _x && {_x != CIVILIAN}) then {
            _assign = (_curSide != _side && {_x == _side});
            [_taskName,_sideUnits,[localize "str_mitm_task_prevent",localize "str_mitm_task_prvent_title",""],_taskPos,["CANCELED","ASSIGNED"] select _assign,3,_assign,true,"default"] call BIS_fnc_setTask;
        };
        false
    } count [WEST,EAST,INDEPENDENT,CIVILIAN];

    false
} count [WEST,EAST,INDEPENDENT,CIVILIAN];
