params ["_plane", "_type"];

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
        case ("B_Plane_CAS_01_dynamicLoadout_F"):
        {
            _loadout = ["PylonRack_3Rnd_LG_scalpel","PylonRack_1Rnd_Missile_AGM_02_F","PylonRack_3Rnd_LG_scalpel","PylonRack_3Rnd_Missile_AGM_02_F","PylonRack_3Rnd_LG_scalpel","PylonRack_3Rnd_LG_scalpel","PylonRack_3Rnd_Missile_AGM_02_F","PylonRack_3Rnd_LG_scalpel","PylonRack_1Rnd_Missile_AGM_02_F","PylonRack_3Rnd_LG_scalpel"];
        };
        //Vanilla CSAT CAS
        case ("O_Plane_CAS_02_dynamicLoadout_F"):
        {
            _loadout = ["PylonMissile_1Rnd_LG_scalpel","PylonRack_4Rnd_LG_scalpel","PylonRack_4Rnd_LG_scalpel","PylonRack_4Rnd_LG_scalpel","PylonRack_4Rnd_LG_scalpel","PylonRack_4Rnd_LG_scalpel","PylonRack_4Rnd_LG_scalpel","PylonRack_4Rnd_LG_scalpel","PylonRack_4Rnd_LG_scalpel","PylonMissile_1Rnd_LG_scalpel"];
        };
        //Vanilla IND CAS
        case ("I_Plane_Fighter_03_dynamicLoadout_F"):
        {
            _loadout = ["PylonRack_1Rnd_LG_scalpel","PylonRack_3Rnd_LG_scalpel","PylonRack_3Rnd_LG_scalpel","","PylonRack_3Rnd_LG_scalpel","PylonRack_3Rnd_LG_scalpel","PylonRack_1Rnd_LG_scalpel"];
        };
        //RHS US CAS (A-10)
        case ("RHS_A10"):
        {
            _loadout = ["rhs_mag_ANALQ131","rhs_mag_M151_7_USAF_LAU131","rhs_mag_agm65d_3","rhs_mag_M151_21_USAF_LAU131_3","rhs_mag_M151_7_USAF_LAU131","","rhs_mag_M151_7_USAF_LAU131","rhs_mag_M151_21_USAF_LAU131_3","rhs_mag_agm65d_3","rhs_mag_M151_7_USAF_LAU131","","rhsusf_ANALE40_CMFlare_Chaff_Magazine_x16"];
        };
        //RHS CDF
        case ("rhs_l159_CDF"):
        {
            _loadout = ["rhs_mag_agm65d","rhs_mag_agm65d","rhs_mag_agm65d","rhs_mag_zpl20_apit","rhs_mag_agm65d","rhs_mag_agm65d","rhs_mag_agm65d","rhsusf_ANALE40_CMFlare_Chaff_Magazine_x2"];
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
        //RHS US Air superiority fighter
        case ("rhsusf_f22"):
        {
            _loadout = ["rhs_mag_Sidewinder_int","rhs_mag_aim120d_int","rhs_mag_aim120d_2_F22_l","rhs_mag_aim120d_2_F22_r","rhs_mag_aim120d_int","rhs_mag_Sidewinder_int","rhsusf_ANALE52_CMFlare_Chaff_Magazine_x4"];
        };
        //RHS CDF Air superiority fighter
        case ("rhsgref_cdf_mig29s"):
        {
            _loadout = ["rhs_mag_R73M_APU73","rhs_mag_R73M_APU73","rhs_mag_R73M_APU73","rhs_mag_R73M_APU73","rhs_mag_R77_AKU170_MIG29","rhs_mag_R77_AKU170_MIG29","","rhs_BVP3026_CMFlare_Chaff_Magazine_x2"];
        };
        //RHS Russian Air superiority
        case ("rhs_mig29s_vvs"):
        {
            _loadout = ["rhs_mag_R73M_APU73","rhs_mag_R73M_APU73","rhs_mag_R73M_APU73","rhs_mag_R73M_APU73","rhs_mag_R77_AKU170_MIG29","rhs_mag_R77_AKU170_MIG29","","rhs_BVP3026_CMFlare_Chaff_Magazine_x2"];
        };
        default
        {
            [1, format ["Plane type %1 currently not supported for AA, please add the case!", typeOf _plane], _fileName] call A3A_fnc_log;
        };
    };
};

if !(_loadout isEqualTo []) then
{
    [3, "Selected new loadout for plane, now equiping plane with it", _fileName] call A3A_fnc_log;
    {
        _plane setPylonLoadout [_forEachIndex + 1, _x, true];
    } forEach _loadout;
};
