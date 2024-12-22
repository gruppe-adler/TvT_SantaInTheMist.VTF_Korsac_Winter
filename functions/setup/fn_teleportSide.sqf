#include "component.hpp"

[{
    params ["_side","_searchPos"];

    {
        if (local _x && {side _x == _side}) then {
            _maxDist = 15;
            _pos = [];
            _x enableSimulation true;
            while {count _pos == 0} do {

                // try to find a road position
                _pos = [_searchPos,[5,_maxDist],[0,360],typeOf _x,false,true] call mitm_common_fnc_findRandomPos;

                for [{_i=0},{_i<10},{_i=_i+1}] do {
                    _pos = [_pos,[0,5]] call mitm_common_fnc_findRandomPos;
                    if (count _pos > 0 && {isOnRoad _pos}) exitWith {};
                };


                // ignore roads if no position has been found
                if (count _pos == 0) then {
                    _pos = [_searchPos,[5,_maxDist],[0,360],typeOf _x,false,false] call mitm_common_fnc_findRandomPos;

                    if (count _pos > 0) then {
                        _pos = _pos findEmptyPosition [0,10,typeOf _x];
                    };
                };
                _maxDist = _maxDist + 5;
            };

            _onTP = if (_side != CIVILIAN && {_x == player}) then {
                {[_this select 0] call mitm_setup_fnc_enforceStartTimer}
            } else {{}};
            _onTPParams = [_pos];

            [_x,_pos,_onTP,_onTPParams] call mitm_common_fnc_teleport;
        };
        false
    } count playableUnits;

}, _this, random 3] call CBA_fnc_waitAndExecute;
