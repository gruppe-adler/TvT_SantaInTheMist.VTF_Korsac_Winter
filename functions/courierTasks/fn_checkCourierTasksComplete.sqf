#include "component.hpp"

private _tasksArray = MITM_SETUP_TASKSNAMESPACE getVariable ["courier_deliverTasks",[]];

private _mainComplete = {[_x] call BIS_fnc_taskState == "Succeeded"} count _tasksArray == 7;
if (_mainComplete) exitWith {
    [CIVILIAN,"BRIEFCASE DELIVERED!"] spawn EFUNC(endings,endMissionServer);
    [CIVILIAN,15,"Main Delivery"] call EFUNC(points,addPoints);
    [CIVILIAN] call EFUNC(endings,saveScore);
};

private _sideComplete = {[_x] call BIS_fnc_taskState == "Succeeded"} count _tasksArray == 4;
if (_sideComplete) then {
    {
        if ([_x] call BIS_fnc_taskState != "Succeeded") then {
            [_x,"SUCCEEDED",false] call BIS_fnc_taskSetState;
        };
        false
    } count _tasksArray;

    _lastPosData = MITM_MISSIONPOSITIONSDATA select (count MITM_MISSIONPOSITIONSDATA - 1);

    // setting interaction time on last objective higher
    _taskParams = [_lastPosData, [], 90] call FUNC(createTaskObjects);
    _taskParams params ["",["_taskObject",objNull]];

    _taskDescription = "Make your final delivery, the Briefcase.";
    _task = [CIVILIAN,"mitm_deliver_" + (str (count MITM_MISSIONPOSITIONSDATA-1)),[_taskDescription,"Delivery (Main)",""],_taskObject,"AUTOASSIGNED",3,true,"default"] call BIS_fnc_taskCreate;
    _tasksArray pushBack _task;

    _taskObject setVariable [QGVAR(task),_task];
};
