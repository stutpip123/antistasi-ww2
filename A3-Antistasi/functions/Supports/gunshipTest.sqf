[] spawn {
private _plane = plane;

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
            _target = _target apply {_x + (random 30) - 15};
        };
        if(_weapon == "cannon_105mm_VTOL_01") then
        {
            _target = (_target vectorAdd [0,0,2]) apply {_x + (random 2) - 1};
            _gunship setWeaponReloadingTime [_gunner, _weapon, 0.3];
        };

        private _speed = speed _projectile;
        private _dir = vectorNormalized (_target vectorDiff (getPosASL _projectile));
        _projectile setVelocity (_dir vectorMultiply _speed);
        _projectile setVectorDir _dir;
    }
];

private _targetPos = getMarkerPos "supMarker";



private _targets = _targetPos nearEntities [["Man", "LandVehicle", "Helicopter"], 250];
hint format ["Found %1 targets in the area", count _targets];

{
    hint "Engaging new target!";
    _plane setVariable ["currentTarget", _x];
    (gunner _plane) reveal [_x, 3];
    (gunner _plane) doTarget _x;
    sleep 1.5;
    for "_i" from 1 to 3 do
    {
        hint format ["Shot %1/3", _i];
        heavy forceWeaponFire ["cannon_105mm_VTOL_01", "player"];
        sleep 3;
    };
} forEach _targets;

_plane setVariable ["currentTarget", objNull];



};
