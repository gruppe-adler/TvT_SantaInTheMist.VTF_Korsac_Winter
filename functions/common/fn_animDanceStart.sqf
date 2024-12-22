params ["_unit", ["_civilian", false]];


_unit setVariable ["mitm_animationRunning", true];

if (_civilian) then {
    _unit switchMove "Acts_Dance_02";
} else {
    _unit switchMove "Acts_Dance_01";
};

[{
    params ["_unit"];
    
    // move down quickly
    [{
        params ["_unit"];
        animationState _unit == toLower "Acts_Dance_01" ||
        animationState _unit == toLower "Acts_Dance_02"
    },{
        params ["_unit"];
        _unit setMimic "hurt";
    }, [_unit]] call CBA_fnc_waitUntilAndExecute;

}, [_unit]] call CBA_fnc_execNextFrame;