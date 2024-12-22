#include "component.hpp"

params ["_deadDropLogic","_interactionTime"];

private _action = ["mitm_courierTasks_deposit","Deposit Cache","",{

    params ["_deadDropLogic","_caller","_interactionTime"];

    [_caller,(configFile >> "ACE_Repair" >> "Actions" >> "MiscRepair")] call mitm_common_fnc_doAnimation;

    _onComplete = {
        _args = _this select 0;
        _args params ["_deadDropLogic","_caller"];
        [_deadDropLogic] remoteExec ["mitm_courierTasks_fnc_onDeadDropDeliveryComplete",2,false];
        [_caller] call mitm_common_fnc_stopAnimation;
    };

    _onCancel = {
        _args = _this select 0;
        _args params ["_deadDrop","_caller"];
        [_caller] call mitm_common_fnc_stopAnimation;
        hint "canceled hiding cache";
    };

    [_interactionTime, [_deadDropLogic,_caller], _onComplete, _onCancel, "Hiding Cache..."] call ace_common_fnc_progressBar;

},mitm_courierTasks_fnc_canInteractWithTaskObject,{},_interactionTime,[0,0,0],4,[false,false,false,false,true]] call ace_interact_menu_fnc_createAction;

[_deadDropLogic,0,[],_action] call ace_interact_menu_fnc_addActionToObject;
