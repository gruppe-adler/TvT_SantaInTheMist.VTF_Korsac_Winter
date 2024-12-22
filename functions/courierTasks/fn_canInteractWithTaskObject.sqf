#include "component.hpp"

params ["_object","_caller"];

private _task = (_this select 0) getVariable ["mitm_courierTasks_task",""];

[_this select 1] call mitm_common_fnc_isCourier &&
{!(([_task] call BIS_fnc_taskState) in ["SUCCEEDED","CANCELED"])} &&
{(_this select 1) getVariable ["mitm_briefcase_hasBriefcase",false]}
