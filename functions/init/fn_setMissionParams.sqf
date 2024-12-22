#include "component.hpp"

MITM_MISSIONPARAM_DEBUGMODE = ("DebugMode" call BIS_fnc_getParamValue) == 1;
MITM_MISSIONPARAM_RANKEDMODE = if (MITM_MISSIONPARAM_DEBUGMODE) then {false} else {("RankedMode" call BIS_fnc_getParamValue) == 1};
MITM_MISSIONPARAM_CIVILIANS = ("Civilians" call BIS_fnc_getParamValue) == 1;
MITM_MISSIONPARAM_SIZEFACTOR = ("AreaSize" call BIS_fnc_getParamValue) / 10;

MITM_MISSIONPARAM_WEATHERSETTING = "WeatherSetting" call BIS_fnc_getParamValue;
MITM_MISSIONPARAM_TIMEOFDAY = "TimeOfDay" call BIS_fnc_getParamValue;
MITM_MISSIONPARAM_COURIERHEADSTART = if (MITM_MISSIONPARAM_DEBUGMODE) then {10} else {"CourierHeadStart" call BIS_fnc_getParamValue};


MITM_MISSIONPARAM_FACTION_WEST = "special_forces";
MITM_MISSIONPARAM_FACTION_EAST = "mafia";
MITM_MISSIONPARAM_FACTION_GUER = "rebels";
MITM_MISSIONPARAM_FACTION_CIV = "courier";
