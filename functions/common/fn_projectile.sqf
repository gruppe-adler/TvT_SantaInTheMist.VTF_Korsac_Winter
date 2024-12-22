/*
*   Spawns a projectile that impacts at given position.
*   Original by Bohemia Interactive, modified by McDiod.
*
*   Ammo types:
*       "ModuleOrdnanceHowitzer_F_Ammo"
*       "ModuleOrdnanceMortar_F_Ammo"
*       "ModuleOrdnanceRocket_F_Ammo"
*
*/

params [["_pos",[0,0,0]],["_dir",0],["_ammo","ModuleOrdnanceMortar_F_Ammo"],["_playRadio",false]];

if !(isServer) exitwith {_this remoteExec ["mitm_common_fnc_projectile",2,false]};
if !(canSuspend) exitWith {_this spawn mitm_common_fnc_projectile};

private _posAmmo = +_pos;
_posAmmo set [2,0];

private _cfgAmmo = configfile >> "cfgAmmo" >> _ammo;
private _simulation = toLower getText (_cfgAmmo >> "simulation");
private _altitude = 0;
private _velocity = [];
private _radio = "";
private _delay = 60;
private _sound = "";
private _soundSourceClass = "";
private _hint = [];
private _shakeStrength = 0;
private _shakeRadius = 0;

switch (_simulation) do {
	case "shotshell": {
		_altitude = 1000;
		_velocity = [0,0,-100];
		_radio = "SentGenIncoming";
		_sounds = if (getNumber (_cfgAmmo >> "hit") < 200) then {["mortar1","mortar2"]} else {["shell1","shell2","shell3","shell4"]};
		_sound = _sounds call BIS_fnc_selectRandom;
		_hint = ["Curator","PlaceOrdnance"];
		_shakeStrength = 0.01;
		_shakeRadius = 300;
	};
	case "shotsubmunitions": {
		_posAmmo = [_posAmmo,500,_dir + 180] call BIS_fnc_relPos;
		_altitude = 1000 - ((getTerrainHeightASL _posAmmo) - (getTerrainHeightASL _pos));
		_posAmmo set [2,_altitude];
		_velocity = [sin _dir * 68,cos _dir * 68,-100];
		_radio = "SentGenIncoming";
		_hint = ["Curator","PlaceOrdnance"];
		_shakeStrength = 0.02;
		_shakeRadius = 500;
	};
	case "shotilluminating": {
		_altitude = 66;
		_velocity = [wind select 0,wind select 1,30];
		_sound = "SN_Flare_Fired_4";
		_soundSourceClass = "SoundFlareLoop_F";
	};
	case "shotnvgmarker";
	case "shotsmokex": {
		_altitude = 0;
		_velocity = [0,0,0];
	};
	default {["Ammo simulation '%1' is not supported",_simulation] call BIS_fnc_error;};
};

private _fnc_playRadio = {
	if (_radio != "") then {
		_entities = _pos nearEntities ["All",100];
		_sides = [];
		{
			if (isPlayer _x) then {
				_side = side group _x;
				if (_side in [east,west,resistance,civilian]) then {
					//--- Play radio (only if it wasn't played recently)
					if (time > _x getVariable ["BIS_fnc_moduleProjectile_radio",-_delay]) then {
						[[_side,_radio,"side"],"BIS_fnc_sayMessage",_x] call BIS_fnc_mp;
						_x setVariable ["BIS_fnc_moduleProjectile_radio",time + _delay];
					};
				};
			};
		} foreach _entities;
	};
};

if (count _velocity == 3) then {

	//--- Create projectile
	_posAmmo set [2,_altitude];
	_projectile = createvehicle [_ammo,_posAmmo,[],0,"none"];
	_projectile setpos _posAmmo;
	_projectile setvelocity _velocity;

	//--- Create sound source
	_soundSource = if (_soundSourceClass != "") then {createSoundSource [_soundSourceClass,_pos,[],0]} else {objnull};

	//--- Play radio warning
    if (_playRadio) then {
        [] call _fnc_playRadio;
    };

	waituntil {
		_soundSource setposatl getPosATL _projectile;

		sleep 0.1;
		isnull _projectile
	};

	deletevehicle _projectile;
	deletevehicle _soundSource;
};
