#include "component.hpp"

params [["_unit",objNull],["_vehicleMode",false]];

private _briefcase = mitm_briefcase;

if (isNull _unit) exitWith {ERROR_1("Object to attach to is null.",_unit)};

private _prevOwner = _briefcase getVariable ["mitm_briefcase_owner",objNull];
if (!isNull _prevOwner) then {
    _prevOwner setVariable ["mitm_briefcase_hasBriefcase",false,true];
    [_prevOwner,true] remoteExec ["allowSprint",_unit,false];
};

if (_vehicleMode) then {
    private _vehicle = vehicle _unit;

    if (_vehicle isKindOf "RDS_Lada_Base") then {
         _briefcase attachTo [_vehicle,[-0.0866699,0.10498,0.35]];
         _briefcase setVectorDirAndUp ([[vectorDirVisual _vehicle, vectorUpVisual _vehicle], 0, 90, 0] call BIS_fnc_transformVectorDirAndUp);
    } else {
        if (_vehicle isKindOf "RDS_Gaz24_Base") then {
             _briefcase attachTo [_vehicle,[-0.0800781,0.290039,0.36]];
             _briefcase setVectorDirAndUp ([[vectorDirVisual _vehicle, vectorUpVisual _vehicle], 0, 90, 0] call BIS_fnc_transformVectorDirAndUp);
        } else {

            if (_vehicle isKindOf "vn_c_car_04_01") then {
                _briefcase attachTo [_vehicle,[0.30423,-0.963867,-0.201187]];
                _briefcase setVectorDirAndUp ([[vectorDirVisual _vehicle, vectorUpVisual _vehicle], 0, 90, 0] call BIS_fnc_transformVectorDirAndUp);
            } else {
                 if (_vehicle isKindOf "vn_c_car_02_01") then {
                    _briefcase attachTo [_vehicle,[0.128906,-0.259508,0.442696]];
                    _briefcase setVectorDirAndUp ([[vectorDirVisual _vehicle, vectorUpVisual _vehicle], 0, 90, 0] call BIS_fnc_transformVectorDirAndUp);
                } else {
                    if (_vehicle isKindOf "vn_c_car_01_01") then {
                        _briefcase attachTo [_vehicle,[-0.113281,-0.183023,0.538269]];
                        _briefcase setVectorDirAndUp ([[vectorDirVisual _vehicle, vectorUpVisual _vehicle], 0, 90, 0] call BIS_fnc_transformVectorDirAndUp);
                    } else {
                        if (_vehicle isKindOf "vn_c_car_03_01") then {
                            _briefcase attachTo [_vehicle,[0.00439453,-0.375503,0.383415]];
                            _briefcase setVectorDirAndUp ([[vectorDirVisual _vehicle, vectorUpVisual _vehicle], 0, 90, 0] call BIS_fnc_transformVectorDirAndUp);
                        } else {
                            if (_vehicle isKindOf "vn_c_bicycle_01") then {
                                _briefcase attachTo [_vehicle,[0,-0.51077,-0.3]];
                                _briefcase setVectorDirAndUp ([[vectorDirVisual _vehicle, vectorUpVisual _vehicle], 0, 90, 0] call BIS_fnc_transformVectorDirAndUp);
                            } else {
                                if (_vehicle isKindOf "gm_gc_civ_p601") then {
                                    _briefcase attachTo [_vehicle,[-0.139648,-0.258698,0.343185]];
                                    _briefcase setVectorDirAndUp ([[vectorDirVisual _vehicle, vectorUpVisual _vehicle], 0, 90, 0] call BIS_fnc_transformVectorDirAndUp);
                                } else {
                                     if (_vehicle isKindOf "vn_c_wheeled_m151_02") then {
                                        _briefcase attachTo [_vehicle,[0.0898438,-0.540636,0.577072]];
                                        _briefcase setVectorDirAndUp ([[vectorDirVisual _vehicle, vectorUpVisual _vehicle], 0, 90, 0] call BIS_fnc_transformVectorDirAndUp);
                                    } else {
                                        if (_vehicle isKindOf "vn_c_wheeled_m151_01") then {
                                            _briefcase attachTo [_vehicle,[0.123535,-0.563399,-0.466034]];
                                            _briefcase setVectorDirAndUp ([[vectorDirVisual _vehicle, vectorUpVisual _vehicle], 0, 90, 0] call BIS_fnc_transformVectorDirAndUp);
                                        } else {

                                            if (_vehicle isKindOf "GE_Christmas_Boat_01") then {
                                                _briefcase attachTo [0.0649414,-1.14124,-0.490302];
                                            } else {
                                                if (_vehicle isKindOf "xs_Snowmobile_combat") then {
                                                    _briefcase attachTo [_vehicle,[0.0825195,-1.33567,-.5]];
                                                    _briefcase setVectorDirAndUp ([[-0.981144,0.0772819,-0.177153],[-0.173326,0.0537447,0.983397]]);
                                                } else {
                                                    if (_vehicle isKindOf "xs_Snowmobile_base") then {
                                                        _briefcase attachTo [_vehicle,[0.0825195,-1.33567,1]];
                                                        _briefcase setVectorDirAndUp ([[-0.981144,0.0772819,-0.177153],[-0.173326,0.0537447,0.983397]]);
                                                    } else {
                                                        // fallback
                                                        _briefcase attachTo [_vehicle,[0,0,-100]];  
                                                    }
                                                };
                                            };
                                            
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
        };
    };

} else {
    _briefcase attachTo [_unit,[-0.03,-0.3,0],"spine3", true];
    _briefcase setVectorDirAndUp ([[vectorDirVisual _unit, vectorUpVisual _unit], 0, -20, 10] call BIS_fnc_transformVectorDirAndUp);
};
// _briefcase setVectorDirAndUp [[1,0,0],[0,0,1]];

[_unit,false] remoteExec ["allowSprint",_unit,false];
_unit setVariable ["mitm_briefcase_hasBriefcase",true,true];
_briefcase setVariable ["mitm_briefcase_owner",_unit,true];

[side _unit] call mitm_briefcase_fnc_activatePickupPoint;
if (currentWeapon _unit != "") then {
    [_unit,["SwitchWeapon",_unit,_unit,999]] remoteExec ["action",_unit,false];
};
