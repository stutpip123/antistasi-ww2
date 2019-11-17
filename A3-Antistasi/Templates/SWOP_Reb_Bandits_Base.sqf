////////////////////////////////////
//       NAMES AND FLAGS         ///
////////////////////////////////////
nameTeamPlayer = "Bandits";
SDKFlag = "Flag_FIA_F";
SDKFlagTexture = "\A3\Data_F\Flags\Flag_FIA_CO.paa";
typePetros = "SWOP_Mando_Protectors_of";

////////////////////////////////////
//             UNITS             ///
////////////////////////////////////
//First Entry is Guerilla, Second Entry is Para/Military
staticCrewTeamPlayer = "Swop_Band_week_a280";
SDKUnarmed = "B_G_Survivor_F";
SDKSniper = ["Swop_Band_week_sniper","rhsgref_hidf_marksman"];
SDKATman = ["Swop_Band_week_aa","SWOP_Mando_True_AT"];
SDKMedic = ["Swop_Band_week_med","SWOP_Mando_True_sold"];
SDKMG = ["Swop_Band_week_mg","SWOP_Mando_True_mg"];
SDKExp = ["Swop_Band_week_smug","SWOP_Mando_True_serg"];
SDKGL = ["Swop_Band_week_serg","SWOP_Mando_True_jumper"];
SDKMil = ["Swop_Band_week_a280","SWOP_Mando_True_sold"];
SDKSL = ["Swop_Band_week_com","SWOP_Mando_True_of"];
SDKEng = ["Swop_Band_week_smug","SWOP_Mando_True_serg"];

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
vehSDKBike = "SW_SpeederBike";
vehSDKLightArmed = "Swop_scavengerspeeder";
vehSDKAT = "O_Swop_skif_1";
vehSDKLightUnarmed = "Swop_scavengerspeeder";
vehSDKTruck = "I_G_Van_01_transport_F";
//vehSDKHeli = "I_C_Heli_Light_01_civil_F";
vehSDKPlane = "Swop_awchl";
vehSDKBoat = "I_G_Boat_Transport_01_F";
vehSDKRepair = "I_G_Offroad_01_repair_F";

//Civilian Vehicles
civCar = "C_Offroad_01_F";
civTruck = "C_Van_01_transport_F";
civHeli = "C_Heli_Light_01_civil_F";
civBoat = "C_Boat_Transport_02_F";

////////////////////////////////////
//        STATIC WEAPONS         ///
////////////////////////////////////
//Assembled Static Weapons
SDKMGStatic = "PORTABLEGUN_Rep";
staticATteamPlayer = "HighTur";
staticAAteamPlayer = "Hoth_Dishturret";
SDKMortar = "I_G_Mortar_01_F";
SDKMortarHEMag = "8Rnd_82mm_Mo_shells";
SDKMortarSmokeMag = "8Rnd_82mm_Mo_Smoke_white";

//Static Weapon Bags
MGStaticSDKB = "I_HMG_01_high_weapon_F";
ATStaticSDKB = "I_AT_01_weapon_F";
AAStaticSDKB = "I_AA_01_weapon_F";
MortStaticSDKB = "I_Mortar_01_weapon_F";
//Short Support
supportStaticSDKB = "I_HMG_01_support_F";
//Tall Support
supportStaticsSDKB2 = "I_HMG_01_support_high_F";
//Mortar Support
supportStaticsSDKB3 = "I_Mortar_01_support_F";

////////////////////////////////////
//             ITEMS             ///
////////////////////////////////////
//Mines
ATMineMag = "ATMine_Range_Mag";
APERSMineMag = "APERSMine_Range_Mag";
//Starting Unlocks
initialRebelEquipment append ["swop_dl18Pistol","swop_dl44Pistol","SWOP_TuskenRBlasterRifle","SW_scattergun"];
initialRebelEquipment append ["SW_scattergun","SWOP_TuskenRBlasterRifle"];
initialRebelEquipment append ["swop_dl18Pistol_Mag","swop_dl44Pistol_Mag","SW_scattergun_Mag","5Rnd_127x108_Mag","Swop_TermDet_G","Swop_SmokeShell"];
initialRebelEquipment append ["Swop_TermDet_G","Swop_SmokeShell"];
initialRebelEquipment append ["SWOP_B_BlackBackPack_RTdv_Base"];
initialRebelEquipment append ["SWOP_RemBron","SWOP_RemBron2","SWOP_RemBronf","SWOP_RebSumkBron","SWOP_RebSumkBronFull"];
initialRebelEquipment append ["ElectroBinocularsB_F","acc_flashlight"];
//TFAR Unlocks
if (hasTFAR) then {initialRebelEquipment append ["tf_microdagr","tf_rf7800str"]};
if (startLR) then {initialRebelEquipment pushBack "tf_rt1523g_rhs"};
