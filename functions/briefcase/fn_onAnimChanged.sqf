#include "component.hpp"

params ["_unit", "_newAnimation"];

if (_unit getVariable ["mitm_briefcase_hasBriefcase",false] && {_newAnimation == "ACE_AmovPercMstpSsurWnonDnon"}) then {
    [_unit] remoteExec ["mitm_briefcase_fnc_dropBriefcase",2,false];
};
