private _errorCounter = 0;

private _fnc_check = {
    params ["_cfgPath","_entry","_checkCfg"];

    {
        if !(isClass (configFile >> _checkCfg >> _x)) then {
            _errorCounter = _errorCounter + 1;
            diag_log ["error: ",_entry,_x];
        };
    } forEach ([_cfgPath,_entry,[]] call BIS_fnc_returnConfigEntry);
};

{
    diag_log ["checking: ",configName _x];

    [_x,"clothes","cfgWeapons"] call _fnc_check;
    [_x,"headgear","cfgWeapons"] call _fnc_check;
    [_x,"goggles","cfgGlasses"] call _fnc_check;
    [_x,"backpacks","cfgVehicles"] call _fnc_check;
    [_x,"vehicles","cfgVehicles"] call _fnc_check;

} forEach ("true" configClasses (missionConfigFile >> "cfgCivilians"));

systemChat format ["%1 errors found. Check .rpt",_errorCounter];
