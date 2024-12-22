#include "component.hpp"

/*
*   Only works on server!
*/

private _adminID = 99999;
if (hasInterface && isServer) then {
    _adminID = clientOwner;
} else {
    {
        private _ownerID = owner _x;
        if (admin _ownerID > 0) exitWith {_adminID = _ownerID};
        false
    } count allPlayers;
};

_adminID
