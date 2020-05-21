////////////////////////////////////
//       NAMES AND FLAGS         ///
////////////////////////////////////
//Name Used for notifications
nameOccupants = "Imperium";

//Police Faction
factionGEN = "TIOW_Mordian_Blu";
//SF Faction
factionMaleOccupants = "DKoK_1491st";
//Miltia Faction
if ((gameMode != 4) and (!hasFFAA)) then {factionFIA = "TIOW_Val_Blu"};

//Flag Images
NATOFlag = "Flag_NATO_F"; // 700th_flag
NATOFlagTexture = "whobjects3\super_assets\military\tiow_flagpole\data\700th_cadian_flag_ca.paa";	// \A3\Data_F\Flags\Flag_NATO_CO.paa
flagNATOmrk = "flag_UK"; //flag_NATO
if (isServer) then {
	"NATO_carrier" setMarkerText "Oberon Class Battleship";
	"NATO_carrier" setMarkerType "flag_UK";
	createVehicle ["TIOW_Oberon" ,((getMarkerPos "NATO_carrier") vectorAdd [0,0,500]),[], 0, "FLY"];
};

//Loot Crate
NATOAmmobox = "TIOW_IG_WeaponBox1_700";

////////////////////////////////////
//   PVP LOADOUTS AND VEHICLES   ///
////////////////////////////////////
//PvP Loadouts
NATOPlayerLoadouts = [
	//Team Leader
	"TIOW_Cad_Kasr700th",			//["TIOW_IOM_teamLeader"] call A3A_fnc_getLoadout,
	//Medic
	"TIOW_Cad_Med700th",			//["TIOW_IOM_medic"] call A3A_fnc_getLoadout,
	//Autorifleman
	"TIOW_Cad_Kasr700th",			//["TIOW_IOM_machineGunner"] call A3A_fnc_getLoadout,
	//Marksman
	"TIOW_Cad_Kasr700th",			//["TIOW_IOM_marksman"] call A3A_fnc_getLoadout,
	//Anti-tank Scout
	"TIOW_Cad_Kasr700th",			//["TIOW_IOM_AT"] call A3A_fnc_getLoadout,
	//AT2
	"TIOW_Cad_Kasr700th"			//["TIOW_IOM_rifleman"] call A3A_fnc_getLoadout
];

//PVP Player Vehicles
vehNATOPVP = ["TIOW_Centaur_01_Cadian_700_Blu","I_C_Offroad_02_unarmed_brown_F","I_C_Offroad_02_LMG_F","I_C_Offroad_02_AT_F"];

////////////////////////////////////
//             UNITS             ///
////////////////////////////////////
//Military Units
NATOGrunt = "TIOW_Cad_GM700th";
NATOOfficer = "TIOW_Comissar_Red";
NATOOfficer2 = "TIOW_Priest1";
NATOBodyG = "TIOW_Cad_GM_Flamer_700th";
NATOCrew = "TIOW_Cad_Tnk700th";
NATOUnarmed = "B_Survivor_F";
NATOMarksman = "TIOW_Cad_VET700th";
staticCrewOccupants = "TIOW_Cad_GM700th";
NATOPilot = "TIOW_Cad_Tnk700th";
//Caleb's Additional Unit Variables
NATOMedic = "TIOW_Cad_Med700th";
NATOSpec = "TIOW_Cad_Kasr700th";

//Militia Units
if (gameMode != 4) then
{
	FIARifleman = "DKoK_Off_1491st";
	FIAMarksman = "DKoK_Gren_1491st";
};

//Police Units
policeOfficer = "TIOW_Mordian_NCO_1_Blu";
policeGrunt = "TIOW_Mordian_Trooper_1_Blu";

////////////////////////////////////
//            GROUPS             ///
////////////////////////////////////
//Military Groups
//Teams
groupsNATOSentry = [NATOBodyG,NATOGrunt];
groupsNATOSniper = ["DKoK_Gren_1491st","DKoK_Off_1491st"];
groupsNATOsmall = [groupsNATOSentry,groupsNATOSniper];
//Fireteams
groupsNATOAA = ["DKoK_Off_1491st","DKoK_GM_WM_1491st","DKoK_GM_1491st_HStubber","DKoK_GM_1491st_HStubber"];
groupsNATOAT = ["DKoK_QM_1491st","DKoK_GM_1491st","DKoK_Gren_1491st_AT","DKoK_Gren_1491st_AT"];
groupsNATOmid = [["DKoK_Off_1491st","DKoK_GM_1491st_HStubber","DKoK_GM_1491st","DKoK_GM_1491st"],groupsNATOAA,groupsNATOAT];
//Squads
NATOSquad = [NATOOfficer2,NATOOfficer,NATOBodyG,NATOBodyG,NATOGrunt,NATOGrunt,NATOMarksman,NATOMedic];
NATOSpecOp = [NATOSpec,NATOSpec,NATOSpec,NATOSpec,NATOSpec,NATOSpec,NATOSpec,NATOSpec];
groupsNATOSquad =
	[
	NATOSquad,
	NATOSquad,
	["DKoK_Off_1491st","DKoK_GM_1491st_HStubber","DKoK_GM_1491st","DKoK_GM_1491st","DKoK_GM_1491st","DKoK_GM_1491st","DKoK_GM_1491st_AT","TIOW_Priest"],
	["TIOW_Comissar_Krieg","DKoK_Off_1491st","DKoK_GM_1491st_HStubber","DKoK_GM_1491st_HStubber","DKoK_GM_WM_1491st","DKoK_GM_1491st","DKoK_Eng_1491st","TIOW_Priest3"]
	];

//Militia Groups
if (gameMode != 4) then
{
	//Teams
	groupsFIASmall =
		[
		["DKoK_Eng_1491st","DKoK_GM_1491st"],
		["DKoK_GM_WM_1491st","DKoK_GM_1491st"]
		];
	//Fireteams
	groupsFIAMid =
		[
		["DKoK_Off_1491st","DKoK_GM_1491st_HStubber","DKoK_GM_WM_1491st","DKoK_Eng_1491st"],
		["DKoK_Off_1491st","DKoK_GM_1491st","DKoK_GM_1491st","DKoK_Eng_1491st"]
		];
	//Squads
	FIASquad = ["DKoK_QM_1491st","DKoK_GM_1491st_HStubber","DKoK_GM_WM_1491st","DKoK_GM_1491st","DKoK_GM_1491st","DKoK_GM_1491st","DKoK_GM_1491st_AT","DKoK_Eng_1491st"];
	groupsFIASquad = [FIASquad];
};

//Police Groups
//Teams
groupsNATOGen = [policeOfficer,policeGrunt];

////////////////////////////////////
//           VEHICLES            ///
////////////////////////////////////
//Military Vehicles
//Light
vehNATOBike = "B_Quadbike_01_F";
vehNATOLightArmed = ["Sentinel_AC_1491th_1","Sentinel_CS_1491th_1","Sentinel_HB_1491th_1","Sentinel_LC_1491th_1","Sentinel_MLA_1491th_1","Sentinel_ML_1491th_1","Sentinel_PC_1491th_1"];
vehNATOLightUnarmed = ["TIOW_Centaur_01_Cadian_700_Blu"];
vehNATOTrucks = ["TIOW_Centaur_01_Cadian_700_Blu"];
vehNATOCargoTrucks = ["TIOW_Centaur_01_Cadian_700_Blu"];
vehNATOAmmoTruck = "TIOW_CadianTrojan_700";
vehNATORepairTruck = "TIOW_CadianTrojan_700";
vehNATOLight = vehNATOLightArmed + vehNATOLightUnarmed;
//Armored
vehNATOAPC = ["TIOW_CadianChimAuto_700","TIOW_Taurox_AC_700","TIOW_Taurox_HS_700"];
vehNATOTank = "TIOW_Cad_LR_Executioner_700th_Blu";
vehNATOAA = "TIOW_CadianHydra_700";
vehNATOAttack = vehNATOAPC + [vehNATOTank];
//Boats
vehNATOBoat = "B_Boat_Armed_01_minigun_F";
vehNATORBoat = "B_T_Boat_Transport_01_F";
vehNATOBoats = [vehNATOBoat,vehNATORBoat];
//Planes
vehNATOPlane = "TIOW_Thunderbolt_Base";
vehNATOPlaneAA = "TIOW_Thunderbolt_Base";
vehNATOTransportPlanes = ["TIOW_Valkyrie_Fuel_M_B"];
//Heli
vehNATOPatrolHeli = "TIOW_Valkyrie_Fuel_B";
vehNATOTransportHelis = ["TIOW_Valkyrie_Fuel_M_B","TIOW_Valkyrie_Fuel_B"];
vehNATOAttackHelis = ["TIOW_Valkyrie_Rocket_M_B"];
//UAV
vehNATOUAV = "B_UAV_05_F";
vehNATOUAVSmall = "B_UGV_02_Demining_F";
//Artillery
vehNATOMRLS = "TIOW_CadianWyvern_700";
vehCSATMRLSMags = "TIOW_StormShard_Mag";
//Combined Arrays
vehNATONormal = vehNATOLight + vehNATOTrucks + [vehNATOAmmoTruck, vehNATORepairTruck];
vehNATOAir = vehNATOTransportHelis + vehNATOAttackHelis + [vehNATOPlane,vehNATOPlaneAA] + vehNATOTransportPlanes;

//Militia Vehicles
if (gameMode != 4) then
{
	vehFIAArmedCar = "TIOW_Taurox_HS_700";
	vehFIATruck = "TIOW_Centaur_01_Cadian_700_Blu";
	vehFIACar = "C_Offroad_02_unarmed_green_F";	// Jeep Wrangler
};

//Police Vehicles
vehPoliceCar = "C_Offroad_02_unarmed_blue_F";	// Jeep Wrangler

////////////////////////////////////
//        STATIC WEAPONS         ///
////////////////////////////////////
//Assembled Statics
NATOMG = "TIOW_IG_HeavyBolter_700_Blu";
staticATOccupants = "TIOW_IG_Lascannon_700_Blu";
staticAAOccupants = "TIOW_IG_MissileLauncher_AT_700_Blu";
NATOMortar = "TIOW_IG_Mortar_700_Blu";

//Static Weapon Bags
MGStaticNATOB = "TIOW_IG_HeavyBolter_Bag1_Blu";
ATStaticNATOB = "TIOW_IG_Lascannon_Bag1_Blu";
AAStaticNATOB = "TIOW_IG_MissileLauncher_AA_Bag1_Blu";
MortStaticNATOB = "TIOW_IG_Mortar_Bag1_Blu";
//Short Support
supportStaticNATOB = "TIOW_IG_HeavyBolter_Bag2_Blu";	// ONLY FOR MG
//Tall Support
supportStaticNATOB2 = "TIOW_IG_Lascannon_Bag2_Blu";		// NOT COMPATIBLE WITH AA OR MG
//Mortar Support
supportStaticNATOB3 = "TIOW_IG_Mortar_Bag2_Blu";