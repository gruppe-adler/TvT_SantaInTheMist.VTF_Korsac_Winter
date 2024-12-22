#include "component.hpp"

private _blufor = [missionConfigFile >> "cfgFactions" >> MITM_MISSIONPARAM_FACTION_WEST,"loadouts",["",""]] call BIS_fnc_returnConfigEntry;
private _opfor = [missionConfigFile >> "cfgFactions" >> MITM_MISSIONPARAM_FACTION_EAST,"loadouts",["",""]] call BIS_fnc_returnConfigEntry;
private _indep = [missionConfigFile >> "cfgFactions" >> MITM_MISSIONPARAM_FACTION_GUER,"loadouts",["",""]] call BIS_fnc_returnConfigEntry;
private _civ = [missionConfigFile >> "cfgFactions" >> MITM_MISSIONPARAM_FACTION_CIV,"loadouts",["",""]] call BIS_fnc_returnConfigEntry;

private _bluforLoadout = _blufor select MITM_ISLANDPARAM_ISWOODLAND;
private _opforLoadout = _opfor select MITM_ISLANDPARAM_ISWOODLAND;
private _indepLoadout = _indep select MITM_ISLANDPARAM_ISWOODLAND;
private _civLoadout = _civ select MITM_ISLANDPARAM_ISWOODLAND;

["BLU_F",_bluforLoadout] call GRAD_Loadout_fnc_FactionSetLoadout;
["OPF_F",_opforLoadout] call GRAD_Loadout_fnc_FactionSetLoadout;
["IND_F",_indepLoadout] call GRAD_Loadout_fnc_FactionSetLoadout;
["CIV_F",_civLoadout] call GRAD_Loadout_fnc_FactionSetLoadout;

// set courier randomization manually, because it is island dependent
/*
private _islandType = "russian";
{
    _x params ["_slotName","_civConfigTypeName"];

    _itemName = [missionConfigFile >> "Loadouts" >> "Faction" >> "courier" >> "Type" >> "man_p_fugitive_F",_slotName,""] call BIS_fnc_returnConfigEntry;
    _randomReplacements = [missionConfigFile >> "cfgCivilians" >> _islandType,_civConfigTypeName,[""]] call BIS_fnc_returnConfigEntry;
    _replaceFunction = compile format ["
        params [['_value','']];
        if (_value == '%1') then {
            _value = selectRandom %2;
        };
        _value
    ",_itemName,_randomReplacements];
    [_replaceFunction,_slotName] call GRAD_Loadout_fnc_addReviver;

    false
} count [["uniform","clothes"],["headgear","headgear"]];
*/