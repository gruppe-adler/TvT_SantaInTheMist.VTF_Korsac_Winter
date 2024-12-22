#include "component.hpp"

params [["_obj",objNull]];

if (isNull _obj) exitWith {false};

_obj in [missionNamespace getVariable ["mitm_courier",objNull],missionNamespace getVariable ["mitm_courier_assistant_1",objNull]]
