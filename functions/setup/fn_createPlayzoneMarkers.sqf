#include "component.hpp"

params ["_civPos","_westPos","_eastPos","_indepPos","_missionPositionsData"];

["playZone"] call EFUNC(common,clearMarkerCategory);

["playZone",str _civPos,_civPos,"","ICON","mil_start","COLORCIVILIAN"] call EFUNC(common,createCategoryMarker);
["playZone",str _westPos,_westPos,"","ICON","mil_start","COLORWEST"] call EFUNC(common,createCategoryMarker);
["playZone",str _eastPos,_eastPos,"","ICON","mil_start","COLOREAST"] call EFUNC(common,createCategoryMarker);
["playZone",str _indepPos,_indepPos,"","ICON","mil_start","COLORGUER"] call EFUNC(common,createCategoryMarker);

_missionPositionsData = +_missionPositionsData;

private _missionPositions = _missionPositionsData apply {_x select 0};
private _lastPosition = _missionPositions deleteAt (count _missionPositions -1);
{
    ["playZone",str _x,_x,"","ICON","mil_dot","COLORCIVILIAN"] call EFUNC(common,createCategoryMarker);
    false
} count _missionPositions;

["playZone",str _lastPosition,_lastPosition,"","ICON","mil_end","COLORCIVILIAN"] call EFUNC(common,createCategoryMarker);
