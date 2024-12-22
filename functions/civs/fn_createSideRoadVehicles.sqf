#include "component.hpp"

params ["_locationPosition","_locationRadius","_amountFactor","_houseFactor","_minDistance"];

//LOCAL FUNCTIONS ==============================================================
private _fnc_createMarker = {
    params ["_markerPos","_markerID"];

    _markerName = format ["mitm_civs_sideRoadVehicleMarker_%1",_markerID];
    _marker = createMarker [_markerName, _markerPos];
    _marker setMarkerShape "ICON";
    _marker setMarkerType "c_car";
    _marker setMarkerColor "COLORCIV";

    _marker
};

private _fnc_nearbyVehiclePositions = {
    params ["_pos"];

    _nearbyVehiclePositions = [];
    {if (_pos distance2D _x < _minDistance) then {_nearbyVehiclePositions pushBack _x}} forEach mitm_civs_vehiclePositions;
    _nearbyVehiclePositions
};

private _fnc_isSafe = {
    params ["_pos"];
    // getPos, 0, 0, 2, 0, 0.7, 0, [], [getPos player, getPos player]
    !(_pos isFlatEmpty  [5, -1, 0.1, 15, -1, false, objNull] isEqualTo [])
};


//MAIN =========================================================================
if (isNil "mitm_civs_vehiclePositions") then {mitm_civs_vehiclePositions = []};

private _thesePositions = [];
private _islandType = "russian";
private _availableTypes = [missionConfigFile >> "cfgCivilians" >> _islandType,"vehicles",["C_Offroad_01_F"]] call BIS_fnc_returnConfigEntry;
private _roads = _locationPosition nearRoads _locationRadius;
private _vehiclesToCreate = (round ((count _roads) * 0.07 * _amountFactor));
_vehiclesToCreate = round (2 max (_vehiclesToCreate + ((random (_vehiclesToCreate * 0.4)) - _vehiclesToCreate * 0.2)));

[_locationPosition,_locationRadius,_amountFactor,_houseFactor,_minDistance,_thesePositions,_availableTypes,_roads,_vehiclesToCreate, _fnc_createMarker, _fnc_nearbyVehiclePositions, _fnc_isSafe] spawn {
    params ["_locationPosition","_locationRadius","_amountFactor","_houseFactor","_minDistance","_thesePositions","_availableTypes","_roads","_vehiclesToCreate", "_fnc_createMarker", "_fnc_nearbyVehiclePositions", "_fnc_isSafe"];

    while {count _roads > 0 && count _thesePositions < _vehiclesToCreate} do {
        private ["_vehPos","_canCreate","_chosenDirection","_offRoadFound"];

        _randomRoadID = round (random ((count _roads)-1));
        private _road = _roads deleteAt _randomRoadID;

        if (!isNull _road) then {
            if (count (roadsConnectedTo _road) == 0) exitWith {};
            _roadDir = _road getDir ((roadsConnectedTo _road) select 0);
            _boundingBox = boundingBox _road;
            _width = ((_boundingBox select 1) select 0) - ((_boundingBox select 0) select 0);

            _startDirection = selectRandom [1,-1];
            {
                _chosenDirection = _x;
                _offRoadFound = false;
                for [{_i=1}, {_i<50}, {_i=_i+1}] do {
                    _testPos = _road getRelPos [1.5 + _i*0.2,_roadDir+90*_chosenDirection];
                    _vehPos = _testPos;
                    if (!isOnRoad _testPos) exitWith {_offRoadFound = true};
                };

                private _enoughHouses = if (_houseFactor < 0) then {true} else {(count ([_vehPos,20] call mitm_common_fnc_findBuildings)) * _houseFactor > random 100};

                _canCreate = switch (true) do {
                    case (!_offRoadFound): {"ONROAD"};
                    case (count (getPos _road nearRoads 10) > 2): {"ONINTERSECTION"};
                    case (!_enoughHouses): {"NOHOUSES"};
                    case (count ([_vehPos] call _fnc_nearbyVehiclePositions) > 0): {"TOOCLOSE"};
                    case (!([_vehPos] call _fnc_isSafe)): {"UNSAFE"};
                    default {"CANCREATE"};
                };

                if (_forEachIndex == 1) then {_roadDir = _roadDir + 180};
                if (_canCreate == "CANCREATE") exitWith {};
            } forEach [_startDirection,-_startDirection];

            if (_canCreate == "CANCREATE") then {
                _marker = if (MITM_MISSIONPARAM_DEBUGMODE) then {[_vehPos,count mitm_civs_vehiclePositions] call _fnc_createMarker} else {""};

                _type = selectRandom _availableTypes;
                _thesePositions pushBack _vehPos;
                mitm_civs_vehiclePositions pushBack _vehPos;
                diag_log format ["will create %1 vehicle", _type];
                _veh = createVehicle [_type,[0,0,0],[],0,"CAN_COLLIDE"];
                diag_log format ["created %1 vehicle", _type];
                [{!isNull (_this select 0)}, {
                    params ["_veh","_roadDir","_chosenDirection","_vehPos","_marker"];
                    _veh setDir _roadDir + (90 + 90*_chosenDirection);
                    _vehPos set [2,1];
                    _veh setPos _vehPos;
                    _veh setVelocity [0,0,1];
                    _veh lock 2;
                    [_veh] call mitm_civs_fnc_setVehicleFuel;
                    [_veh,_marker] call mitm_civs_fnc_deleteIfDamaged;
                }, [_veh,_roadDir,_chosenDirection,_vehPos,_marker]] call CBA_fnc_waitUntilAndExecute;
            };
        };
        sleep .5;
    };
};
