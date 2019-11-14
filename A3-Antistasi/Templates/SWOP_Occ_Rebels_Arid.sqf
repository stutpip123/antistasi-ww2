////////////////////////////////////
//       NAMES AND FLAGS         ///
////////////////////////////////////
//Name Used for notifications
nameOccupants = "Rebel Alliance";

//Police Faction
factionGEN = "REBELLION";
//SF Faction
factionMaleOccupants = "REBELLION";
//Miltia Faction
if ((gameMode != 4) and (!hasFFAA)) then {factionFIA = ""};

//Flag Images
NATOFlag = "Flag_NATO_F";
NATOFlagTexture = "\A3\Data_F\Flags\Flag_NATO_CO.paa";
flagNATOmrk = "flag_NATO";
if (isServer) then {"NATO_carrier" setMarkerText "Rebel Alliance Flagship"};

//Loot Crate
NATOAmmobox = "B_supplyCrate_F";

////////////////////////////////////
//   PVP LOADOUTS AND VEHICLES   ///
////////////////////////////////////
//PvP Loadouts
NATOPlayerLoadouts = [
	//Team Leader
	["vanilla_blufor_teamLeader"] call A3A_fnc_getLoadout,
	//Medic
	["vanilla_blufor_medic"] call A3A_fnc_getLoadout,
	//Autorifleman
	["vanilla_blufor_machineGunner"] call A3A_fnc_getLoadout,
	//Marksman
	["vanilla_blufor_marksman"] call A3A_fnc_getLoadout,
	//Anti-tank Scout
	["vanilla_blufor_AT"] call A3A_fnc_getLoadout,
	//AT2
	["vanilla_blufor_rifleman"] call A3A_fnc_getLoadout
];

//PVP Player Vehicles
vehNATOPVP = ["O_Swop_landspeeder_1","SW_SpeederBikeR"];

////////////////////////////////////
//             UNITS             ///
////////////////////////////////////
//Military Units
NATOGrunt = "Swop_rebel_desert_a280";
NATOOfficer = "Swop_rebel_desert_serg";
NATOOfficer2 = "Swop_rebel_desert_com";
NATOBodyG = "Swop_Chewbacca";
NATOCrew = "Swop_rebel_navy_pil_b";
NATOUnarmed = "B_G_Survivor_F";
NATOMarksman = "Swop_rebel_desert_jumper";
staticCrewOccupants = "Swop_rebel_desert_a280";
NATOPilot = "Swop_rebel_navy_pil";

//Militia Units
if ((gameMode != 4) and (!hasFFAA)) then
	{
	FIARifleman = "Swop_rebel_desert_a280";
	FIAMarksman = "Swop_rebel_desert_jumper";
	};

//Police Units
policeOfficer = "Swop_rebel_navy_of";
policeGrunt = "Swop_rebel_navy_a280";

////////////////////////////////////
//            GROUPS             ///
////////////////////////////////////
//Military Groups
//Teams
groupsNATOSentry = ["Swop_rebel_desert_dh17",NATOGrunt];
groupsNATOSniper = ["Swop_rebel_desert_sniper","Swop_rebel_desert_e11"];
groupsNATOsmall = [groupsNATOSentry,groupsNATOSniper,["Swop_rebel_desert_jumper","Swop_rebel_desert_e11"]];
//Fireteams
groupsNATOAA = ["Swop_rebel_desert_serg","Swop_rebel_desert_aa","Swop_rebel_desert_aa","Swop_rebel_desert_a280"];
groupsNATOAT = ["Swop_rebel_desert_serg","Swop_rebel_desert_aa","Swop_rebel_desert_aa","Swop_rebel_desert_a280"];
groupsNATOmid = [["Swop_rebel_desert_serg","Swop_rebel_desert_assault","Swop_rebel_desert_dh17","Swop_rebel_desert_aa"],groupsNATOAA,groupsNATOAT];
//Squads
NATOSquad = ["Swop_rebel_desert_com",NATOGrunt,"Swop_rebel_desert_aa",NATOMarksman,"Swop_rebel_desert_serg","Swop_rebel_desert_assault","Swop_rebel_desert_dh17","Swop_rebel_desert_med"];
NATOSpecOp = ["Swop_rebel_magma_com","Swop_rebel_magma_jumper",NATOBodyG,"Swop_rebel_magma_aa","Swop_rebel_magma_dh17","Swop_rebel_magma_demolisher","Swop_rebel_magma_assault","Swop_rebel_magma_med"];
groupsNATOSquad =
	[
	NATOSquad,
	["Swop_rebel_desert_com",NATOGrunt,"Swop_rebel_desert_serg","Swop_rebel_desert_assault","Swop_rebel_desert_dh17","Swop_rebel_desert_e11","Swop_rebel_desert_a280","Swop_rebel_desert_med"],
	["Swop_rebel_desert_com",NATOGrunt,"Swop_rebel_desert_serg","Swop_rebel_desert_assault","Swop_rebel_desert_dh17","Swop_rebel_desert_e11","Swop_rebel_desert_a280","Swop_rebel_desert_med"],
	["Swop_rebel_desert_com",NATOGrunt,"Swop_rebel_desert_serg","Swop_rebel_desert_assault","Swop_rebel_desert_dh17","Swop_rebel_desert_aa","Swop_rebel_desert_e11","Swop_rebel_desert_med"],
	["Swop_rebel_desert_com",NATOGrunt,"Swop_rebel_desert_serg","Swop_rebel_desert_assault","Swop_rebel_desert_dh17","Swop_rebel_desert_aa","Swop_rebel_desert_e11","Swop_rebel_desert_med"],
	["Swop_rebel_desert_com",NATOGrunt,"Swop_rebel_desert_serg","Swop_rebel_desert_assault","Swop_rebel_desert_dh17","Swop_rebel_desert_demolisher","Swop_rebel_desert_demolisher","Swop_rebel_desert_med"]
	];

//Militia Groups
if ((gameMode != 4) and (!hasFFAA)) then
	{
	//Teams
	groupsFIASmall =
		[
		["Swop_rebel_desert_dh17",FIARifleman],
		[FIAMarksman,FIARifleman],
		["Swop_rebel_desert_jumper","Swop_rebel_desert_a280"]
		];
	//Fireteams
	groupsFIAMid =
		[
		["Swop_rebel_desert_serg","Swop_rebel_desert_dh17","Swop_rebel_desert_assault","Swop_rebel_desert_Jumper"],
		["Swop_rebel_desert_serg","Swop_rebel_desert_dh17","Swop_rebel_desert_assault","Swop_rebel_desert_aa"],
		["Swop_rebel_desert_serg","Swop_rebel_desert_assault","Swop_rebel_desert_a280","Swop_rebel_desert_aa"]
		];
	//Squads
	FIASquad = ["Swop_rebel_desert_serg","Swop_rebel_desert_assault","Swop_rebel_desert_dh17","Swop_rebel_desert_dh17","Swop_rebel_desert_dh17","Swop_rebel_desert_jumper","Swop_rebel_desert_aa","Swop_rebel_desert_med"];
	groupsFIASquad =
		[
		FIASquad,
		["Swop_rebel_desert_serg","Swop_rebel_desert_e11","Swop_rebel_desert_dh17","Swop_rebel_desert_dh17","Swop_rebel_desert_mg","Swop_rebel_desert_jumper","Swop_rebel_desert_aa","Swop_rebel_desert_med"]
		];
	};

//Police Groups
//Teams
groupsNATOGen = [policeOfficer,policeGrunt];

////////////////////////////////////
//           VEHICLES            ///
////////////////////////////////////
//Military Vehicles
//Lite
vehNATOBike = "SW_SpeederBikeR";
vehNATOLightArmed = ["SW_SpeederBikeR"];
vehNATOLightUnarmed = ["O_Swop_landspeeder_1"];
vehNATOTrucks = ["B_Truck_01_transport_F","B_Truck_01_covered_F"];
vehNATOCargoTrucks = ["B_Truck_01_cargo_F", "B_Truck_01_flatbed_F"];
vehNATOAmmoTruck = "B_Truck_01_ammo_F";
vehNATORepairTruck = "B_Truck_01_repair_F";
vehNATOLight = vehNATOLightArmed + vehNATOLightUnarmed;
//Armored
vehNATOAPC = ["O_SWOP_HoverT_2","O_SWOP_HoverTf_2"];
vehNATOTank = "O_SWOP_HoverTa_2";
vehNATOAA = "O_SWOP_HoverTa_2";
vehNATOAttack = vehNATOAPC + [vehNATOTank];
//Boats
vehNATOBoat = "B_Boat_Armed_01_minigun_F";
vehNATORBoat = "B_Boat_Transport_01_F";
vehNATOBoats = [vehNATOBoat,vehNATORBoat,"O_SWOP_HoverT_2"];
//Planes
vehNATOPlane = "swop_ywGreen";
vehNATOPlaneAA = "swop_xw";
vehNATOTransportPlanes = ["swop_mf"];
//Heli
vehNATOPatrolHeli = "Swop_Uwing";
vehNATOTransportHelis = ["Swop_Uwing",vehNATOPatrolHeli,"Swop_Uwing"];
vehNATOAttackHelis = ["swop_mf","Swop_Uwing","Swop_Uwing"];
//UAV
vehNATOUAV = "B_UAV_02_F";
vehNATOUAVSmall = "B_UAV_01_F";
//Artillery
vehNATOMRLS = "O_SWOP_HoverTr_2";
vehNATOMRLSMags = "32Rnd_155mm_Mo_shells";
//Combined Arrays
vehNATONormal = vehNATOLight + vehNATOTrucks + [vehNATOAmmoTruck, "B_Truck_01_fuel_F", "B_Truck_01_medical_F", vehNATORepairTruck,"O_SWOP_HoverT_2"];
vehNATOAir = vehNATOTransportHelis + vehNATOAttackHelis + [vehNATOPlane,vehNATOPlaneAA] + vehNATOTransportPlanes;

//Militia Vehicles
if ((gameMode != 4) and (!hasFFAA)) then
	{
	vehFIAArmedCar = "O_Swop_landspeeder_1";
	vehFIATruck = "B_Truck_01_transport_F";
	vehFIACar = "SW_SpeederBikeR";
	};

//Police Vehicles
vehPoliceCar = "O_Swop_landspeeder_1";

////////////////////////////////////
//        STATIC WEAPONS         ///
////////////////////////////////////
//Assembled Statics
NATOMG = "PORTABLEGUN_Rep";
staticATOccupants = "HighTur";
staticAAOccupants = "Hoth_Dishturret";
NATOMortar = "B_Mortar_01_F";

//Static Weapon Bags
MGStaticNATOB = "B_HMG_01_high_weapon_F";
ATStaticNATOB = "B_AT_01_weapon_F";
AAStaticNATOB = "B_AA_01_weapon_F";
MortStaticNATOB = "B_Mortar_01_weapon_F";
//Short Support
supportStaticNATOB = "O_HMG_01_support_F";
//Tall Support
supportStaticNATOB2 = "O_HMG_01_support_high_F";
//Mortar Support
supportStaticNATOB3 = "B_Mortar_01_support_F";
