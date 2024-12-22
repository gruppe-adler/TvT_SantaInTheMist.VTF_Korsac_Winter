#include "component.hpp"

params [["_briefcase",objNull]];

// disable collision with all other players
[[_briefcase],{
    private _fnc_disable = {
        params ["_briefcase"];
        {
            _briefcase disableCollisionWith _x;
        } forEach playableUnits;
    };
    [{
        params ["_briefcase"];
        !isNull _briefcase &&
        playableUnits findIf {isNull _x} < 0
    },_fnc_disable,_this,20,_fnc_disable] call CBA_fnc_waitUntilAndExecute;
}] remoteExec ["call",0,true];

// disable collision with new JIP player
addMissionEventHandler ["PlayerConnected",{
    params ["","_uid","","_jip"];

    if (!_jip) exitWith {};
    if (isNil "mitm_briefcase") exitWith {};

    [[_uid],{
        [{
            params ["_uid"];
            !isNull (missionNamespace getVariable ["mitm_briefcase",objNull]) &&
            !isNull (_uid call BIS_fnc_getUnitByUID)
        },{
            params ["_uid"];
            private _newUnit = _uid call BIS_fnc_getUnitByUID;
            mitm_briefcase disableCollisionWith _newUnit;
        },_this] call CBA_fnc_waitUntilAndExecute;
    }] remoteExec ["call",0,false];
}];
