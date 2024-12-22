#include "component.hpp"

// do not set default value for _interactionTime -> see below
params ["_posData",["_blackListTypes",[]],"_interactionTime"];

_posData params ["_pos","_type","_taskObject"];

if (isNil "_type") then {
    private _types = [
        "CIV", 0.5,
        "DEADDROP",0.5
    ];

    private _blackList = +_blackListTypes;
    while {count _blackList > 0} do {
        _blackListType = _blackList deleteAt 0;
        _typesID = _types find _blackListType;
        if (_typesID >= 0) then {
            _types deleteAt (_typesID + 1);
            _types deleteAt _typesID;
        };
    };

    if (count _types == 0) exitWith {[false,objNull,""]};
    _type = _types call BIS_fnc_selectRandomWeighted;

    INFO_2("Randomly selected task object type at %1 to be a %2.",_pos,_type);

} else {
    INFO_2("Task object type at %1 is predefined by user to be a %2.",_pos,_type);
};


private _taskParams = [];
switch (_type) do {
    case ("CIV"): {
        private _civ = objNull;
        private _veh = objNull;
        if (isNil "_taskObject") then {
            _civ = [_pos] call FUNC(spawnCiv);
            _veh = [_pos] call FUNC(spawnCivStaticVehicle);
            _civ setVariable [QGVAR(civOwnedVehicle),_veh];
        } else {
            _civ = _taskObject;
            private _civSynchronizedObjects = synchronizedObjects _civ;
            private _vehID = _civSynchronizedObjects findIf {_x isKindOf "car" || _x isKindOf "tank" || _x isKindOf "helicopter" || _x isKindOf "airplane" || _x isKindOf "ship"};
            if !(_vehID < 0) then {
                _veh = _civ setVariable [QGVAR(civOwnedVehicle),_civSynchronizedObjects param [_vehID,objNull]];
            };
        };

        // add killed EH to penalize courier if he kills civ to interact faster
        _civ addEventHandler ["Killed", {
                params ["_unit", "_killer", "_instigator", "_useEffects"];

                _unit setVariable ["mitm_civKiller", _killer, true];
                if (side _killer isEqualTo civilian && isPlayer _killer) then {
                    diag_log "fucking hell stop killing your friendlies";
                };
        }];

        if (isNil "_interactionTime") then {_interactionTime = 6};
        [_civ,_interactionTime] remoteExec [QFUNC(createCivInteraction),0,true];

        _trigger = [
            _civ,
            [25,25,0,false],
            ["ANYPLAYER","PRESENT",true],
            {(missionNamespace getVariable ['mitm_courier',objNull]) in (_this select 1)},
            {
                private _taskObject = (_this select 0) getVariable [QEGVAR(common,triggerAttachObject),objNull];
                [_taskObject,(missionNamespace getVariable ['mitm_courier',objNull])] call FUNC(civOnVisible);
            }
        ] call EFUNC(common,createTrigger);
        _civ setVariable ["mitm_courierTasks_trigger",_trigger];

        _taskParams = [!isNull _civ,_civ,format ["Meet up with %1.",name _civ]];
    };


    case ("DEADDROP"): {
        _deadDropLogic = [_pos,_taskObject] call FUNC(createDeadDrop);

        if (isNil "_interactionTime") then {_interactionTime = 20};
        [_deadDropLogic,_interactionTime] remoteExec [QFUNC(createDeadDropInteraction),0,true];

        _trigger = [
            _deadDropLogic,
            [25,25,0,false],
            ["ANYPLAYER","PRESENT",true],
            {(missionNamespace getVariable ['mitm_courier',objNull]) in (_this select 1)},
            {[(_this select 0) getVariable [QEGVAR(common,triggerAttachObject),objNull],"Dead Drop",10] remoteExec [QEFUNC(common,temp3dMarker),missionNamespace getVariable ["mitm_courier",objNull],false]}
        ] call EFUNC(common,createTrigger);
        _deadDropLogic setVariable [QGVAR(trigger),_trigger];

        _taskParams = [!isNull _deadDropLogic,_deadDropLogic,"Deposit cache in dead drop."];
    };
};


if !(_taskParams select 0) then {
    _taskParams = [_pos,_blackListTypes + [_type]] call FUNC(createTaskObjects);
};

_taskParams
