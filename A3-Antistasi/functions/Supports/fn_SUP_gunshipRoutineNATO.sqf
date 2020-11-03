params ["_gunship", "_strikeGroup", "_supportName"];

//Prepare crew units and spawn them in
private _crewUnit = typeOf (driver _gunship);
private _crew = objNull;

private _mainGunner = objNull;
private _heavyGunner = objNull;

for "_i" from 1 to 3 do
{
    _crew = [_strikeGroup, _crewUnit, getPos _gunship] call A3A_fnc_createUnit;
    if(_i == 1) then
    {
        _crew moveInAny _gunship;
    };
    if(_i == 2) then
    {
        _crew moveInTurret [_gunship, [1]];
        _heavyGunner = _crew;
    };
    if(_i == 3) then
    {
        _crew moveInTurret [_gunship, [2]];
        _mainGunner = _crew;
    };
};

_plane addEventHandler
[
    "Fired",
    {
        params ["_gunship", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];

        private _target = _gunship getVariable ["currentTarget", objNull];
        if(_target isEqualTo objNull) exitWith {};

        if(_target isEqualType objNull) then
        {
            _target = getPosASL _target;
        };

        if(_weapon == "autocannon_40mm_VTOL_01") then
        {
            _target = _target apply {_x + (random 15) - 7.5};
        };
        if(_weapon == "gatling_20mm_VTOL_01") then
        {
            _target = _target apply {_x + (random 20) - 10};
        };
        if(_weapon == "cannon_105mm_VTOL_01") then
        {
            _target = _target apply {_x + (random 25) - 12.5};
        };

        private _speed = speed _projectile;
        private _dir = vectorNormalized (_target vectorDiff (getPosASL _projectile));
        _projectile setVelocity (_dir vectorMultiply _speed);
        _projectile setVectorDir _dir;
    }
];


/*
autocannon_40mm_VTOL_01
cannon_105mm_VTOL_01
gatling_20mm_VTOL_01
*/
