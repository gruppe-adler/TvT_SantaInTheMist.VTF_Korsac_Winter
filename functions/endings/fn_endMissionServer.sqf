#include "component.hpp"

params [["_winningSide",sideUnknown],["_endText","ERROR: _endText EMPTY"]];

if (!isServer) exitWith {};
if (!canSuspend) exitWith {_this spawn FUNC(endMissionServer)};

// check if different ending in progress
if (missionNamespace getVariable ["mitm_endInProgressServer",false]) exitWith {INFO_1("Ending %1 triggered, but a different ending is already in progress.",_endText)};
missionNamespace setVariable ["mitm_endInProgressServer",true];

// display winner
private _winningText = switch (_winningSide) do {
    case (WEST): {"SPECIAL FORCES WIN"};
    case (EAST): {"MAFIA WINS"};
    case (INDEPENDENT): {"REBELS WIN"};
    case (CIVILIAN): {"COURIER WINS"};
};
private _text = format ["<img size= '6' style='vertical-align:middle' shadow='false' image='data\gruppe-adler.paa'/><br/><t size='.9' color='#FFFFFF'>%1<br/>%2</t>", _endText, _winningText];
[_text,0,0,2,2] remoteExec ["BIS_fnc_dynamicText",0,false];
INFO(_endText);
INFO(_winningText);

sleep 5;


// display courier points and enter spectator
[[],{
    if (!hasInterface) exitWith {};

    [player, true] call TFAR_fnc_forceSpectator;

    if (!isNil "MITM_COURIERPOINTSCATEGORIZED") then {
        [[],[],[],MITM_COURIERPOINTSCATEGORIZED] call mitm_points_fnc_displayPoints;
    } else {
        systemChat "Courier points this game have not been received. Not displaying points.";
    };
}] remoteExecCall ["call",0,false];

sleep 13;


if (MITM_MISSIONPARAM_RANKEDMODE) then {
    // display courier highscores
    [[],{
        if (!hasInterface) exitWith {};
        if (!isNil "MITM_COURIERSTATSCOMPILED") then {
            [15,MITM_COURIERSTATSCOMPILED,"Courier Highscore",true,[true,1,false]] call grad_scoreboard_fnc_loadScoreboard;
        } else {
            systemChat "Courier highscores have not been received. Not displaying scoreboard.";
        };
    }] remoteExecCall ["call",0,false];

    sleep 16;


    // display player highscores
    [[],{
        if (!hasInterface) exitWith {};
        if (!isNil "MITM_MISSIONSTATS") then {
            MITM_MISSIONSTATS call grad_scoreboard_fnc_loadScoreboard;
        } else {
            systemChat "Mission stats have not been received. Not displaying scoreboard.";
        };
    }] remoteExecCall ["call",0,false];

    sleep 18;
};


// play replay
[] call GRAD_replay_fnc_stopRecord;
waitUntil {missionNamespace getVariable ["REPLAY_FINISHED",false]};


// end mission
if (MITM_MISSIONPARAM_DEBUGMODE) then {
    "Debug mode is on. End mission manually." remoteExec ["systemChat",0,false];
} else {
    sleep 5;
    [[_winningSide],{
        params ["_winningSide"];
        ["end1",_winningSide == playerSide, true, true, true] spawn BIS_fnc_endMission;
    }] remoteExec ["spawn",0,false];
};
