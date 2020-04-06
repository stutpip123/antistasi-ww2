spawnPos = getMarkerPos "spawner";
private _normParams = [150, 150, 0, "Bomb_03_F", -1];

_fn_spawnBombWithParams =
{
    _fn_logBombFlight =
    {
        params ["_bomb", "_spawnParams"];
        private _time = time;
        diag_log format ["0: Bomb started with params %1", _spawnParams];
        [0,0,velocity _bomb,(_spawnParams select 1),time,(_spawnParams select 2), [0,0]] params ["_lastDistanceX", "_lastDistanceZ", "_lastVelocity", "_lastSpeed", "_lastTime", "_lastAngle", "_lastAcc"];
        while {alive _bomb} do
        {
            sleep 0.01;
            if(!alive _bomb) exitWith {};
            private _distanceX = _bomb distance2D spawnPos;
            _lastDistanceX = _distanceX;
            private _distanceZ = (_spawnParams select 0) - ((getPosATL _bomb) select 2);
            _lastDistanceZ = _distanceZ;
            private _velocity = velocity _bomb;
            private _velocityX = _velocity select 0;
            private _velocityZ = _velocity select 2;
            private _speed = (speed _bomb) / 3.6;
            _lastSpeed = _speed;
            private _flightTime = time - _time;
            private _deltaTime = time - _lastTime;
            _lastTime = time;
            private _angle = acos ((vectorDir _bomb) vectorCos [1, 0, 0]);
            _lastAngle = _angle;
            private _accX = (_velocityX - (_lastVelocity select 0))/_deltaTime;
            private _accZ = (_velocityZ - (_lastVelocity select 2))/_deltaTime;
            _lastVelocity = _velocity;
            _lastAcc = [_accX, _accZ];
            diag_log format
            [
                "BombFlight Params: %8 FlightTime: %1 DistanceX: %2 DistanceZ: %3 VelocityX: %4 VelocityZ: %5 Speed: %6 AccelerationX: %9 AccelerationZ: %10 Angle: %7",
                _flightTime,
                _distanceX,
                _distanceZ,
                _velocityX,
                _velocityZ,
                _speed,
                _angle,
                _spawnParams,
                _accX,
                _accZ
            ];
        };
        //Calculating the last step of the bomb by the values
        //private _deltaTime = time - _lastTime;
        //_lastDistanceZ = _lastDistanceZ - ((_lastVelocity select 2) + (_lastAcc select 1) * _deltaTime) * _deltaTime;
        //_lastDistanceX = _lastDistanceX + ((_lastVelocity select 0) + (_lastAcc select 0) * _deltaTime) * _deltaTime;
        diag_log format
        [
            "BombFinal Params: %1 TotalFlightTime: %2 TotalDistanceX: %3 ImpactAngle: %4",
            _spawnParams,
            time - _time,
            _lastDistanceX,
            _lastAngle
        ];
    };

    params ["_height", "_speed", "_angle", "_type", ["_mass", -1]];
    private _spawnPos = +spawnPos;
    _spawnPos set [2, _height];

    //Create bomb at position
    private _bomb = _type createVehicle _spawnPos;
    _bomb setPosATL _spawnPos;

    //Sets the mass of the bomb if defined
    if(_mass != -1) then
    {
        _bomb setMass _mass;
    };

    //Set bomb direction vectors
    private _upVector = [sin (_angle), 0, cos (_angle)];
    private _dirVector = [cos (_angle), 0, -sin (_angle)];
    _bomb setVectorDirAndUp [_dirVector, _upVector];

    //Set speed in forward direction
    _bomb setVelocityModelSpace [0, _speed, 0];
    [_bomb, _this] spawn _fn_logBombFlight;
};

_normParams spawn _fn_spawnBombWithParams;
/*
private _heightVariants = [100, 2500, 100];
private _speedVariants = [25, 500, 25];
private _angleVariants = [0, 90, 5];

private _selectedVariant = HEIGHT;
private _selectedArray = _heightVariants;

private _value = _selectedArray select 0;
private _arrayEnd = _selectedArray select 1;
private _stepSize = _selectedArray select 2;

while {_value <= _arrayEnd} do
{

};*/
