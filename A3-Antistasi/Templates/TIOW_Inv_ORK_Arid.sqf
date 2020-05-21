////////////////////////////////////
//       NAMES AND FLAGS         ///
////////////////////////////////////
//Name Used for notifications
nameInvaders = "Orkz";

//SF Faction
factionMaleInvaders = "Orks_OP";
//Miltia Faction
if (gameMode == 4) then {factionFIA = "Orks_OP"};

//Flag Images
CSATFlag = "Flag_Syndikat_F"; // "776th_flag" not having texture replaced
CSATFlagTexture = "a3\data_f_exp\flags\flag_synd_co.paa";
flagCSATmrk = "flag_Syndikat";
if (isServer) then {
	"CSAT_carrier" setMarkerText "Ork Battleship Slamblasta";
	"CSAT_carrier" setMarkerType "flag_Spetsnaz";
	createVehicle ["TIOW_Oberon" ,((getMarkerPos "CSAT_carrier") vectorAdd [0,0,500]),[], 0, "FLY"];
};

//Loot Crate
CSATAmmoBox = "Box_FIA_Support_F";  //CargoNet_01_box_F

////////////////////////////////////
//   PVP LOADOUTS AND VEHICLES   ///
////////////////////////////////////
//PvP Loadouts
NATOPlayerLoadouts = [
	//Team Leader
	"Boss2_OP",				//["TIOW_Ork_teamLeader"] call A3A_fnc_getLoadout,
	//Medic
	"ArdBoy2_OP",			//["TIOW_Ork_medic"] call A3A_fnc_getLoadout,
	//Autorifleman
	"ShootaBoy2_OP",		//["TIOW_Ork_machineGunner"] call A3A_fnc_getLoadout,
	//Marksman
	"StormBoy1_OP",			//["TIOW_Ork_marksman"] call A3A_fnc_getLoadout,
	//Anti-tank Scout
	"TankBusta2_OP",		//["TIOW_Ork_AT"] call A3A_fnc_getLoadout,
	//AT2
	"TankBusta2_OP"			//["TIOW_Ork_rifleman"] call A3A_fnc_getLoadout
];

//PVP Player Vehicles
vehCSATPVP = ["Trukk1_OP","I_C_Offroad_02_unarmed_brown_F","I_C_Offroad_02_LMG_F","I_C_Offroad_02_AT_F"];

////////////////////////////////////
//             UNITS             ///
////////////////////////////////////
//Military Units
CSATGrunt = "Naked1_OP";
CSATOfficer = "Boss1_OP";
CSATBodyG = "ArdBoy1_OP";
CSATCrew = "Naked1_OP";
CSATMarksman = "StormBoy1_OP";
staticCrewInvaders = "Naked1_OP";
CSATPilot = "Naked1_OP";

//Militia Units
if (gameMode == 4) then
	{
	FIARifleman = "Naked1_OP";
	FIAMarksman = "ShootaBoy1_OP";
	};

////////////////////////////////////
//            GROUPS             ///
////////////////////////////////////
//Military Groups
//Teams
groupsCSATSentry = [CSATGrunt,CSATGrunt];
groupsCSATSniper = [CSATMarksman,CSATMarksman];
groupsCSATsmall = [groupsCSATSentry,[CSATBodyG,CSATBodyG],groupsCSATSniper];
//Fireteams
groupsCSATAA = ["Boss1_OP","ShootaBoy1_OP","ShootaBoy1_OP","TankBusta1_OP"];
groupsCSATAT = ["Boss1_OP","Naked1_OP","TankBusta1_OP","TankBusta1_OP"];
groupsCSATmid = [[CSATOfficer,CSATBodyG,CSATBodyG,CSATBodyG],groupsCSATAA,groupsCSATAT];
//Squads
CSATSquad = [CSATOfficer,CSATBodyG,CSATBodyG,CSATBodyG,groupsCSATAA,groupsCSATAT];
CSATSpecOp = ["Boss2_OP","ArdBoy2_OP","ArdBoy2_OP","ArdBoy2_OP","ShootaBoy2_OP","ShootaBoy2_OP","StormBoy1_OP","TankBusta2_OP"];
groupsCSATSquad =
	[
	CSATSquad,
	groupsCSATAA + groupsCSATAA,
	groupsCSATAT + groupsCSATAT
	];

//Militia Groups
if (gameMode == 4) then
	{
	//Teams
	groupsFIASmall =
		[
		["TankBusta1_OP","Naked1_OP"],
		["ShootaBoy1_OP","ArdBoy1_OP"]
		];
	//Fireteams
	groupsFIAMid =
		[
		["Boss1_OP","Naked1_OP","ShootaBoy1_OP","TankBusta1_OP"],
		["Boss1_OP","Naked1_OP","ShootaBoy1_OP","ShootaBoy1_OP"]
		];
	//Squads
	FIASquad = ["Boss1_OP","Naked1_OP","Naked1_OP","ArdBoy1_OP","ArdBoy1_OP","ShootaBoy1_OP","ShootaBoy1_OP","TankBusta1_OP"];
	groupsFIASquad = 
	[
		FIASquad,
		["Boss2_OP","ArdBoy2_OP","ArdBoy2_OP","ArdBoy2_OP","ShootaBoy2_OP","ShootaBoy2_OP","TankBusta2_OP","TankBusta2_OP"]
	];
	};

////////////////////////////////////
//           VEHICLES            ///
////////////////////////////////////
//Military Vehicles
//Light
vehCSATBike = "Trukk1_OP";
vehCSATLightArmed = ["Trukk1_OP"];
vehCSATLightUnarmed = ["Trukk1_OP"];
vehCSATTrucks = ["Trukk1_OP"];
vehCSATAmmoTruck = "TIOW_RenegadeTrojan_Grey_OP";
vehCSATRepairTruck = "TIOW_RenegadeTrojan_Grey_OP";
vehCSATLight = vehCSATLightArmed + vehCSATLightUnarmed;
//Armored
vehCSATAPC = ["Trukk1_OP","_RenegadeChimAuto_Grey_OP"];
vehCSATTank = "TIOW_RenegadeSTeG4_Grey_OP";
vehCSATAA = "TIOW_RenegadeHydra_Grey";
vehCSATAttack = vehCSATAPC + vehCSATTank + ["Deffkopta_01_0"];
//Boats
vehCSATBoat = "O_T_Boat_Armed_01_hmg_F";
vehCSATRBoat = "O_T_Boat_Transport_01_F";
vehCSATBoats = [vehCSATBoat,vehCSATRBoat];
//Planes
vehCSATPlane = "Valkyrie_Looted_0";
vehCSATPlaneAA = "Valkyrie_Looted_0";
vehCSATTransportPlanes = ["Valkyrie_Looted_0"];
//Heli
vehCSATPatrolHeli = "Deffkopta_02_0";
vehCSATTransportHelis = ["Valkyrie_Looted_0"]; //["MDK_0"]; // Mega Deff Kopter is currently bugged as fuck, Temp replaced by Looted Valkyrie.
vehCSATAttackHelis = [/*"MDK_0",*/"Deffkopta_01_0","Deffkopta_01_0","Deffkopta_02_0","Deffkopta_02_0"];
//UAV
vehCSATUAV = "O_T_UAV_04_CAS_F";
vehCSATUAVSmall = "O_UGV_01_rcws_F";
//Artillery
vehCSATMRLS = "TIOW_RenegadeWyvern_Grey";
vehCSATMRLSMags = "TIOW_StormShard_Mag";
//Combined Arrays
vehCSATNormal = vehCSATLight + vehCSATTrucks + [vehCSATAmmoTruck];
vehCSATAir = vehCSATTransportHelis + vehCSATAttackHelis + [vehCSATPlane,vehCSATPlaneAA] + vehCSATTransportPlanes;

//Militia Vehicles
if (gameMode == 4) then
{
	vehFIAArmedCar = "Trukk1_OP";
	vehFIATruck = "Trukk1_OP";
	vehFIACar = "Trukk1_OP";
};

////////////////////////////////////
//        STATIC WEAPONS         ///
////////////////////////////////////
//Assembled Statics
CSATMG = "TIOW_Zzzappturret_OP";
staticATInvaders = "TIOW_Supaturret_OP";
staticAAInvaders = "TIOW_FlakkaDakka_Turret_OP";
CSATMortar = "TIOW_IG_Mortar_700_OP";

//Static Weapon Bags
MGStaticNATOB = "TIOW_IG_HeavyBolter_Bag1_Blu";
ATStaticNATOB = "TIOW_IG_Lascannon_Bag1_Blu";
AAStaticNATOB = "TIOW_IG_MissileLauncher_AA_Bag1_Blu";
MortStaticNATOB = "TIOW_IG_Mortar_Bag1_Blu";
//Short Support			// ORKZ CAN"T DISSEMBLE THEIR STATICS, GORK AND MORK KEEP THEIR SHIT TOGETHER.
supportStaticNATOB = "TIOW_IG_HeavyBolter_Bag2_Blu";	// ONLY FOR MG
//Tall Support
supportStaticNATOB2 = "TIOW_IG_Lascannon_Bag2_Blu";		// NOT COMPATIBLE WITH AA OR MG
//Mortar Support
supportStaticNATOB3 = "TIOW_IG_Mortar_Bag2_Blu";
