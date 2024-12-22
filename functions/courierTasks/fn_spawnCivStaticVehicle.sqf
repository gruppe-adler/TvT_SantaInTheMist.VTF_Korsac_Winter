#include "component.hpp"

params ["_pos"];

private _road = roadAt _pos;
if (isNull _road) exitWith {objNull};

private _roadDir = [_road] call mitm_common_fnc_getRoadDir;
if (_roadDir < 0) exitWith {objNull};

private _boundingBox = boundingBox _road;
private _width = ((_boundingBox select 1) select 0) - ((_boundingBox select 0) select 0);
private _chosenDirection = selectRandom [-1,1];

_vehPos = [];
for [{_i=1}, {_i<50}, {_i=_i+1}] do {
    _testPos = _road getRelPos [1.5 + _i*0.2,_roadDir+90*_chosenDirection];
    if (!isOnRoad _testPos) exitWith {_vehPos = _testPos};
};
if (count _vehPos == 0) exitWith {objNull};


private _islandType = "russian";
private _civCfg = missionConfigFile >> "CfgCivilians" >> _islandType;
private _veh = createVehicle [selectRandom ([_civCfg,"vehicles",[]] call BIS_fnc_returnConfigEntry),[0,0,0],[],0,"CAN_COLLIDE"];

[{!isNull (_this select 0)}, {
    params ["_veh","_roadDir","_chosenDirection","_vehPos"];
    _veh setDir _roadDir + (90 + 90*_chosenDirection);
    _vehPos set [2,1];
    _veh setPos _vehPos;
    _veh setVelocity [0,0,1];
    _veh lock 2;
    [{if !(canMove _this) then {deleteVehicle _this}},_veh,5] call CBA_fnc_waitAndExecute;
}, [_veh,_roadDir,_chosenDirection,_vehPos]] call CBA_fnc_waitUntilAndExecute;

_veh
