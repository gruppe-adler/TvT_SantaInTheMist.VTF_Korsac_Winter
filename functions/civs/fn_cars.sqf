#include "component.hpp"

params ["_playzoneCenter"];

private _startTime = diag_tickTime;

private _searchRadius = 4500 * MITM_MISSIONPARAM_SIZEFACTOR;
private _other = nearestLocations [_playzoneCenter, ["NameLocal"], _searchRadius];
private _villages = nearestLocations [_playzoneCenter, ["NameVillage"], _searchRadius];
private _cities = nearestLocations [_playzoneCenter, ["NameCity"], _searchRadius];
private _capitals = nearestLocations [_playzoneCenter, ["NameCityCapital"], _searchRadius];

private _locationAmountFactor = [missionConfigFile >> "cfgMission" >> "civVehicles", "carLocationAmountFactor", 1] call BIS_fnc_returnConfigEntry;
private _locationMinDist = [missionConfigFile >> "cfgMission" >> "civVehicles", "carLocationMinDist", 30] call BIS_fnc_returnConfigEntry;
private _roadAmountFactor = [missionConfigFile >> "cfgMission" >> "civVehicles", "carRoadAmountFactor", 0.01] call BIS_fnc_returnConfigEntry;
private _roadMinDist = [missionConfigFile >> "cfgMission" >> "civVehicles", "carRoadMinDist", 300] call BIS_fnc_returnConfigEntry;


//create in locations
{
    {
        _locationRadius = switch (_forEachIndex) do {
            case (0): {100};
            case (1): {150};
            case (2): {200};
            case (3): {300};
        };

        [locationPosition _x,_locationRadius,_locationAmountFactor,30,_locationMinDist] call mitm_civs_fnc_createSideRoadVehicles;
        false
    } count _x;
} forEach [_other,_villages,_cities,_capitals];

//create outside of locations
[_playzoneCenter,_searchRadius,_roadAmountFactor,-1,_roadMinDist] call mitm_civs_fnc_createSideRoadVehicles;

INFO_2("Car spawn completed in %1s (%2 cars).",diag_tickTime-_startTime,count mitm_civs_vehiclePositions);
