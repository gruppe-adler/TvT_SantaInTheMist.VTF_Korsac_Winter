#include "component.hpp"

private _averagePos = [0,0,0];

{
    _averagePos = _averagePos vectorAdd _x;
    false
} count _this;

_averagePos = _averagePos vectorMultiply (1/count _this);

_averagePos
