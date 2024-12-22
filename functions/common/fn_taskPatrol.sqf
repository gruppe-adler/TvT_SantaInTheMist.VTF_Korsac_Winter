/*
*   taskPatrol function by Rommel (CBA)
*   edited by McDiod to include a blacklist roads parameter
*/


params [
    ["_group", grpNull, [grpNull, objNull]],
    ["_position", [], [[], objNull, grpNull, locationNull], [2, 3]],
    ["_radius", 100, [0]],
    ["_count", 3, [0]],
    ["_blacklistRoads", false, [true]]
];

_group = _group call CBA_fnc_getGroup;
if !(local _group) exitWith {}; // Don't create waypoints on each machine

_position = [_position,_group] select (_position isEqualTo []);
_position = _position call CBA_fnc_getPos;

// Clear existing waypoints first
[_group] call CBA_fnc_clearWaypoints;

// Can pass parameters straight through to addWaypoint
_this =+ _this;
_this set [2,0];
if (count _this > 4) then {
    _this deleteAt 4;
};
if (count _this > 3) then {
    _this deleteAt 3;
};

// Using angles create better patrol patterns
// Also fixes weird editor bug where all WP are on same position
private _step = 360/_count;
private _offset = random _step;
for "_i" from 1 to _count do {

    private _nextPos = _position;
    for [{_j=0}, {_j<15}, {_j=_j+1}] do {
        private _rad = _radius*random [0.1, 0.75, 1];
        private _theta = (_i%2)*180 + sin(deg(_step*_i))*_offset + _step*_i;
        _nextPos = _position getPos [_rad, _theta];

        if (!_blacklistRoads || !isOnRoad _nextPos) exitWith {};
    };


    _this set [1,_nextPos];
    _this call CBA_fnc_addWaypoint;
};

// Close the patrol loop
_this set [1, _position];
_this set [2, _radius];
_this set [3, "CYCLE"];
_this call CBA_fnc_addWaypoint;
