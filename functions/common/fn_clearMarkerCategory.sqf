#include "component.hpp"

params ["_categoryName"];

if (isNil "MITM_COMMON_MARKERNAMESPACE") exitWith {};

{
    deleteMarker _x;
    false
} count (MITM_COMMON_MARKERNAMESPACE getVariable [_categoryName,[]]);
