////////////////////////////////////
//       NAMES AND FLAGS         ///
////////////////////////////////////
nameTeamPlayer = "Renegade";
SDKFlag = "776th_flag";
typePetros = "TIOW_Cultist_I";
_TIOW_maps = ["coci_concretumcivitas"];

if (worldName in _TIOW_maps) then {
	SDKFlagTexture = "Pictures\Mission\TIOW_Renegade_Flag.jpg";
}else{
	SDKFlagTexture = "a3\data_f\flags\flag_fd_red_co.paa";
};

////////////////////////////////////
//             UNITS             ///
////////////////////////////////////
//First Entry is Guerilla, Second Entry is Para/Military
staticCrewTeamPlayer = "TIOW_I_Ren_B_Crew";
SDKUnarmed = "I_G_Survivor_F";
SDKSniper = ["TIOW_I_Ren_B_Rifleman","TIOW_I_Ren_B_Plasma"];
SDKATman = ["TIOW_I_Ren_B_AT","TIOW_I_Ren_B_AT"];
SDKMedic = ["TIOW_I_Ren_B_Medic","TIOW_I_Ren_B_Mil_Medic"];
SDKMG = ["TIOW_I_Ren_B_LMG","TIOW_I_Ren_B_Mil_LMG"];
SDKExp = ["TIOW_I_Ren_B_Sapper","TIOW_I_Ren_B_Sapper"];
SDKGL = ["TIOW_I_Ren_B_Lead","TIOW_I_Ren_B_Lead"];
SDKMil = ["TIOW_I_Ren_B_Rifleman","TIOW_I_Ren_B_Mil_Rifle"];
SDKSL = ["TIOW_I_Ren_B_Officer","TIOW_I_Ren_B_Mil_Lead"];
SDKEng = ["TIOW_I_Ren_B_Engineer","TIOW_I_Ren_B_Engineer"];

////////////////////////////////////
//            GROUPS             ///
////////////////////////////////////
groupsSDKmid = [SDKSL,SDKGL,SDKMG,SDKMil];
groupsSDKAT = [SDKSL,SDKMG,SDKATman,SDKATman,SDKATman];
groupsSDKSquad = [SDKSL,SDKGL,SDKMil,SDKMG,SDKMil,SDKATman,SDKMil,SDKMedic];
groupsSDKSquadEng = [SDKSL,SDKGL,SDKMil,SDKMG,SDKExp,SDKATman,SDKEng,SDKMedic];
groupsSDKSquadSupp = [SDKSL,SDKGL,SDKMil,SDKMG,SDKATman,SDKMedic,[staticCrewTeamPlayer,staticCrewTeamPlayer],[staticCrewTeamPlayer,staticCrewTeamPlayer]];
groupsSDKSniper = [SDKSniper,SDKSniper];
groupsSDKSentry = [SDKGL,SDKMil];

//Rebel Unit Tiers (for costs)
sdkTier1 = SDKMil + [staticCrewTeamPlayer] + SDKMG + SDKGL + SDKATman;
sdkTier2 = SDKMedic + SDKExp + SDKEng;
sdkTier3 = SDKSL + SDKSniper;
soldiersSDK = sdkTier1 + sdkTier2 + sdkTier3;

////////////////////////////////////
//           VEHICLES            ///
////////////////////////////////////
//Military Vehicles
vehSDKBike = "I_G_Quadbike_01_F";
vehSDKLightArmed = "TIOW_RenegadeSTeG4_Cargo_Brown";
vehSDKAT = "TIOW_RenegadeSTeG4_Brown";
vehSDKLightUnarmed = "TIOW_Centaur_01_Renegade_B_Blu";
vehSDKTruck = "C_Truck_02_transport_F";
//vehSDKHeli = "C_Heli_Light_01_civil_F";
vehSDKPlane = "Valkyrie_Possessed_B_B";
vehSDKBoat = "I_G_Boat_Transport_01_F";
vehSDKRepair = "TIOW_RenegadeTrojan_Brown";

//Civilian Vehicles
civCar = "C_Offroad_01_F";
civTruck = "C_Truck_02_transport_F";
civHeli = "C_Heli_Light_01_civil_F";
civBoat = "C_Boat_Transport_02_F";

////////////////////////////////////
//        STATIC WEAPONS         ///
////////////////////////////////////
//Assembled Static Weapons
SDKMGStatic = "TIOW_IG_HeavyBolter_RenBrown_INDEP";
staticATteamPlayer = "TIOW_IG_MissileLauncher_AT_RenBrown_INDEP";
staticAAteamPlayer = "TIOW_IG_MissileLauncher_AA_RenBrown_INDEP";
SDKMortar = "TIOW_IG_Mortar_RenBrown_INDEP";
SDKMortarHEMag = "8Rnd_82mm_Mo_shells";
SDKMortarSmokeMag = "8Rnd_82mm_Mo_Smoke_white";

//Static Weapon Bags
MGStaticSDKB = "TIOW_IG_HeavyBolter_Bag1_INDEP";
ATStaticSDKB = "TIOW_IG_MissileLauncher_AT_Bag1_INDEP";
AAStaticSDKB = "TIOW_IG_MissileLauncher_AA_Bag1_INDEP";
MortStaticSDKB = "TIOW_IG_Mortar_Bag1_INDEP";
//Short Support
supportStaticSDKB = "Execption: TIOW_Reb_RENE_Arid supportStaticSDKB";
//Tall Support
supportStaticsSDKB2 = "Execption: TIOW_Reb_RENE_Arid supportStaticsSDKB2";
//Mortar Support
supportStaticsSDKB3 = "Execption: TIOW_Reb_RENE_Arid supportStaticsSDKB3";

////////////////////////////////////
//             ITEMS             ///
////////////////////////////////////
//Mines
ATMineMag = "TIOW_melta_bomb_placeable_Mag";
APERSMineMag = "TIOW_Tau_ExpSmall_Remote_Mag";

//Breaching explosives
//Breaching APCs needs one demo charge
breachingExplosivesAPC = [["TIOW_melta_bomb_placeable_Mag", 1], ["TIOW_Tau_ExpSmall_Remote_Mag", 1]]; 
//Breaching tanks needs one satchel charge or two demo charges
breachingExplosivesTank = [["TIOW_melta_bomb_placeable_Mag", 1], ["TIOW_Tau_ExpBig_Remote_Mag", 1]];

//Starting Unlocks
initialRebelEquipment append ["AgripinaaAutoChaos","Antioc43Lasgun","TIOW_Chaos_Shotgun","Lucius22c"];
initialRebelEquipment append ["MissileLauncherDKOKBlack"];
initialRebelEquipment append ["20Rnd_Agrip_mag","TIOW_Antioc43_Mag","TIOW_Shotgun_pellets_mag","Lucius22c_Pellet"];
initialRebelEquipment append ["TIOW_ig_smoke_grenade_mag","TIOW_chaos_frag_grenade_mag","TIOW_chaos_krak_grenade_mag"];
initialRebelEquipment append ["RPG7_F"];	// Death Korps Missle Launcher Accepts RPG.
initialRebelEquipment append ["Ren_Backpack_02_black_Ammo","Ren_Backpack_02_black","TIOW_Chaos_Vox_Caster","TIOW_Valhallan_Bandolier"];
initialRebelEquipment append ["Ren_ArmorSet_02_brown","TIOW_Cultist_Gear","TIOW_Cultist_Gear2","Ren_ArmorSet_01_brown"];
initialRebelEquipment append ["Binocular"];
//TAFR Unlocks
if (hasTFAR) then {initialRebelEquipment append ["tf_microdagr","tf_anprc154"]};
if (hasTFAR && startWithLongRangeRadio) then {initialRebelEquipment pushBack "tf_anprc155_coyote"};
