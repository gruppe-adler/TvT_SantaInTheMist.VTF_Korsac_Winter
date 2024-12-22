params ["_pos"];

private _islandType = "russian";
private _civCfg = missionConfigFile >> "CfgCivilians" >> _islandType;

_group = createGroup [civilian, true];
_unit = _group createUnit ["C_man_1",_pos,[],0,"NONE"];

group _unit setBehaviour "CARELESS";
_unit disableAI "TARGET";
_unit disableAI "AUTOTARGET";
_unit disableAI "FSM";

_unit setUnitLoadout [[],[],[],[selectRandom ([_civCfg,"clothes",[]] call BIS_fnc_returnConfigEntry),[]],[],[],selectRandom ([_civCfg,"headgear",[]] call BIS_fnc_returnConfigEntry),"""",[],["""","""","""","""","""",""""]];
[_unit, selectRandom ([_civCfg,"faces",[]] call BIS_fnc_returnConfigEntry)] remoteExec ["setFace",0,_unit];
_unit addGoggles selectRandom ([_civCfg,"goggles",[]] call BIS_fnc_returnConfigEntry);

_unit setVariable ["asr_ai_exclude", true];
_unit setVariable ["BIS_noCoreConversations",true];


private _centerPos = [];
private _maxDist = 15;
private _roadDir = [_pos] call mitm_common_fnc_getRoadDir;

if (_roadDir < 0) then {
    for [{_i=0}, {_i<10}, {_i=_i+1}] do {
        _isOnRoad = true;
        for [{_j=0}, {_j<10}, {_j=_j+1}] do {
            _centerPos = _pos findEmptyPosition [8,_maxDist,"C_man_1"];
            if (count _centerPos > 0) then {_isOnRoad = isOnRoad _centerPos};
            if (!_isOnRoad) exitWith {};
        };

        if (count _centerPos > 0 && !_isOnRoad) exitWith {};
    };
} else {
    for [{_i=0}, {_i<10}, {_i=_i+1}] do {
        _searchPos = _pos getPos [5 + random 10,_roadDir + 90*(selectRandom [-1,1])];
        _centerPos = _searchPos findEmptyPosition [0,5,"C_man_1"];
        if (count _centerPos > 0) exitWith {};
    };
};

if (count _centerPos == 0) then {_centerPos = _pos};
[_group,_centerPos,10 + (random 10),2 + round (random 2),true,"MOVE","CARELESS","YELLOW","LIMITED",nil,nil,[0,10,20]] call mitm_common_fnc_taskPatrol;

_unit
