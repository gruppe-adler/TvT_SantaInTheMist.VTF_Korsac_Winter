#include "component.hpp"

params ["_message","_timeout","_varName","_timeOutValue",["_global",false]];

[{([] call FUNC(getAdminID)) != 99999},{
    [_this,"MitM (Admin)"] remoteExecCall [QFUNC(customChat),[] call mitm_common_fnc_getAdminID,false];
},_message] call CBA_fnc_waitUntilAndExecute;


missionNamespace setVariable [_varName,nil,true];
private _onVarSet = {
    params ["_varName","_timeOutValue","_global"];
    if (isNil _varName) then {missionNamespace setVariable [_varName,_timeOutValue,_global]};
};
[{!isNil (_this select 0)},_onVarSet,[_varName,_timeOutValue,_global],_timeout,_onVarSet] call CBA_fnc_waitUntilAndExecute;
