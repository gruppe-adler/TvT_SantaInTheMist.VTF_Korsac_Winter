params ["_unit"];

_unit switchMove "Acts_Executioner_Squat_End";

// catch glitchy behaviour
[{
    params ["_unit"];

    // move up quickly
    [{
        params ["_unit"];
        animationState _unit == toLower "Acts_Executioner_Squat_End"
    },{
        params ["_unit"];
        _unit setAnimSpeedCoef 7;

    }, [_unit]] call CBA_fnc_waitUntilAndExecute;

    [{
        params ["_unit"];
        animationState _unit != toLower "Acts_Executioner_Squat_End"
    },{
        params ["_unit"];
        _unit setVariable ["mitm_animationRunning", false];
        _unit setVariable ["mitm_animationAborted", false];
        _unit setMimic "neutral";
        _unit switchMove "";
        _unit setAnimSpeedCoef 1;
    }, [_unit]] call CBA_fnc_waitUntilAndExecute;

}, [_unit]] call CBA_fnc_execNextFrame;