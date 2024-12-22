#include "component.hpp"

[{
    params ["_args","_handle"];
    _args params ["_startPos","_maxDist"];

    if (missionNamespace getVariable ["MIMT_SETUP_HEADSTARTTIMELEFT",9999] <= 0) exitWith {
        [_handle] call CBA_fnc_removePerFrameHandler;
    };

    _previousStatus = player getVariable ["mitm_setup_enforceStartTimer_status",true];
    if (player distance2D _startPos > _maxDist) then {
        player setVariable ["mitm_setup_enforceStartTimer_status",false];
        if (_previousStatus) then {
            // handle disconnects
            if (!(position player isEqualTo [0,0,0])) then {
                ["mitm_notification",["CHEATER?",format ["%1 left the start area early!",profileName]]] remoteExec ["bis_fnc_showNotification",0,false];
            };
        };
    } else {
        player setVariable ["mitm_setup_enforceStartTimer_status",true];
        if (!_previousStatus) then {
            ["mitm_notification",["NO CHEATER",format ["%1 moved back into the start area.",profileName]]] remoteExec ["bis_fnc_showNotification",0,false];
        };
    };

},1,[_this select 0,["startTimerEnforceDistance",100] call mitm_common_fnc_getMissionConfigEntry]] call CBA_fnc_addPerFrameHandler;
