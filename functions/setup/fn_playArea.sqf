#include "component.hpp"

private _result = [];

if (!isNil "MITM_PLAYZONE_CENTER") then {
    _result = [true,"Using user supplied positions."];
    missionNamespace setVariable ["MITM_ISTEMPLATEMISSION",true,true];

} else {
    missionNamespace setVariable ["MITM_ISTEMPLATEMISSION",false,true];
    for [{_i=0},{_i<30},{_i=_i+1}] do {
        _result = [] call mitm_setup_fnc_createPositions;
        if (_result select 0) exitWith {};
    };
};

_result
