#include "component.hpp"

params ["_vector1","_vector2"];

private _angle = acos ((_vector1 vectorDotProduct _vector2)/(vectorMagnitude _vector1 * vectorMagnitude _vector2));
if (_angle > 180) then {_angle = -(_angle - 180)};

_angle
