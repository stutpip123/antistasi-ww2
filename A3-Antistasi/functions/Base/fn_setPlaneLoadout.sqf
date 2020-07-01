private ["_plane", "_type"];

/*  Equips a plane with the needed loadout

    Params:
        _plane: OBJECT : The actual plane object
        _type: STRING : The type of attack plane, either "CAS" or "AA"

    Returns:
        Nothing
*/

private _fileName = "setPlaneLoadout";

private _validInput = false;
private _loadout = [];

if (_type == "CAS") then
{
    _validInput = true;
    switch (typeOf _plane) do
    {
        //Vanilla NATO CAS (A-10)
        case ("B_Plane_CAS_01_F"):
        {
            _loadout = ["PylonRack_3Rnd_LG_scalpel","PylonRack_1Rnd_Missile_AGM_02_F","PylonRack_3Rnd_LG_scalpel","PylonRack_3Rnd_Missile_AGM_02_F","PylonRack_3Rnd_LG_scalpel","PylonRack_3Rnd_LG_scalpel","PylonRack_3Rnd_Missile_AGM_02_F","PylonRack_3Rnd_LG_scalpel","PylonRack_1Rnd_Missile_AGM_02_F","PylonRack_3Rnd_LG_scalpel"];
        };
        //Vanilla CSAT CAS
        case ("O_Plane_CAS_02_F"):
        {
            _loadout = ["PylonMissile_1Rnd_LG_scalpel","PylonRack_4Rnd_LG_scalpel","PylonRack_4Rnd_LG_scalpel","PylonRack_4Rnd_LG_scalpel","PylonRack_4Rnd_LG_scalpel","PylonRack_4Rnd_LG_scalpel","PylonRack_4Rnd_LG_scalpel","PylonRack_4Rnd_LG_scalpel","PylonRack_4Rnd_LG_scalpel","PylonMissile_1Rnd_LG_scalpel"];
        };
        //Vanilla IND CAS
        case ("I_Plane_Fighter_03_F"):
        {
            _loadout = ["PylonRack_1Rnd_LG_scalpel","PylonRack_3Rnd_LG_scalpel","PylonRack_3Rnd_LG_scalpel","","PylonRack_3Rnd_LG_scalpel","PylonRack_3Rnd_LG_scalpel","PylonRack_1Rnd_LG_scalpel"];
        };
        default
        {
            [1, format ["Plane type %1 currently not supported for CAS, please add the case!", typeOf _plane], _fileName] call A3A_fnc_log;
        };
    };
};
if (_type == "AA") then
{
    switch (typeOf _plane) do
    {
        //Vanilla NATO Air superiority fighter
        case ("B_Plane_Fighter_01_F"):
        {
            _loadout = ["PylonRack_Missile_BIM9X_x2","PylonRack_Missile_BIM9X_x2","PylonRack_Missile_BIM9X_x2","PylonRack_Missile_BIM9X_x2","PylonMissile_Missile_BIM9X_x1","PylonMissile_Missile_BIM9X_x1","PylonMissile_Missile_AMRAAM_D_INT_x1","PylonMissile_Missile_AMRAAM_D_INT_x1","PylonMissile_Missile_AMRAAM_D_INT_x1","PylonMissile_Missile_AMRAAM_D_INT_x1","PylonMissile_Missile_AMRAAM_D_INT_x1","PylonMissile_Missile_AMRAAM_D_INT_x1"];
        };
        //Vanilla CSAT Air superiority fighter
        case ("O_Plane_Fighter_02_F"):
        {
            _loadout = ["PylonMissile_Missile_AA_R73_x1","PylonMissile_Missile_AA_R73_x1","PylonMissile_Missile_AA_R73_x1","PylonMissile_Missile_AA_R73_x1","PylonMissile_Missile_AA_R73_x1","PylonMissile_Missile_AA_R73_x1","PylonMissile_Missile_AA_R73_x1","PylonMissile_Missile_AA_R73_x1","PylonMissile_Missile_AA_R77_x1","PylonMissile_Missile_AA_R77_x1","PylonMissile_Missile_AA_R77_INT_x1","PylonMissile_Missile_AA_R77_INT_x1","PylonMissile_Missile_AA_R77_INT_x1"];
        };
        //Vanilla IND Air superiority fighter
        case ("I_Plane_Fighter_04_F"):
        {
            _loadout = ["PylonMissile_Missile_BIM9X_x1","PylonMissile_Missile_BIM9X_x1","PylonRack_Missile_AMRAAM_C_x1","PylonRack_Missile_AMRAAM_C_x1","PylonRack_Missile_BIM9X_x2","PylonRack_Missile_BIM9X_x2"];
        };
        default
        {
            [1, format ["Plane type %1 currently not supported for AA, please add the case!", typeOf _plane], _fileName] call A3A_fnc_log;
        };
    };
};

if !(_loadout isEqualTo []) then
{
    private _pylonPaths = (configProperties [configFile >> "CfgVehicles" >> typeOf _plane >> "Components" >> "TransportPylonsComponent" >> "Pylons", "isClass _x"]) apply
    {
        getArray (_x >> "turret")
    };
    {
        _plane removeWeaponGlobal getText (configFile >> "CfgMagazines" >> _x >> "pylonWeapon")
    } forEach getPylonMagazines _plane;
    {
        _plane setPylonLoadout [_forEachIndex + 1, _x, true, _pylonPaths select _forEachIndex]
    } forEach _loadout;
};
