#include "component.hpp"

params ["_loadoutClassName"];

private _cfg = missionConfigFile >> "Loadouts" >> "Randomization" >> _loadoutClassName;
if (!isClass _cfg) exitWith {ERROR_1("%1 does not have a randomization config.",_loadoutClassName)};

{
    _slotName = configName _x;
    {
        _itemName = configName _x;
        _randomReplacements = [_x,"randomization",[""]] call BIS_fnc_returnConfigEntry;
        _replaceFunction = compile format ["
            params [['_value','']];
            if (_value == '%1') then {
                _value = selectRandom %2;
            };
            _value
        ",_itemName,_randomReplacements];
        [_replaceFunction,_slotName] call GRAD_Loadout_fnc_addReviver;

        false
    } count ("true" configClasses _x);
    false
} count ("true" configClasses _cfg);
