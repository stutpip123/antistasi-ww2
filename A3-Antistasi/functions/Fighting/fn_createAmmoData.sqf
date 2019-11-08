params ["_weapon"];

_magazines = getWeaponMagazinesFromConfig

{
    private _path = configFile >> "CfgAmmo" >> (typeOf _x);
    private _damage = getText (_path >> "hit");
    private _airFriction = getText (_path >> "airFriction")
} forEach _magazines;
