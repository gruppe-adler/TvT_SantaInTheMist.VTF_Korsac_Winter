#include "component.hpp"

if (!isServer) exitWith {};

private _briefcase = "HazmatBag_01_F" createVehicle [0,0,0]; // CUP_Smrk_maly, HazmatBag_01_F
missionNamespace setVariable ["mitm_briefcase",_briefcase,true];

[{{isNull (missionNamespace getVariable [_x,objNull])} count ["mitm_courier","mitm_briefcase"] == 0},{
    [{[mitm_courier] call EFUNC(briefcase,attachBriefcase)},[],3] call CBA_fnc_waitAndExecute;
},[]] call CBA_fnc_waitUntilAndExecute;

[_briefcase] call EFUNC(common,addToZeus);
[_briefcase] call EFUNC(briefcase,disableCollision);

_briefcase
