params ["_building"];

_building addEventHandler
[
    "HandleDamage",
    {
        params ["_object", "_selection", "_damage", "_source", "_projectile"];

        _object allowDamage false;
        _currentDamage = damage _object;

        if(_currentDamage >= 1) exitWith
        {
            [3, "Hit detected, but building is already destroyed", "buildingEH"] call A3A_fnc_log;
            _object allowDamage true;
            _currentDamage;
        };

        _addedDamage = (_damage - _currentDamage) max 0;

        switch (true) do
        {
            case (_projectile == ""):
            {
                //Indirect damage, used for explosions and fall damage and so on
                _addedDamage = _addedDamage * 0.25;
            };
            case (_projectile isKindOf "RocketCore");
            case (_projectile isKindOf "MissileCore"):
            {
                _addedDamage = _addedDamage * 4;
            };
            case (_projectile isKindOf "ShellCore"):
            {
                _addedDamage = _addedDamage * 5;
            };
            case (_projectile isKindOf "TimeBombCore"):
            {
                _addedDamage = _addedDamage * 0.25;
            };
            case (_projectile == ""):
            {
                _addedDamage = _addedDamage * 1.5;
            };
        };

        _damage = _currentDamage + _addedDamage;

        if(_damage >= 1) then
        {
            [_object] spawn A3A_fnc_objectDestroyed;
        };

        diag_log format ["Object %1 || Hit damage %2 || Overall damage %3 || Hit by %4", (typeOf _object), _addedDamage, _damage, str _projectile];
        _object allowDamage true;

        _damage;
    }
];
