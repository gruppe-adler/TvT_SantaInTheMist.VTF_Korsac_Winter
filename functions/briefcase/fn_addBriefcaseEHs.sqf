#include "component.hpp"

if (isServer) then {
    addMissionEventHandler ["HandleDisconnect",mitm_briefcase_fnc_onDisconnect];
};

if (!hasInterface) exitWith {};

{
    if (local _x) then {
        _x addEventhandler ["GetInMan",mitm_briefcase_fnc_onGetIn];
        _x addEventhandler ["GetOutMan",mitm_briefcase_fnc_onGetOut];
        _x addMPEventhandler ["MPKilled",mitm_briefcase_fnc_onKilled];
        _x addEventhandler ["AnimChanged",mitm_briefcase_fnc_onAnimChanged];
    };
} forEach allUnits;

["weapon",mitm_briefcase_fnc_onWeaponChanged] call CBA_fnc_addPlayerEventHandler;
["ace_unconscious",mitm_briefcase_fnc_onUnconscious] call CBA_fnc_addEventHandler;
