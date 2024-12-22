#include "component.hpp"

params ["_deadDropLogic"];

[_deadDropLogic getVariable ["mitm_courierTasks_task",""],"SUCCEEDED",true] call BIS_fnc_taskSetState;
deleteVehicle (_deadDropLogic getVariable ["mitm_courierTasks_trigger",objNull]);
[] call mitm_courierTasks_fnc_checkCourierTasksComplete;

[CIVILIAN,5,"Dead Drop Deliveries"] call mitm_points_fnc_addPoints;
