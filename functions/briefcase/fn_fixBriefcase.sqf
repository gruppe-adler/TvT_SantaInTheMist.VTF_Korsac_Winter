#include "component.hpp"

private _briefcase = missionNamespace getVariable ["mitm_briefcase",objNull];
if (isNull _briefcase) exitWith {};

private _owner = _briefcase getVariable ["mitm_briefcase_owner",objNull];
if (!isNull _owner) then {
    [_owner] call mitm_briefcase_fnc_dropBriefcase;
};

private _searchPos = getPos _briefcase;
_searchPos set [2,0];

private _fixedPos = _searchPos findEmptyPosition [0,100,typeOf _briefcase];

// if no suitable position can be found, just move the briefcase in a random direction
if (count _fixedPos == 0) then {_fixedPos = _searchPos vectorAdd [[-100,100] call BIS_fnc_randomNum,[-100,100] call BIS_fnc_randomNum,1]};

_briefcase setPos _fixedPos;
