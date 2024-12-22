

if (player getvariable ["tauntCooldown", false]) exitWith {};
if (isNull (missionNamespace getVariable ["mitm_briefcase",objNull])) exitWith {};

[player] remoteExec ["mitm_courierTasks_fnc_createParticlesLocalTaunt"];

private _briefcase = missionNamespace getVariable ["mitm_briefcase",objNull];
_briefcase setVariable ["mitm_briefcase_lastMarkerTime", CBA_missionTime - 21]; 
// 20 is max delay, so marker script should send a new one almost instantly

player setvariable ["tauntCooldown", true];

[{
	player setvariable ["tauntCooldown", false];
}, [], 0.25] call CBA_fnc_waitAndExecute;