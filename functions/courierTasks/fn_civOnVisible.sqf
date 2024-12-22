#include "component.hpp"

params ["_civ","_partner"];

if (!alive _civ) exitWith {};

if (_civ getVariable ["mitm_courierTasks_civOnVisible_running",false]) exitWith {};
_civ setVariable ["mitm_courierTasks_civOnVisible_running",true,true];

_civ disableAI "PATH";
_civ doWatch _partner;

[{
    params ["_civ","_partner"];
    _civ distance _partner > 50
},{
    params ["_civ","_partner"];
    _civ doWatch objNull;
    _civ enableAI "PATH";

    _civ setVariable ["mitm_courierTasks_civOnVisible_running",false,true];
},[_civ,_partner]] call CBA_fnc_waitUntilAndExecute;

[_taskObject,name _taskObject,{
    !((_this select 0) getVariable ["mitm_courierTasks_civOnVisible_running",true]) ||
    (_this select 0) getVariable ["mitm_courierTasks_taskComplete",false]
}] remoteExec ["mitm_common_fnc_temp3dMarker",missionNamespace getVariable ["mitm_courier",objNull],false];
