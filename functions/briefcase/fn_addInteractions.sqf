#include "component.hpp"

private _briefcase = mitm_briefcase;


private _action = ["mitm_briefcase_pickup","Pick up Sack","",{

    params ["_briefcase","_caller"];

    // hint format ["pick %1", _caller];

    [_caller] remoteExec ["mitm_briefcase_fnc_attachBriefcase",2,false];

},{isNull ((_this select 0) getVariable ["mitm_briefcase_owner",objNull])},{},[],[0,0,0],2] call ace_interact_menu_fnc_createAction;
[_briefcase,0,[],_action] call ace_interact_menu_fnc_addActionToObject;



_action = ["mitm_briefcase_drop","Drop Sack","",{
    params ["_caller"];

    // hint format ["drop %1", _caller];

    [_caller] remoteExec ["mitm_briefcase_fnc_dropBriefcase",2,false];

},{(_this select 0) getVariable ["mitm_briefcase_hasBriefcase",false]}] call ace_interact_menu_fnc_createAction;
["CAManBase",1,["ACE_SelfActions"],_action,true] call ace_interact_menu_fnc_addActionToClass;



_action = ["mitm_briefcase_give","Give Sack","",{
    params ["_unit","_caller"];

    [_unit] remoteExec ["mitm_briefcase_fnc_attachBriefcase",2,false];

},{
    params ["_target","_caller"];
    _caller getVariable ["mitm_briefcase_hasBriefcase",false] &&
    {isPlayer _target} &&
    {alive _target} &&
    {isNull objectParent _target}
}] call ace_interact_menu_fnc_createAction;
["CAManBase",0,["ACE_MainActions"],_action,true] call ace_interact_menu_fnc_addActionToClass;



_action = ["mitm_briefcase_joinSide","Join side","",{
    params ["_unit","_caller"];

    _newSide = side _unit;
    _oldSide = side _caller;

    /*[_newSide] remoteExec ["mitm_briefcase_fnc_activatePickupPoint",2,false];*/
    ["mitm_notification",["DEFECTED",format ["You joined the %1.",[_newSide] call mitm_common_fnc_getSideName]]] call BIS_fnc_showNotification;
    ["mitm_notification",["DEFECTED",format ["%1 joined your side.",name _caller]]] remoteExec ["bis_fnc_showNotification",_newSide,false];

    [{
        params ["_newSide","_oldSide","_caller"];

        _group = createGroup [_newSide,true];
        [_caller] joinSilent _group;
        ["mitm_notification",["DEFECTED",format ["%1 left your side.",name _caller]]] remoteExec ["bis_fnc_showNotification",_oldSide,false];

        [{
            params ["_newSide","_oldSide","_caller"];

            if (_caller getVariable ["mitm_briefcase_hasBriefcase",false]) then {
                [_newSide] remoteExec ["mitm_briefcase_fnc_activatePickupPoint",2,false];
            };
        },[_newSide,_oldSide,_caller],1] call CBA_fnc_waitAndExecute;
    },[_newSide,_oldSide,_caller],1] call CBA_fnc_waitAndExecute;

},{playerSide == CIVILIAN && {side (_this select 0) != side (_this select 1)} && {side (_this select 0) != CIVILIAN}}] call ace_interact_menu_fnc_createAction;
["CAManBase",0,["ACE_MainActions"],_action,true] call ace_interact_menu_fnc_addActionToClass;



_action = ["mitm_briefcase_leaveSide","Leave side","",{
    params ["_caller"];

    _newSide = playerSide;
    _oldSide = side player;

    ["mitm_notification",["DEFECTED",format ["You left the %1.",[_oldSide] call mitm_common_fnc_getSideName]]] call BIS_fnc_showNotification;
    ["mitm_notification",["DEFECTED",format ["%1 joined your side.",name _caller]]] remoteExec ["bis_fnc_showNotification",_newSide,false];

    [{
        params ["_newSide","_oldSide","_caller"];

        _group = createGroup [_newSide,true];
        [_caller] joinSilent _group;

        ["mitm_notification",["DEFECTED",format ["%1 left your side.",name _caller]]] remoteExec ["bis_fnc_showNotification",_oldSide,false];
        if (_caller getVariable ["mitm_briefcase_hasBriefcase",false]) then {
            [_newSide] remoteExec ["mitm_briefcase_fnc_activatePickupPoint",2,false];
        };
    },[_newSide,_oldSide,_caller],1] call CBA_fnc_waitAndExecute;

},{[player] call mitm_common_fnc_isCourier && playerSide != side player}] call ace_interact_menu_fnc_createAction;
["CAManBase",1,["ACE_SelfActions"],_action,true] call ace_interact_menu_fnc_addActionToClass;
