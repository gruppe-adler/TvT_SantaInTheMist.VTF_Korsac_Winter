#include "component.hpp"

if (!isServer) exitWith {};

params ["_pos",["_side",sideUnknown]];

if (_pos isEqualType objNull) then {
    if (_side isEqualTo sideUnknown) then {
        private _startPosLogic = (synchronizedObjects _pos) param [0,objNull];
        _side = _startPosLogic getVariable [QGVAR(randomizedSide),sideUnknown];
    };

    _pos = getPos _pos;
};

if (_side isEqualTo sideUnknown) exitWith {ERROR("Can't create exfil point for side sideUnknown.")};

private _exfilAreaRadius = ["exfilAreaRadius",20] call mitm_common_fnc_getMissionConfigEntry;

private _varName = "";
private _triggeractivation = "";
switch (_side) do {
    case (WEST): {
        _varName = "MITM_EXFIL_WEST";
        _triggeractivation = "WEST SEIZED";
    };
    case (EAST): {
        _varName = "MITM_EXFIL_EAST";
        _triggeractivation = "EAST SEIZED";
    };
    case (INDEPENDENT): {
        _varName = "MITM_EXFIL_GUER";
        _triggeractivation = "GUER SEIZED";
    };
    default {""};
};

private _trigger = [
    _pos,
    [_exfilAreaRadius,_exfilAreaRadius,0,false],
    [_triggeractivation,"PRESENT",true],
    {missionNamespace getVariable ["mitm_briefcase_carryingSide",sideUnknown] in [(_this select 0) getVariable ["mitm_setup_exfilPointOwner",sideUnknown],SIDEUNKNOWN] && {(missionNamespace getVariable ["mitm_briefcase",objNull]) inArea (_this select 0)}},
    {[_this select 0,true] call mitm_briefcase_fnc_onExfilTriggerToggle},
    {[_this select 0,false] call mitm_briefcase_fnc_onExfilTriggerToggle}
] call mitm_common_fnc_createTrigger;
_trigger setVariable ["mitm_setup_exfilPointOwner",_side];

missionNamespace setVariable [_varName,_trigger,false];

// getParamValue here, because MITM_MISSIONPARAM_DEBUGMODE is only set during postInit
if (("DebugMode" call BIS_fnc_getParamValue) == 1) then {
    ["pickup_debug",str _pos,_pos,_varName + " (DEBUG)","ICON","hd_end","COLORUNKNOWN"] call mitm_common_fnc_createCategoryMarker;
};
