#include "component.hpp"

params ["_side"];

private _sideName = switch (_side) do {
    case (WEST): {"Special Forces"};
    case (EAST): {"Mafia"};
    case (INDEPENDENT): {"Rebels"};
    case (CIVILIAN): {"Courier"};
    default {"UNKNOWN"};
};

_sideName
