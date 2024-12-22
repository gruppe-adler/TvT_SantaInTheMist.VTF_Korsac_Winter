#include "component.hpp"

params ["_trigger","_active"];

if (_trigger getVariable ["mitm_briefcase_exfilDone",false]) exitWith {};

private _ownerSide = _trigger getVariable ["mitm_setup_exfilPointOwner",sideUnknown];
if (_ownerSide == sideUnknown) exitWith {ERROR("Exfil trigger does not have an owner.")};

private _defenseTime = ["exfilDefenseTime",600] call mitm_common_fnc_getMissionConfigEntry;
private _stopDefenseTime = ["exfilStopDefenseTime",20] call mitm_common_fnc_getMissionConfigEntry;
private _otherSides = [WEST,EAST,INDEPENDENT,CIVILIAN] - [_ownerSide];

if (_active) then {
    if (_trigger getVariable ["mitm_briefcase_exfilActive",false]) then {
        ["mitm_notification",["EXFIL","We are in control again."]] remoteExec ["bis_fnc_showNotification",_ownerSide,false];
        ["mitm_notification",["PREVENT EXFIL","The enemy is in control again"]] remoteExec ["bis_fnc_showNotification",_otherSides,false];

        [_trigger getVariable ["mitm_briefcase_stopCountdownHandle",-1]] call CBA_fnc_removePerFrameHandler;
        _trigger setVariable ["mitm_briefcase_stopCountdownHandle",-1];

    } else {
        ["mitm_notification",["EXFIL","Exfil is on the way. Hold tight."]] remoteExec ["bis_fnc_showNotification",_ownerSide,false];
        ["mitm_notification",["PREVENT EXFIL","Enemy exfil is on the way. Attack quickly!"]] remoteExec ["bis_fnc_showNotification",_otherSides,false];


        _trigger setVariable ["mitm_briefcase_exfilActive",true];
        _trigger setVariable ["mitm_briefcase_countdown",_defenseTime];
        _pfh = [{
            params ["_trigger","_handle"];

            _timeLeft = _trigger getVariable "mitm_briefcase_countdown";
            if (triggerActivated _trigger) then {
                _trigger setVariable ["mitm_briefcase_countdown",_timeLeft -1];
            };

            if (_timeLeft <= 0) exitWith {
                [_handle] call CBA_fnc_removePerFrameHandler;
                [_trigger] call mitm_briefcase_fnc_onExfilDefended;
                _trigger setVariable ["mitm_briefcase_exfilDone",true];
            };
        },1,_trigger] call CBA_fnc_addPerFrameHandler;
        _trigger setVariable ["mitm_briefcase_countdownHandle",_pfh];
    };

} else {
    if ((missionNamespace getVariable ["mitm_briefcase",objNull]) inArea _trigger) then {
        ["mitm_notification",["EXFIL","We are losing control."]] remoteExec ["bis_fnc_showNotification",_ownerSide,false];
        ["mitm_notification",["PREVENT EXFIL","The enemy is losing control."]] remoteExec ["bis_fnc_showNotification",_otherSides,false];
    } else {
        ["mitm_notification",["EXFIL","Move the briefcase back into the exfil zone!"]] remoteExec ["bis_fnc_showNotification",_ownerSide,false];
        ["mitm_notification",["PREVENT EXFIL","The briefcase has moved out of the exfil zone."]] remoteExec ["bis_fnc_showNotification",_otherSides,false];
    };

    _trigger setVariable ["mitm_briefcase_stopCountdown",_stopDefenseTime];
    _pfh = [{
        params ["_args","_handle"];
        _args params ["_trigger","_ownerSide","_otherSides"];

        _timeLeft = _trigger getVariable "mitm_briefcase_stopCountdown";
        if (!triggerActivated _trigger) then {
            _trigger setVariable ["mitm_briefcase_stopCountdown",_timeLeft -1];
        };

        if (_timeLeft <= 0) exitWith {
            [_handle] call CBA_fnc_removePerFrameHandler;
            [_trigger getVariable ["mitm_briefcase_countdownHandle",-1]] call CBA_fnc_removePerFrameHandler;

            _trigger setVariable ["mitm_briefcase_countdownHandle",-1];
            _trigger setVariable ["mitm_briefcase_exfilActive",false];

            ["mitm_notification",["EXFIL","Your exfil has turned back."]] remoteExec ["bis_fnc_showNotification",_ownerSide,false];
            ["mitm_notification",["PREVENT EXFIL","The enemy exfil has turned back."]] remoteExec ["bis_fnc_showNotification",_otherSides,false];
        };
    },1,[_trigger,_ownerSide,_otherSides]] call CBA_fnc_addPerFrameHandler;
    _trigger setVariable ["mitm_briefcase_stopCountdownHandle",_pfh];
};
