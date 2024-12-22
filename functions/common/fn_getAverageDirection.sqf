/* Calculates average direction between first and all other points in _this array */

#include "component.hpp"

params ["_center","_positions"];

private _averageCoords = [0,0];
{
    _dir = _center getDir _x;
    _averageCoords params ["_aX","_aY"];
    _averageCoords set [0,_aX + (sin _dir)];
    _averageCoords set [1,_aY + (cos _dir)];

    false
} count _positions;

_averageCoords params ["_aX","_aY"];
private _averageDir = _aX atan2 _aY;

_averageDir
