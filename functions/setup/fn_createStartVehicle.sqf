#include "component.hpp"

params ["_side","_searchPos","_varNameComplete"];

if (!isServer) exitWith {};

if ((["spawnStartVehicles",1] call EFUNC(common,getMissionConfigEntry)) == 0) exitWith {
    INFO_1("Not spawning start vehicles ""%1"" - disabled by config.",_varNameComplete);
    missionNamespace setVariable [_varNameComplete,true,true];
};

// spawn vehicle ===============================================================
private _sideVehicles = switch (_side) do {
    case (WEST): {[missionConfigFile >> "cfgFactions" >> MITM_MISSIONPARAM_FACTION_WEST,"startVehicles",[]] call BIS_fnc_returnConfigEntry};
    case (EAST): {[missionConfigFile >> "cfgFactions" >> MITM_MISSIONPARAM_FACTION_EAST,"startVehicles",[]] call BIS_fnc_returnConfigEntry};
    case (INDEPENDENT): {[missionConfigFile >> "cfgFactions" >> MITM_MISSIONPARAM_FACTION_GUER,"startVehicles",[]] call BIS_fnc_returnConfigEntry};
    case (CIVILIAN): {[missionConfigFile >> "cfgFactions" >> MITM_MISSIONPARAM_FACTION_CIV,"startVehicles",[]] call BIS_fnc_returnConfigEntry};
};
private _sideVehicle = _sideVehicles select MITM_ISLANDPARAM_ISWOODLAND;

private _vehicleAmount = ceil ((_side countSide playableUnits)/4);
INFO_2("Start vehicles for side %1: %2",_side,_vehicleAmount);

private _usedRoads = [];
private _dir = 0;

for [{_i=0}, {_i<_vehicleAmount}, {_i=_i+1}] do {

    private _spawnPos = [];

    private _road = roadAt _searchPos;
    if (!isNull _road) then {
        for [{_j=0}, {_j<10}, {_j=_j+1}] do {
            _spawnPos = [_searchPos,[0,5],[0,360],_sideVehicle] call mitm_common_fnc_findRandomPos;
            if (count _spawnPos > 0 && {isOnRoad _spawnPos}) exitWith {};
        };
        _dir = if (count _usedRoads > 0) then {_dir} else {[_road] call mitm_common_fnc_getRoadDir};
        _usedRoads pushBack _road;
    };

    private _maxDist = 15;
    while {count _spawnPos == 0} do {
        _spawnPos = _searchPos findEmptyPosition [0,_maxDist,_sideVehicle];
        _maxDist = _maxDist + 5;
    };

    _searchPos = _searchPos getPos [12,_dir];

    diag_log format ["trying to create start vehicle %1", _sideVehicle];
    private _veh = createVehicle [_sideVehicle,_spawnPos,[],0,"NONE"];
    _veh setVariable ["BIS_enableRandomization",false];
    _veh setDir _dir;
    [_veh] call mitm_common_fnc_emptyContainer;
    _veh setVariable ["ace_vehiclelock_lockpickStrength",300,true];
    _veh setVariable ["ace_vehiclelock_lockSide", _side, true];


    // fill vehicle ============================================================
    private _vehicleContents = switch (_side) do {
        case (WEST): {[missionConfigFile >> "cfgFactions" >> MITM_MISSIONPARAM_FACTION_WEST,"startVehicleContents",[[],[],[],[]]] call BIS_fnc_returnConfigEntry};
        case (EAST): {[missionConfigFile >> "cfgFactions" >> MITM_MISSIONPARAM_FACTION_EAST,"startVehicleContents",[[],[],[],[]]] call BIS_fnc_returnConfigEntry};
        case (INDEPENDENT): {[missionConfigFile >> "cfgFactions" >> MITM_MISSIONPARAM_FACTION_GUER,"startVehicleContents",[[],[],[],[]]] call BIS_fnc_returnConfigEntry};
        case (CIVILIAN): {[missionConfigFile >> "cfgFactions" >> MITM_MISSIONPARAM_FACTION_CIV,"startVehicleContents",[[],[],[],[]]] call BIS_fnc_returnConfigEntry};
    };

    _vehicleContents params [["_backpacks",[]],["_items",[]],["_magazines",[]],["_weapons",[]]];
    {
        for [{_j=0}, {_j<(count _x -1)}, {_j=_j+2}] do {
            _type = _x select _j;
            _amount = _x select (_j+1);

            switch (_forEachIndex) do {
                case (0): {_veh addBackpackCargoGlobal [_type,_amount]};
                case (1): {_veh addItemCargoGlobal [_type,_amount]};
                case (2): {_veh addMagazineCargoGlobal [_type,_amount]};
                case (3): {_veh addWeaponCargoGlobal [_type,_amount]};
            };
        };
    } forEach [_backpacks,_items,_magazines,_weapons];
};



// set public var to true ======================================================
missionNamespace setVariable [_varNameComplete,true,true];
