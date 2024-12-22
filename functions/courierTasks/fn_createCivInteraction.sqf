#include "component.hpp"

params ["_civ","_interactionTime"];


private _modifier = {
    params ["_target", "_caller", "", "_actionData"];
    private _actionText = if (alive _target) then {
        "Hand over delivery"
    } else {
        "Inspect body"
    };
    _actionData set [1,_actionText];
};

private _action = ["mitm_courierTasks_deliver","MODIFIED TEXT","",{

    params ["_civ","_caller", "_interactionTime"];

    // interaction time is zero currently


    if (!alive _civ) exitWith {
        private _killer = _civ getVariable ["mitm_civKiller", objNull];
        if (isPlayer _killer && side _caller isEqualTo civilian) then {
            diag_log format ["killing your own and dealing with the body, you bastard"];
        };

        [_civ] remoteExec ["mitm_courierTasks_fnc_onCivDeliveryComplete",2,false];
        selectRandom [
            "Better him than me.",
            "I guess he won't be needing his delivery anymore.",
            "I'll just keep the package then.",
            "Risky business, this.",
            "Good thing I wasn't here sooner"
        ] call CBA_fnc_notify;
    };

    _onComplete = {
        _args = _this select 0;
        _args params ["_civ","_caller"];
        [_civ] remoteExec ["mitm_courierTasks_fnc_onCivDeliveryComplete",2,false];
    };

    _onCancel = {
        _args = _this select 0;
        _args params ["_deadDrop","_caller"];
        hint "canceled handing over";
    };

    _eachFrame = {
        params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
    
        if (floor _elapsedTime % 1 == 0) then {
            diag_log format ["One second of particle spawn has passed. Elapsed: %1 seconds", _elapsedTime];

            [getPosASL player] remoteExec ["mitm_courierTasks_fnc_createParticlesLocal"];
        };
        
        // Return true to keep the interaction running
        true
    };

    [_interactionTime, [_civ,_caller], _onComplete, _onCancel, "Doing business...", _eachFrame] call ace_common_fnc_progressBar;

},mitm_courierTasks_fnc_canInteractWithTaskObject,{},_interactionTime,[0,0,0],4,[false,false,false,false,true],_modifier] call ace_interact_menu_fnc_createAction;

[_civ,0,["ACE_MainActions"],_action] call ace_interact_menu_fnc_addActionToObject;
