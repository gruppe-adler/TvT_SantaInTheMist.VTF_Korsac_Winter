#include "component.hpp"

private _posBlu = getPos blufor_insert; // ["spawnPosBlu",[0,0,0]] call mitm_common_fnc_getIslandConfigEntry;
private _posOpf = getPos opfor_insert; // ["spawnPosOpf",_posBlu] call mitm_common_fnc_getIslandConfigEntry;
private _posIndep = getPos indep_insert; // ["spawnPosIndep",_posBlu] call mitm_common_fnc_getIslandConfigEntry;

{
    if (local _x) then {
        _x allowDamage false;

        if (!isPlayer _x) then {
            _x disableAI "AUTOTARGET";
            _x disableAI "AUTOCOMBAT";
            _x disableAI "PATH";
            _x disableAI "COVER";
            _x disableAI "FSM";
            _x setCombatMode "BLUE";
            _x setVariable ["asr_ai_exclude",true];
        };

        _searchPos = switch (side _x) do {
            case (WEST): {_posBlu};
            case (EAST): {_posOpf};
            case (INDEPENDENT): {_posIndep};
            default {_posBlu};
        };

        _maxDist = 10;
        _pos = [];
        while {count _pos == 0} do {
            _pos = _searchPos findEmptyPosition [0,_maxDist,"B_Soldier_F"];
            _maxDist = _maxDist + 5;
        };

        _x setPos _pos;
    };
    false
} count playableUnits;
