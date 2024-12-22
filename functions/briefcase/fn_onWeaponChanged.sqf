#include "component.hpp"

params ["_unit","_weapon"];

if !(_unit getVariable ["mitm_briefcase_hasBriefcase",false]) exitWith {};

if !(_weapon in ["","ACE_FakePrimaryWeapon"]) then {
    [_unit] remoteExec ["mitm_briefcase_fnc_dropBriefcase",2,false];
};
