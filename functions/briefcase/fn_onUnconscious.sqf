#include "component.hpp"

params ["_unit","_isUnconscious"];

if !(_isUnconscious) exitWith {};
if !(_unit getVariable ["mitm_briefcase_hasBriefcase",false]) exitWith {};

[_unit] remoteExec ["mitm_briefcase_fnc_dropBriefcase",2,false];
