#include "component.hpp"

params [["_unit",objNull]];

if (_unit getVariable ["mitm_briefcase_hasBriefcase",false]) then {
    [_unit] call mitm_briefcase_fnc_dropBriefcase;
};


false
