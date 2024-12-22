params ["_unit"];

_unit setVariable ["mitm_animationRunning", true];

_unit switchMove "Acts_Executioner_Squat";

[{
    params ["_unit"];
    
    // move down quickly
    [{
        params ["_unit"];
        animationState _unit == toLower "Acts_Executioner_Squat"
    },{
        params ["_unit"];
        _unit setAnimSpeedCoef 5;
        _unit setMimic "hurt";

        [{
            params ["_unit"];
            animationState _unit == toLower "Acts_Executioner_Squat" && moveTime _unit > 1
        },{
            params ["_unit"];
            _unit setAnimSpeedCoef 1;
        }, [_unit]] call CBA_fnc_waitUntilAndExecute;

    }, [_unit]] call CBA_fnc_waitUntilAndExecute;

}, [_unit]] call CBA_fnc_execNextFrame;