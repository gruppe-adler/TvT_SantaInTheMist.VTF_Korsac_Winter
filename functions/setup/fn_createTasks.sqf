// executed by mitm_init_fnc_initMission on game start

#include "component.hpp"

if !(isServer) exitWith {};

if (isNil "MITM_SETUP_TASKSNAMESPACE") then {
    MITM_SETUP_TASKSNAMESPACE = [] call CBA_fnc_createNamespace;
};


// elimination tasks
private _taskDescription = "
Alternatively, eliminate all other forces in the area. This includes the Courier.
";
{
    _task = [_x,"mitm_eliminate_" + (str _x),[_taskDescription,"Eliminate Enemies (alt.)",""],objNull,"AUTOASSIGNED",1,false,"default"] call BIS_fnc_taskCreate;
} forEach [WEST,EAST,INDEPENDENT];


// seize tasks
private _taskDescription = "
Get the Briefcase under your control. Force the Courier to join your side (his ACE-Interaction) and escort him or just kill him and take the Briefcase. However killing him will increase the Briefcase's tracking frequency.<br/>
<br/>
We will give you an exfil location once you have the briefcase.
";
{
    _task = [_x,"mitm_seize_" + (str _x),[_taskDescription,"Seize Briefcase",""],objNull,"AUTOASSIGNED",3,false,"default"] call BIS_fnc_taskCreate;
} forEach [WEST,EAST,INDEPENDENT];


// courier tasks
MITM_SETUP_TASKSNAMESPACE setVariable ["courier_deliverTasks",[]];
private _tasksArray = MITM_SETUP_TASKSNAMESPACE getVariable "courier_deliverTasks";
private _missionPositionsData = +MITM_MISSIONPOSITIONSDATA;
private _lastPosition = _missionPositionsData deleteAt (count _missionPositionsData -1);
{
    _taskParams = [_x] call EFUNC(courierTasks,createTaskObjects);
    _taskParams params ["",["_taskObject",objNull],["_taskDescription","TASK CREATION FAILED. This should not happen. Contact the admin."]];

    _task = [CIVILIAN,"mitm_deliver_" + (str _forEachIndex),[_taskDescription,"Delivery (Side)",""],_taskObject,"AUTOASSIGNED",1,false,"default"] call BIS_fnc_taskCreate;
    _tasksArray pushBack _task;

    _taskObject setVariable ["mitm_courierTasks_task",_task];
} forEach _missionPositionsData;
