#include "component.hpp"

if (!isServer) exitWith {};

params ["_briefcase"];

private _accuracy = ["trackingAccuracy",100] call mitm_common_fnc_getMissionConfigEntry;
private _accuracyFactorNoCourier = ["trackingAccuracyFactorNoCourier",1] call mitm_common_fnc_getMissionConfigEntry;
private _accuracyFactorVehicle = ["trackingAccuracyFactorVehicle",1] call mitm_common_fnc_getMissionConfigEntry;
private _accuracyFactorNoCarrier = ["trackingAccuracyFactorNoCarrier",1] call mitm_common_fnc_getMissionConfigEntry;
private _trackingMarkerFadeout = ["trackingMarkerFadeout",60] call mitm_common_fnc_getMissionConfigEntry;
private _intervalFactorNoCourier = ["trackingIntervalFactorNoCourier",1] call mitm_common_fnc_getMissionConfigEntry;
private _intervalFactorVehicle = ["trackingIntervalFactorVehicle",1] call mitm_common_fnc_getMissionConfigEntry;
private _intervalFactorNoCarrier = ["trackingIntervalFactorNoCarrier",1] call mitm_common_fnc_getMissionConfigEntry;

(["trackingInterval",[60,70]] call mitm_common_fnc_getMissionConfigEntry) params ["_intervalMin","_intervalMax"];
private _intervalRandom = _intervalMax - _intervalMin;
_briefcase setVariable ["mitm_briefcase_currentInterval",_intervalMin + (random _intervalRandom)];

[{
    params ["_args","_handle"];
    _args params ["_briefcase","_accuracy","_accuracyFactorNoCourier","_accuracyFactorVehicle","_accuracyFactorNoCarrier","_intervalMin","_intervalRandom","_intervalFactorNoCourier","_intervalFactorVehicle","_intervalFactorNoCarrier","_trackingMarkerFadeout"];

    if (isNull _briefcase) exitWith {[_handle] call CBA_fnc_removePerFrameHandler};

    _currentInterval = _briefcase getVariable ["mitm_briefcase_currentInterval",_intervalMin];
    _currentAccuracy = _accuracy;

    _owner = _briefcase getVariable ["mitm_briefcase_owner",objNull];
    if !([_owner] call mitm_common_fnc_isCourier) then {
        if (isNull _owner) then {
            _currentInterval = _currentInterval * _intervalFactorNoCarrier;
            _currentAccuracy = _currentAccuracy * _accuracyFactorNoCarrier;
        } else {
            _currentInterval = _currentInterval * _intervalFactorNoCourier;
            _currentAccuracy = _currentAccuracy * _accuracyFactorNoCourier;
        };
    };

    if (!isNull objectParent _owner) then {
        _currentInterval = _currentInterval * _intervalFactorVehicle;
        _currentAccuracy = _currentAccuracy * _accuracyFactorVehicle;
    };

    _currentInterval = _currentInterval max 20;

    _lastRun = _briefcase getVariable ["mitm_briefcase_lastMarkerTime",0];
    if (CBA_missionTime - _lastRun < _currentInterval) exitWith {};
    _briefcase setVariable ["mitm_briefcase_lastMarkerTime",CBA_missionTime];
    _briefcase setVariable ["mitm_briefcase_currentInterval",_intervalMin + (random _intervalRandom)];

    _markerPos = _briefcase getPos [random _currentAccuracy,random 360];
    [_markerPos] remoteExec ["mitm_briefcase_fnc_showTracker",0,false];

    _centerMarker = createMarker [format ["mitm_briefcasemarker_center_%1",CBA_missionTime * 1000],_markerPos];
    _centerMarker setMarkerShape "ICON";
    _centerMarker setMarkerType "mil_dot";
    _centerMarker setMarkerColor "COLORUNKNOWN";
    _centerMarker setMarkerText (format ["%1",[daytime * 3600,"HH:MM"] call BIS_fnc_secondsToString]);

    _areaMarker = createMarker [format ["mitm_briefcasemarker_area_%1",CBA_missionTime * 1000],_markerPos];
    _areaMarker setMarkerShape "ELLIPSE";
    _areaMarker setMarkerColor "COLORCIV";
    _areaMarker setMarkerSize [_currentAccuracy,_currentAccuracy];
    _areaMarker setMarkerBrush "Border";

    _trackingMarkerFadeout = _trackingMarkerFadeout - (_intervalMin - _currentInterval);
    [[_centerMarker,_areaMarker],_trackingMarkerFadeout] call mitm_common_fnc_fadeMarker;

},1,[_briefcase,_accuracy,_accuracyFactorNoCourier,_accuracyFactorVehicle,_accuracyFactorNoCarrier,_intervalMin,_intervalRandom,_intervalFactorNoCourier,_intervalFactorVehicle,_intervalFactorNoCarrier,_trackingMarkerFadeout]] call CBA_fnc_addPerFrameHandler;

_briefcase setVariable ["mitm_briefcaseMarker_running",true];
