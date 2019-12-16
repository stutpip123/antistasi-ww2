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
CSATFlag = "Flag_Syndikat_F";
CSATFlagTexture = "\a3\data_f_exp\flags\flag_synd_co.paa";
flagCSATmrk = "flag_Syndikat";
if (isServer) then {"CSAT_carrier" setMarkerText "Ork Battleship Slamblasta"};
	
//Loot Crate
CSATAmmoBox = "CargoNet_01_box_F";

////////////////////////////////////
//   PVP LOADOUTS AND VEHICLES   ///
////////////////////////////////////
//PvP Loadouts
NATOPlayerLoadouts = [
	//Team Leader
	["TIOW_Ork_teamLeader"] call A3A_fnc_getLoadout,
	//Medic
	["TIOW_Ork_medic"] call A3A_fnc_getLoadout,
	//Autorifleman
	["TIOW_Ork_machineGunner"] call A3A_fnc_getLoadout,
	//Marksman
	["TIOW_Ork_marksman"] call A3A_fnc_getLoadout,
	//Anti-tank Scout
	["TIOW_Ork_AT"] call A3A_fnc_getLoadout,
	//AT2
	["TIOW_Ork_rifleman"] call A3A_fnc_getLoadout
];

//PVP Player Vehicles
vehCSATPVP = ["Trukk1_OP"];

////////////////////////////////////
//             UNITS             ///
////////////////////////////////////
//Military Units
CSATGrunt = "Naked1_OP";
CSATOfficer = "Boss1_OP";
CSATBodyG = "ArdBoy1_OP";
CSATCrew = "Naked1_OP";
CSATMarksman = "ShootaBoy1_OP";
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
groupsCSATAT = ["Boss1_OP","TankBusta1_OP","TankBusta1_OP","TankBusta1_OP"];
groupsCSATmid = [[CSATOfficer,CSATBodyG,CSATBodyG,CSATBodyG],groupsCSATAA,groupsCSATAT];
//Squads
CSATSquad = [CSATOfficer,CSATBodyG,CSATBodyG,CSATBodyG,groupsCSATAA,groupsCSATAT];
CSATSpecOp = ["Boss2_OP","ArdBoy2_OP","ArdBoy2_OP","ArdBoy2_OP","ShootaBoy2_OP","ShootaBoy2_OP","TankBusta2_OP","TankBusta2_OP"];
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
//Lite
vehCSATBike = "Trukk1_OP";
vehCSATLightArmed = ["Trukk1_OP"];
vehCSATLightUnarmed = ["Trukk1_OP"];
vehCSATTrucks = ["Trukk1_OP"];
vehCSATAmmoTruck = "Trukk1_OP";
vehCSATLight = vehCSATLightArmed + vehCSATLightUnarmed;
//Armored
vehCSATAPC = ["Trukk1_OP"];
vehCSATTank = "TIOW_Stompa_01_es_OP";
vehCSATAA = "TIOW_FlakkaDakka_Turret_OP";
vehCSATAttack = vehCSATAPC + ["Deffkopta_02_0"];
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
vehCSATTransportHelis = ["MDK_0"];
vehCSATAttackHelis = ["MDK_0","Deffkopta_01_0","Deffkopta_01_0","Deffkopta_02_0","Deffkopta_02_0"];
//UAV
vehCSATUAV = "O_T_UAV_04_CAS_F";
vehCSATUAVSmall = "O_UGV_01_rcws_F";
//Artillery
vehCSATMRLS = "O_MBT_02_arty_F";
vehCSATMRLSMags = "32Rnd_155mm_Mo_shells";
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
//Short Support
supportStaticNATOB = "Execption: TIOW_Occ_IOM_Arid supportStaticNATOB";
//Tall Support
supportStaticNATOB2 = "Execption: TIOW_Occ_IOM_Arid supportStaticNATOB2";
//Mortar Support
supportStaticNATOB3 = "Execption: TIOW_Occ_IOM_Arid supportStaticNATOB3";
