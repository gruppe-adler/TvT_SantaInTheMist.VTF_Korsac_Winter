#include "component.hpp"

if (!isServer) exitWith {};

private _posBlu = getPos blufor_insert; // ["spawnPosBlu",[0,0,0]] call mitm_common_fnc_getIslandConfigEntry;
private _posOpf = getPos opfor_insert; // ["spawnPosOpf",_posBlu] call mitm_common_fnc_getIslandConfigEntry;
private _posIndep = getPos indep_insert; // ["spawnPosIndep",_posBlu] call mitm_common_fnc_getIslandConfigEntry;
private _posCivilian = getPos civ_insert; // ["spawnPosCiv",_posBlu] call mitm_common_fnc_getIslandConfigEntry;

_posBlu = _posBlu findEmptyPosition [0,20];
_posOpf = _posOpf findEmptyPosition [0,20];
_posIndep = _posIndep findEmptyPosition [0,20];

"respawn_west" setMarkerPos _posBlu;
"respawn_east" setMarkerPos _posOpf;
"respawn_guerrila" setMarkerPos _posIndep;
"respawn_civilian" setMarkerPos _posCivilian;
