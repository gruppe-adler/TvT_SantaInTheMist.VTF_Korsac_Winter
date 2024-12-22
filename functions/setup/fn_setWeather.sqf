#include "component.hpp"

private ["_overcast"];

if (!isServer) exitWith {};

if ((["useParamWeather",1] call EFUNC(common,getMissionConfigEntry)) == 0) exitWith {INFO("Not setting weather - disabled by config.")};

//OVERCAST =====================================================================
//random
if (MITM_MISSIONPARAM_WEATHERSETTING == -1) then {
    _availableSettings = getArray (missionConfigFile >> "Params" >> "WeatherSetting" >> "values");
    _availableSettings = _availableSettings - [-1];
    _overcast = selectRandom _availableSettings;

//fixed
} else {
    _overcast = MITM_MISSIONPARAM_WEATHERSETTING;
};

[_overcast * 0.01] call bis_fnc_setOvercast;

//FOG ==========================================================================
_mid = 0.03;

//extra chance of fog when its raining
if (_overcast >= 75) then {
    _mid = _mid + 0.08;
};

//extra chance of fog in the morning
if (otf_missionParam_TIMEOFDAY <= 8) then {
    _mid = _mid + 0.12;
};

_fog = random [0,_mid,0.4];

0 setFog 0.3; // _fog;
