#include "component.hpp"

params [["_winner",SIDEUNKNOWN]];

if (!isServer) exitWith {};

private _courier = missionNamespace getVariable ["mitm_courier",objNull];
if (alive _courier) then {[CIVILIAN,10,"Survived"] call mitm_points_fnc_addPoints};
if (side _courier == _winner) then {[CIVILIAN,5,"Joined Winner"] call mitm_points_fnc_addPoints};

MITM_COURIERPOINTSCATEGORIZED = [([CIVILIAN] call mitm_points_fnc_getPointsCategorized),[],{_x select 1},"DESCEND"] call BIS_fnc_sortBy;
publicVariable "MITM_COURIERPOINTSCATEGORIZED";

if (!MITM_MISSIONPARAM_RANKEDMODE) exitWith {};

//courier stats ================================================================
private _courierStats = profileNamespace getVariable ["mitm_courierStats",[[],["",-1]] call CBA_fnc_hashCreate];
private _courierPointsThisGame = [CIVILIAN] call mitm_points_fnc_getPoints;
{
    ([_courierStats,_x] call CBA_fnc_hashGet) params ["","_playerHighScore"];
    if (_courierPointsThisGame > _playerHighScore) then {_playerHighScore = _courierPointsThisGame};
    [_courierStats,_x,[(mitm_civPlayers select _forEachIndex),_playerHighScore]] call CBA_fnc_hashSet;
} forEach mitm_civPlayerUIDs;

MITM_COURIERSTATSCOMPILED = [["Courier","Points"]];
[_courierStats,{MITM_COURIERSTATSCOMPILED pushBack _value}] call CBA_fnc_hashEachPair;
publicVariable "MITM_COURIERSTATSCOMPILED";

profileNamespace setVariable ["mitm_courierStats",_courierStats];
saveProfileNamespace;

// main stats ==================================================================
private _otherSides = [WEST,EAST,INDEPENDENT,CIVILIAN];
private _otherSideNames = ["SPEC.FORCES","MAFIA","REBELS","COURIER"];
private _otherSidePlayers = [mitm_bluforPlayers,mitm_opforPlayers,mitm_indepPlayers];

private _winnerID = _otherSides find _winner;

_otherSides deleteAt _winnerID;
private _winnerName = _otherSideNames deleteAt _winnerID;
private _winnerPlayers = _otherSidePlayers deleteAt _winnerID;

private _losingPlayerNames = [];
{_losingPlayerNames append _x} forEach _otherSidePlayers;

// only count courier players stats if they won (courier >> autolose)
if (isNil "_winnerPlayers") then {_winnerPlayers = mitm_civPlayers};

MITM_MISSIONSTATS = [_winnerPlayers,_losingPlayerNames,_winnerName,_otherSideNames] call grad_winrateTracker_fnc_saveWinrate;
publicVariable "MITM_MISSIONSTATS";
