#include "component.hpp"

params ["_categoryName","_name","_pos",["_text",""],["_shape","ICON"],["_type","hd_dot"],["_color","COLORBLACK"]];

private _marker = createMarker [_name,_pos];
_marker setMarkerText _text;
_marker setMarkerShape _shape;
_marker setMarkerType _type;
_marker setMarkerColor _color;


if (isNil "MITM_COMMON_MARKERNAMESPACE") then {MITM_COMMON_MARKERNAMESPACE = [] call CBA_fnc_createNamespace};
if (isNil {MITM_COMMON_MARKERNAMESPACE getVariable _categoryName}) then {MITM_COMMON_MARKERNAMESPACE setVariable [_categoryName,[]]};

private _category = MITM_COMMON_MARKERNAMESPACE getVariable _categoryName;
_category pushBack _marker;
