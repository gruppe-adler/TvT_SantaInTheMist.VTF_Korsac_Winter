#include "component.hpp"

params ["_playzoneCenter"];

private _startTime = diag_tickTime;

private _fnc_createMarker = {
    params ["_markerPos","_markerID"];

    _markerName = format ["mitm_civs_boatMarker_%1",_markerID];
    _marker = createMarker [_markerName, _markerPos];
    _marker setMarkerShape "ICON";
    _marker setMarkerType "c_ship";
    _marker setMarkerColor "COLORCIV";

    _marker
};

private _amountFactor = [missionConfigFile >> "cfgMission" >> "civVehicles","boatCoastAmountFactor",1] call BIS_fnc_returnConfigEntry;
private _availableTypes = [missionConfigFile >> "cfgMission" >> "civVehicles","boatTypes",["C_Boat_Civil_01_F"]] call BIS_fnc_returnConfigEntry;

private _boatsToCreate = round (_amountFactor * 4.5 * MITM_MISSIONPARAM_SIZEFACTOR);

private _thesePositions = [];
private _loopCount = 0;
private _searchRadius = 4500 * MITM_MISSIONPARAM_SIZEFACTOR;

while {count _thesePositions < _boatsToCreate && {_loopCount < _boatsToCreate * 100}} do {
    _searchPos = [_playzoneCenter,[0,_searchRadius],[0,360],""] call mitm_common_fnc_findRandomPos;
    _coastPos = [_searchPos,500, 2] call mitm_common_fnc_nearestCoast;
    // _coastPos = [_searchPos,500, 2, 5, 3] call mitm_common_fnc_nearestCoast;

    if !(_coastPos isEqualTo [0,0,0]) then {
        _type = selectRandom _availableTypes;
        _thesePositions pushBack _coastPos;
        _marker = if (MITM_MISSIONPARAM_DEBUGMODE) then {[_coastPos,count _thesePositions] call _fnc_createMarker} else {""};
        diag_log format ["trying to create boat %1", _type];
        _veh = createVehicle [_type,[0,0,0],[],0,"CAN_COLLIDE"];

        [{!isNull (_this select 0)}, {
            params ["_veh","_coastPos","_marker"];
            _veh setDir random 360;
            _veh setPos _coastPos;
            _veh setVelocity [0,0,1];
            _veh lock 0;
            [_veh] call mitm_civs_fnc_setVehicleFuel;
            [_veh,_marker] call mitm_civs_fnc_deleteIfDamaged;
        }, [_veh,_coastPos,_marker]] call CBA_fnc_waitUntilAndExecute;
    };

    _loopCount = _loopCount + 1;
};

INFO_2("Boat spawn completed in %1s (%2 boats).",diag_tickTime-_startTime,count _thesePositions);
