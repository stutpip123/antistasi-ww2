////////////////////////////////////
//       NAMES AND FLAGS         ///
////////////////////////////////////
nameTeamPlayer = "Bandits";
SDKFlag = "Flag_FIA_F";
SDKFlagTexture = "\A3\Data_F\Flags\Flag_FIA_CO.paa";
typePetros = "SWOP_Mando_True_Bobba";

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
vehSDKTruck = "rhsgref_cdf_b_ural_open";
//vehSDKHeli = "I_C_Heli_Light_01_civil_F";
vehSDKPlane = "Swop_awchl";
vehSDKBoat = "B_G_Boat_Transport_01_F";
vehSDKRepair = "rhsgref_cdf_b_ural_repair";

//Civilian Vehicles
civCar = "C_Offroad_01_F";
civTruck = "RHS_Ural_Open_Civ_03";
civHeli = "RHS_Mi8amt_civilian";
civBoat = "C_Boat_Transport_02_F";

////////////////////////////////////
//        STATIC WEAPONS         ///
////////////////////////////////////
//Assembled Static Weapons
SDKMGStatic = "PORTABLEGUN_Rep";
staticATteamPlayer = "HighTur";
staticAAteamPlayer = "Hoth_Dishturret";
SDKMortar = "rhsgref_cdf_b_reg_M252";
SDKMortarHEMag = "rhs_12Rnd_m821_HE";
SDKMortarSmokeMag = "rhs_12Rnd_m821_HE";

//Static Weapon Bags
MGStaticSDKB = "RHS_DShkM_Gun_Bag";
ATStaticSDKB = "RHS_SPG9_Gun_Bag";
AAStaticSDKB = "no_exists";
MortStaticSDKB = "rhs_M252_Gun_Bag";
//Short Support
supportStaticSDKB = "RHS_SPG9_Tripod_Bag";
//Tall Support
supportStaticsSDKB2 = "RHS_DShkM_TripodHigh_Bag";
//Mortar Support
supportStaticsSDKB3 = "rhs_M252_Bipod_Bag";

////////////////////////////////////
//             ITEMS             ///
////////////////////////////////////
//Mines
ATMineMag = "rhs_mine_M19_mag";
APERSMineMag = "rhsusf_mine_m7a2_mag";
//Starting Unlocks
initialRebelEquipment append ["swop_dl18Pistol","swop_dl44Pistol","relbyv10","SW_scattergun"];
initialRebelEquipment append ["SMG_01_F","SMG_02_F"];
initialRebelEquipment append ["swop_dl18Pistol_Mag","swop_dl44Pistol_Mag","SW_scattergun_Mag","relbyv10_Mag","Swop_TermDet_G","Swop_SmokeShell"];
initialRebelEquipment append ["SWOP_B_ITdv_Base","SWOP_B_BlackBackPack_RTdv_Base"];
initialRebelEquipment append ["SWOP_RemBron","SWOP_RemBron2","SWOP_RemBronf","SWOP_RebSumkBron","SWOP_RebSumkBronFull"];
initialRebelEquipment append ["ElectroBinocularsB_F","acc_flashlight"];
//TFAR Unlocks
if (hasTFAR) then {initialRebelEquipment append ["tf_microdagr","tf_rf7800str"]};
if (startLR) then {initialRebelEquipment pushBack "tf_rt1523g_rhs"};
