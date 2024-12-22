#include "component.hpp"

MITM_ISLANDPARAM_ISWOODLAND = false;

// [] call mitm_init_fnc_disablePlayableUnits;
[] call mitm_init_fnc_setMissionParams;

// open / close map
if (hasInterface) then {
    [{!isNull (findDisplay 46)},{
        if (missionNamespace getVariable ["MITM_SETUP_COUNTDOWNSTARTED",false]) exitWith {};
        openMap [true,!MITM_MISSIONPARAM_DEBUGMODE];
        [{missionNamespace getVariable ["MITM_SETUP_COUNTDOWNSTARTED",false]},{openMap [false,false]},[]] call CBA_fnc_waitUntilAndExecute;
    },[]] call CBA_fnc_waitUntilAndExecute
};

[] call mitm_init_fnc_registerChatCommands;
[] call mitm_groupsettings_fnc_setGroupSettings;
[] call mitm_init_fnc_initCivs;
[] call  mitm_init_fnc_initLoadouts;

[{!isNull player || isDedicated},{

    //setup
    [] call mitm_setup_fnc_createBriefing;
    if ((["teleportPlayersToStart",1] call EFUNC(common,getMissionConfigEntry)) == 1) then {
        [] call mitm_init_fnc_moveToInitPos;
    };
    [] call mitm_setup_fnc_setTime;
    [] call mitm_setup_fnc_setWeather;
    [] call mitm_setup_fnc_setMapRespawnPos;
    [] call mitm_briefcase_fnc_addBriefcaseEHs;

    [{(missionNamespace getVariable ["CBA_missionTime",0]) > 0},{
        [] call mitm_init_fnc_setup;
    },[]] call CBA_fnc_waitUntilAndExecute;

    //vehicles and teleport
    [{missionNamespace getVariable ["MITM_SETUP_PLAYZONECONFIRMATION",false] && {isNil _x} count ["MITM_STARTPOSITION_WEST","MITM_STARTPOSITION_EAST","MITM_STARTPOSITION_INDEP","MITM_STARTPOSITION_COURIER"] == 0},{

        if !(missionNamespace getVariable ["MITM_ISTEMPLATEMISSION",false]) then {
            [] call mitm_setup_fnc_createExfilPoints;
        };

        [WEST,MITM_STARTPOSITION_WEST,"MITM_SETUP_STARTVEHICLEDONE_WEST"] call mitm_setup_fnc_createStartVehicle;
        [EAST,MITM_STARTPOSITION_EAST,"MITM_SETUP_STARTVEHICLEDONE_EAST"] call mitm_setup_fnc_createStartVehicle;
        [INDEPENDENT,MITM_STARTPOSITION_INDEP,"MITM_SETUP_STARTVEHICLEDONE_INDEP"] call mitm_setup_fnc_createStartVehicle;
        [CIVILIAN,MITM_STARTPOSITION_COURIER,"MITM_SETUP_STARTVEHICLEDONE_COURIER"] call mitm_setup_fnc_createStartVehicle;

        if ((["teleportPlayersToStart",1] call EFUNC(common,getMissionConfigEntry)) == 1) then {
            [{missionNamespace getVariable ["MITM_SETUP_STARTVEHICLEDONE_WEST",false]},{[WEST,MITM_STARTPOSITION_WEST] call mitm_setup_fnc_teleportSide},[]] call CBA_fnc_waitUntilAndExecute;
            [{missionNamespace getVariable ["MITM_SETUP_STARTVEHICLEDONE_EAST",false]},{[EAST,MITM_STARTPOSITION_EAST] call mitm_setup_fnc_teleportSide},[]] call CBA_fnc_waitUntilAndExecute;
            [{missionNamespace getVariable ["MITM_SETUP_STARTVEHICLEDONE_INDEP",false]},{[INDEPENDENT,MITM_STARTPOSITION_INDEP] call mitm_setup_fnc_teleportSide},[]] call CBA_fnc_waitUntilAndExecute;
            [{missionNamespace getVariable ["MITM_SETUP_STARTVEHICLEDONE_COURIER",false]},{[CIVILIAN,MITM_STARTPOSITION_COURIER] call mitm_setup_fnc_teleportSide},[]] call CBA_fnc_waitUntilAndExecute;
        } else {
            INFO("Not teleporting players to start - disabled by config.");
        };

    },[]] call CBA_fnc_waitUntilAndExecute;

    //start game countdown
    [{{!(missionNamespace getVariable [_x,false])} count ["MITM_SETUP_STARTVEHICLEDONE_WEST","MITM_SETUP_STARTVEHICLEDONE_EAST","MITM_SETUP_STARTVEHICLEDONE_INDEP","MITM_SETUP_STARTVEHICLEDONE_COURIER"] == 0},{
        [] call mitm_setup_fnc_createTasks;
        [] call mitm_setup_fnc_createBriefcase;
        [{
            [] call mitm_setup_fnc_startGameTimer;
        },[],3] call CBA_fnc_waitAndExecute;

        if (isServer) then {missionNamespace setVariable ["MITM_SETUP_COUNTDOWNSTARTED",true,true]};
    },[]] call CBA_fnc_waitUntilAndExecute;

    //init briefcase
    [{!isNull (missionNamespace getVariable ["mitm_briefcase",objNull])},{
        [] call mitm_briefcase_fnc_addInteractions;
    },[]] call CBA_fnc_waitUntilAndExecute;

    //start game
    [{missionNamespace getVariable ["MITM_SETUP_GAMESTARTED",false]},{
        [mitm_briefcase] call mitm_briefcase_fnc_trackBriefcase;
        [] call mitm_endings_fnc_checkEliminated;
        [] call grad_replay_fnc_init;

        if (isServer) then {
            mitm_bluforPlayers = [west] call grad_winrateTracker_fnc_getPlayerNamesOfSide;
            mitm_opforPlayers = [east] call grad_winrateTracker_fnc_getPlayerNamesOfSide;
            mitm_indepPlayers = [independent] call grad_winrateTracker_fnc_getPlayerNamesOfSide;

            _civPlayers = (([] call BIS_fnc_listPlayers) - entities "HeadlessClient_F") select {side _x == CIVILIAN};
            mitm_civPlayers = _civPlayers apply {name _x};
            mitm_civPlayerUIDs = _civPlayers apply {getPlayerUID _x};
        };
    },[]] call CBA_fnc_waitUntilAndExecute;

    //exit JIP
    if (
        hasInterface &&
        didJIP &&
        missionNamespace getVariable ["MITM_SETUP_GAMESTARTED", false] &&
        {((missionNamespace getVariable ["CBA_missionTime",0]) - (missionNamespace getVariable ["MITM_SETUP_GAMESTARTTIME",0])) > (["jipToSpectatorTime",0] call mitm_common_fnc_getMissionConfigEntry)} &&
        {(playerSide in [EAST,WEST,INDEPENDENT,CIVILIAN])}
    ) exitWith {player allowDamage true; player setDamage 1};

    if (hasInterface && didJIP) then {[player] remoteExec ["mitm_common_fnc_addToZeus",2,false]};

}, []] call CBA_fnc_waitUntilAndExecute;
