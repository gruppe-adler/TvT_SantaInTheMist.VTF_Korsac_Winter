#include "component.hpp"

if (!isServer) exitWith {};

params [["_repetitions",0],["_startTime",diag_tickTime]];

private _result = [] call mitm_setup_fnc_playArea;
_result params [["_successful",false]];

if (_successful) then {
    [MITM_STARTPOSITION_COURIER,MITM_STARTPOSITION_WEST,MITM_STARTPOSITION_EAST,MITM_STARTPOSITION_INDEP,MITM_MISSIONPOSITIONSDATA] call mitm_setup_fnc_createPlayzoneMarkers;

    if (!MITM_ISTEMPLATEMISSION) then {
        [format ["Successful (%1). Confirm playzone with chat command #mitm_accept or repeat setup with #mitm_decline",_repetitions],20,"MITM_SETUP_PLAYZONECONFIRMATION",true,true] call mitm_common_fnc_promptAdminResponse;
    } else {
        missionNamespace setVariable ["MITM_SETUP_PLAYZONECONFIRMATION",true,true];
    };

    [{!isNil "MITM_SETUP_PLAYZONECONFIRMATION"}, {
        if (!MITM_SETUP_PLAYZONECONFIRMATION) then {
            ["Repeating setup...","MitM (Admin)"] remoteExec ["mitm_common_fnc_customChat",[] call mitm_common_fnc_getAdminID,false];
            [_repetitions,diag_tickTime] call mitm_init_fnc_setup;
        } else {
            if (!MITM_ISTEMPLATEMISSION) then {
                ["Accepted. Starting game.","MitM (Admin)"] remoteExec ["mitm_common_fnc_customChat",[] call mitm_common_fnc_getAdminID,false];
            };
            [MITM_PLAYZONE_CENTER] call mitm_civs_fnc_cars;
            [MITM_PLAYZONE_CENTER] call mitm_civs_fnc_boats;
            [] remoteExec ["mitm_civs_fnc_setLockPickStrength",CIVILIAN,true];
        };
    }, []] call CBA_fnc_waitUntilAndExecute;
} else {
    _time = diag_tickTime - _startTime;

    if (_repetitions > 6 || _time > 60) then {
        [_repetitions,_time] spawn {
            params ["_repetitions","_time"];
            [format ["Play zone setup failed after %1 repetitions and %2 seconds. Try again with smaller play area size. Mission ending.",_repetitions,_time]] remoteExec ["mitm_common_fnc_customChat",0,false];
            sleep 4;
            "EveryoneLost" call BIS_fnc_endMissionServer;
        };
    } else {
        [_repetitions,_startTime] spawn {
            params ["_repetitions","_startTime"];
            sleep 2;

            MITM_MISSIONPARAM_SIZEFACTOR = MITM_MISSIONPARAM_SIZEFACTOR * 0.7;
            [_repetitions + 1,_startTime] call mitm_init_fnc_setup;
        };
    };
};
