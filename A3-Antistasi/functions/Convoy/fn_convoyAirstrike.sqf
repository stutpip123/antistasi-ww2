//Loadout for CSAT planes
//["","","PylonMissile_1Rnd_Bomb_03_F","PylonMissile_1Rnd_Bomb_03_F","PylonMissile_1Rnd_Bomb_03_F","PylonMissile_1Rnd_Bomb_03_F","PylonMissile_1Rnd_Bomb_03_F","PylonMissile_1Rnd_Bomb_03_F","",""]


private _pylons = ["","","PylonMissile_1Rnd_Bomb_03_F","PylonMissile_1Rnd_Bomb_03_F","PylonMissile_1Rnd_Bomb_03_F","PylonMissile_1Rnd_Bomb_03_F","PylonMissile_1Rnd_Bomb_03_F","PylonMissile_1Rnd_Bomb_03_F","",""];
private _pylonPaths = (configProperties [configFile >> "CfgVehicles" >> typeOf plane >> "Components" >> "TransportPylonsComponent" >> "Pylons", "isClass _x"]) apply {getArray (_x >> "turret")};
{
    plane removeWeaponGlobal getText (configFile >> "CfgMagazines" >> _x >> "pylonWeapon");
} forEach getPylonMagazines plane;
{
    plane setPylonLoadout [_forEachIndex + 1, _x, true, _pylonPaths select _forEachIndex]
} forEach _pylons;

plane setVariable ["BombLoadout", [["Bomb_03_Plane_CAS_02_F", 6]], true];

[] spawn
{
    private _plane = plane;
    private _target = target;
    private _needsTargetTracking = false;

    //Target may moves around, track target and assume position
    if (_target isEqualType objNull) then
    {
        _needsTargetTracking = true;
    };

    _plane flyInHeight 150;

    private _timeToGround = 5.75;
    private _timeTillNextBomb = 0.15;

    private _bombCount = 0;
    private _loadout = plane getVariable "BombLoadout";

    {
        _bombCount = _bombCount + (_x select 1);
    } forEach _loadout;

    waitUntil
    {
        sleep 0.1;
        private _distanceToFire = (speed _plane / 3.6) * (_timeToGround + (_bombCount * _timeTillNextBomb)/2);
        !(alive _plane) ||
        {(_plane distance2D _target) <= _distanceToFire}
    };

    if !(alive _plane) exitWith {};

    {
        private _bomb = _x select 0;
        private _mode = (getArray (configFile >> "cfgweapons" >> _bomb >> "modes")) select 0;
        if (_mode == "this") then
        {
            _mode = _bomb;
        };
        for "_i" from 1 to (_x select 1) do
        {
            (driver _plane) forceWeaponFire [_bomb, _mode];
            sleep _timeTillNextBomb;
            if !(alive _plane) exitWith {};
        };
        if !(alive _plane) exitWith {};
    } forEach _loadout;
};
