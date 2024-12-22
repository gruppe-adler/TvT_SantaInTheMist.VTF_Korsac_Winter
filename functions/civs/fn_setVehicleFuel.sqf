params ["_veh"];

([missionConfigFile >> "cfgMission" >> "civVehicles","randomFuel",[0.10,1.00]] call BIS_fnc_returnConfigEntry) params ["_fuelMin","_fuelMax"];

_veh setFuel ((random (_fuelMax - _fuelMin)) + _fuelMin);