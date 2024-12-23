[] spawn {
    _adjustLight = {
        CHBN_adjustBrightness = CHBN_adjustBrightness max 0 min 1;
        _brightness = if (CHBN_adjustBrightness > 0) then {200 * abs (1 - (2 ^ CHBN_adjustBrightness))} else {0};
        CHBN_light setLightAttenuation [10e10,(30000 / (_brightness max 10e-10)),4.31918e-005,4.31918e-005];
        CHBN_light setLightAmbient CHBN_adjustColor;
    };
    
    waitUntil {time > 0};
    if (missionNamespace getVariable ["CHBN_running",false]) exitWith {systemChat "CHBN script is running. Addon disabled."};
    CHBN_running = true;
    
    CHBN_adjustBrightness = missionNamespace getVariable ["CHBN_adjustBrightness",0.3]; // edit the level of brightness here, set to 1, can be 0.1 to however high you want it
    CHBN_adjustColor = missionNamespace getVariable ["CHBN_adjustColor",[0.5,0.7,1]];

    if (!isNil "CHBN_light") then {deleteVehicle CHBN_light};
    CHBN_light = "#lightpoint" createVehicleLocal [worldSize/2, worldSize/2, 1000];
    CHBN_light setLightBrightness 1;
    CHBN_light setLightDayLight false;
    call _adjustLight;

    for "_i" from 0 to 1 step 0 do {
        _adjustBrightness = CHBN_adjustBrightness;
        _adjustColor = CHBN_adjustColor;
        waitUntil {!(_adjustBrightness isEqualTo CHBN_adjustBrightness) || !(_adjustColor isEqualTo CHBN_adjustColor)};
        call _adjustLight;
    };
};

["xs_Snowmobile_base", "init", {

    params ["_vehicle"];

    // every client

   

    // systemchat format ["speed %1 - move %2 - size %3", _speed, _MoveVelocityVarLeft, _size];

    [{
        params ["_args", "_handle"];
        _args params ["_vehicle"];

        if (isNull _vehicle) exitWith {
            [_handle] call CBA_fnc_removePerFrameHandler;
        };

        if (!alive _vehicle) exitWith {
            [_handle] call CBA_fnc_removePerFrameHandler;
        };

        if (isNull driver _vehicle) exitWith {};

        if (isGamePaused || !isGameFocused) exitWith {};

        if (timeMultiplier < 1 || accTime < 1) exitWith {}; // prevent execution in camera slowmo

        private _speed = speed _vehicle;
        private _lifetime = 1 + ((_speed - 3) + ([0,5,0,1] call BIS_fnc_interpolate));        
        private _randomL = 1 + random 0.1;
        private _randomR = 1 + random 0.1;
        private _MoveVelocityVarLeft = [0.1 * _speed * _randomL,0,0.035 * _speed * _randomL];
        private _MoveVelocityVarRight = [-0.1 * _speed * _randomR,0,0.035 * _speed * _randomR];
        private _color = [[1,1,1,0.6],[1,1,1,0.7],[1,1,1,0.4],[1,1,1,0.3],[1,1,1,0.14],[1,1,1,0.03]];
        private _animationSpeed = 1;
        private _particleShape = "\ca\data\cl_basic";
        private _sizeCoef = 0.035 * (0.1 + ((_speed - 3) + ([0,5,0,1.5] call BIS_fnc_interpolate)));
		private _size = [0.5*_sizeCoef,10*_sizeCoef,20*_sizeCoef,30*_sizeCoef];


        if (_speed > 1 || _speed < -1) then {
            drop [
            _particleShape,
            "", "Billboard", 1, _lifetime,
            [0, 0, 0],
            _MoveVelocityVarLeft, _animationSpeed,
            10000,
            10,
            1,
            _size,
            _color,
            [0,1,0,1,0,1], 0, 0, "", "", _vehicle];

             drop [
            _particleShape,
            "", "Billboard", 1, _lifetime,
            [0, 0, 0],
            _MoveVelocityVarRight, _animationSpeed,
            10000,
            10,
            1,
            _size,
            _color,
            [0,1,0,1,0,1], 0, 0, "", "", _vehicle];
        };

    }, 0.1, [_vehicle]] call CBA_fnc_addPerFrameHandler;


}, true, [], true] call CBA_fnc_addClassEventHandler;