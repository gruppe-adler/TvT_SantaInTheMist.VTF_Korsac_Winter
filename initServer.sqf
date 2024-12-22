/*["uo_handleJIP", "onPlayerConnected", {
    _this call uo_common_fnc_handleJIP;
}] call BIS_fnc_addStackedEventHandler;*/

["Initialize", [true]] call BIS_fnc_dynamicGroups;

// manually overriding weather
0 setFog 0.8;

0 setRain 0;