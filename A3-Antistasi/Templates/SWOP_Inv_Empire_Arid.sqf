////////////////////////////////////
//       NAMES AND FLAGS         ///
////////////////////////////////////
//Name Used for notifications
nameInvaders = "Galactic Empire";

//SF Faction
factionMaleInvaders = "EMPIRE";
//Miltia Faction
if (gameMode == 4) then {factionFIA = ""};

//Flag Images
CSATFlag = "Flag_CSAT_F";
CSATFlagTexture = "\A3\Data_F\Flags\Flag_CSAT_CO.paa";
flagCSATmrk = "flag_CSAT";
if (isServer) then {"CSAT_carrier" setMarkerText "Star Destroyer"};

//Loot Crate
CSATAmmoBox = "impammobox2";

////////////////////////////////////
//   PVP LOADOUTS AND VEHICLES   ///
////////////////////////////////////
//PvP Loadouts
CSATPlayerLoadouts = [
	//Team Leader
	"SWOP_imp_DeathTrooperLeader",
	//Medic
	"SWOP_imp_DeathTrooper",
	//Autorifleman
	"SWOP_imp_DeathTrooperHB",
	//Marksman
	"SWOP_Scout_sniper",
	//Anti-tank Scout
	"SWOP_Storm_Shoretrooper_AA",
	//AT2
	"SWOP_Storm_Shoretrooper_AA"
];

//PVP Player Vehicles
vehCSATPVP = ["SWOP_LIUV","SW_SpeederBike","SW_SpeederBikeIMPw"];

////////////////////////////////////
//             UNITS             ///
////////////////////////////////////
//Military Units
CSATGrunt = "SWOP_Sand_Stormtrooper";
CSATOfficer = "SWOP_Storm_CAP";
CSATBodyG = "SWOP_Spec_shocktrooper_e";
CSATCrew = "SWOP_Storm_crewman";
CSATMarksman = "SWOP_Sand_Stormtrooper_t";
staticCrewInvaders = "SWOP_Sand_Stormtrooper";
CSATPilot = "SWOP_Navy_Pilot";

//Militia Units
if (gameMode == 4) then
	{
	FIARifleman = "SWOP_Storm_StormtrooperC";
	FIAMarksman = "SWOP_Storm_StormtrooperC_t";
	};

////////////////////////////////////
//            GROUPS             ///
////////////////////////////////////
//Military Groups
//Teams
groupsCSATSentry = ["SWOP_Sand_Stormtrooper_Corp","SWOP_Sand_Stormtrooper"];
groupsCSATSniper = ["SWOP_Scout_sniper","SWOP_Scout_scout"];
groupsCSATsmall = [groupsCSATSentry,["SWOP_Scout_sergeant","SWOP_Scout_trooper"],groupsCSATSniper];
//Fireteams
groupsCSATAA = ["SWOP_Sand_Stormtrooper_TL","SWOP_Sand_Stormtrooper_AA","SWOP_Sand_Stormtrooper_AA","SWOP_Sand_Stormtrooper"];
groupsCSATAT = ["SWOP_Sand_Stormtrooper_TL","SWOP_Sand_Stormtrooper_AA","SWOP_Sand_Stormtrooper_AA","SWOP_Sand_Stormtrooper"];
groupsCSATmid = [["SWOP_Sand_Stormtrooper_TL","SWOP_Sand_Stormtrooper_dlt","SWOP_Sand_Stormtrooper_Corp","SWOP_Sand_Stormtrooper_AA"],groupsCSATAA,groupsCSATAT];
//Squads
CSATSquad = ["SWOP_Sand_Stormtrooper_SL","SWOP_Sand_Stormtrooper","SWOP_Sand_Stormtrooper_AA","SWOP_Sand_Stormtrooper_t","SWOP_Sand_Stormtrooper_TL","SWOP_Sand_Stormtrooper_dlt","SWOP_Sand_Stormtrooper","SWOP_Storm_jumper"];
CSATSpecOp = ["SWOP_imp_DeathTrooperLeader","SWOP_imp_DeathTrooperTD","SWOP_imp_DeathTrooperHB","SWOP_imp_DeathTrooper","SWOP_Storm_Shoretrooper_AA","SWOP_imp_DeathTrooper"];
groupsCSATSquad =
	[
	CSATSquad,
	["SWOP_Sand_Stormtrooper_SL","SWOP_Sand_Stormtrooper_dlt","SWOP_Sand_Stormtrooper_Corp","SWOP_Sand_Stormtrooper_t","SWOP_Sand_Stormtrooper_AA","SWOP_Sand_Stormtrooper","SWOP_Sand_Stormtrooper","SWOP_Storm_jumper"],
	["SWOP_Sand_Stormtrooper_SL","SWOP_Sand_Stormtrooper_AA","SWOP_Sand_Stormtrooper_TL","SWOP_Sand_Stormtrooper_dlt","SWOP_Sand_Stormtrooper","SWOP_Sand_Stormtrooper","SWOP_Sand_Stormtrooper","SWOP_Storm_jumper"],
	["SWOP_Sand_Stormtrooper_SL","SWOP_Sand_Stormtrooper_AA","SWOP_Sand_Stormtrooper_TL","SWOP_Sand_Stormtrooper_dlt","SWOP_Sand_Stormtrooper","SWOP_Sand_Stormtrooper","SWOP_Sand_Stormtrooper","SWOP_Storm_jumper"],
	["SWOP_Sand_Stormtrooper_SL","SWOP_Sand_Stormtrooper_AA","SWOP_Sand_Stormtrooper_TL","SWOP_Sand_Stormtrooper_dlt","SWOP_Sand_Stormtrooper","SWOP_Sand_Stormtrooper_AA","SWOP_Sand_Stormtrooper","SWOP_Storm_jumper"],
	["SWOP_Sand_Stormtrooper_SL","SWOP_Sand_Stormtrooper_AA","SWOP_Sand_Stormtrooper_TL","SWOP_Sand_Stormtrooper_dlt","SWOP_Sand_Stormtrooper","SWOP_Sand_Stormtrooper_t","SWOP_Sand_Stormtrooper","SWOP_Storm_jumper"]
	];

//Militia Groups
if (gameMode == 4) then
	{
	//Teams
	groupsFIASmall =
		[
		["SWOP_Storm_StormtrooperC_dlt",FIARifleman],
		[FIAMarksman,FIARifleman],
		["SWOP_Storm_StormtrooperC_t","SWOP_Storm_StormtrooperC_dlt"]
		];
	//Fireteams
	groupsFIAMid =
		[
		["SWOP_Navy_Green_Cap","SWOP_Storm_StormtrooperC_dlt","SWOP_Storm_StormtrooperC",FIAMarksman],
		["SWOP_Navy_Green_Cap","SWOP_Storm_StormtrooperC_dlt","SWOP_Storm_StormtrooperC","SWOP_Storm_magmatrooper_AA"],
		["SWOP_Navy_Green_Cap","SWOP_Storm_StormtrooperC_dlt","SWOP_Storm_StormtrooperC","SWOP_Storm_StormtrooperC_t"]
		];
	//Squads
	FIASquad = ["SWOP_Navy_Green_Cap","SWOP_Storm_StormtrooperC_t","SWOP_Storm_StormtrooperC_dlt",FIARifleman,FIARifleman,FIAMarksman,"SWOP_Storm_magmatrooper_AA","SWOP_Storm_jumper"];
	groupsFIASquad =
		[
		FIASquad,
		["SWOP_Navy_Green_Cap","SWOP_Storm_StormtrooperC_t","SWOP_Storm_StormtrooperC_dlt",FIARifleman,"SWOP_Storm_StormtrooperC","SWOP_Storm_StormtrooperC","SWOP_Storm_magmatrooper_AA","SWOP_Storm_jumper"]
		];
	};

////////////////////////////////////
//           VEHICLES            ///
////////////////////////////////////
//Military Vehicles
//Lite
vehCSATBike = "SW_SpeederBike";
vehCSATLightArmed = ["SWOP_LIUV"];
vehCSATLightUnarmed = ["SW_SpeederBikeIMPw"];
vehCSATTrucks = ["O_Truck_03_transport_F","O_Truck_03_covered_F"];
vehCSATAmmoTruck = "O_Truck_03_ammo_F";
vehCSATLight = vehCSATLightArmed + vehCSATLightUnarmed;
//Armored
vehCSATAPC = ["O_SWOP_HoverT_1","O_SWOP_HoverTf_1","O_SWOP_HoverTa_1"];
vehCSATTank = "O_JM_TX130m1_1";
vehCSATAA = "O_SWOP_HoverTa_1";
vehCSATAttack = vehCSATAPC + [vehCSATTank];
//Boats
vehCSATBoat = "O_Boat_Armed_01_hmg_F";
vehCSATRBoat = "O_Boat_Transport_01_F";
vehCSATBoats = [vehCSATBoat,vehCSATRBoat,"O_SWOP_HoverT_1"];
//Planes
vehCSATPlane = "swop_tietorpe";
vehCSATPlaneAA = "swop_tie";
vehCSATTransportPlanes = ["swop_lambda"];
//Heli
vehCSATPatrolHeli = "swop_LAAT";
vehCSATTransportHelis = ["swop_lambda",vehCSATPatrolHeli];
vehCSATAttackHelis = ["swop_LAATmk2_spec"];
//UAV
vehCSATUAV = "O_UAV_02_F";
vehCSATUAVSmall = "O_UAV_01_F";
//Artillery
vehCSATMRLS = "O_SWOP_HoverTr_1";
vehCSATMRLSMags = "32Rnd_155mm_Mo_shells";
//Combined Arrays
vehCSATNormal = vehCSATLight + vehCSATTrucks + [vehCSATAmmoTruck, "O_Truck_03_fuel_F", "O_Truck_03_medical_F", "O_Truck_03_repair_F"];
vehCSATAir = vehCSATTransportHelis + vehCSATAttackHelis + [vehCSATPlane,vehCSATPlaneAA] + vehCSATTransportPlanes;

//Militia Vehicles
if (gameMode == 4) then
	{
	vehFIAArmedCar = "SW_SpeederBike";
	vehFIATruck = "O_Truck_02_transport_F";
	vehFIACar = "SW_SpeederBikeIMPw";
	};

////////////////////////////////////
//        STATIC WEAPONS         ///
////////////////////////////////////
//Assembled Statics
CSATMG = "PORTABLEGUN_Rep";
staticATInvaders = "HighTur";
staticAAInvaders = "Hoth_Dishturret";
CSATMortar = "O_Mortar_01_F";

//Static Weapon Bags
MGStaticCSATB = "O_HMG_01_high_weapon_F";
ATStaticCSATB = "O_AT_01_weapon_F";
AAStaticCSATB = "O_AA_01_weapon_F";
MortStaticCSATB = "O_Mortar_01_weapon_F";
//Short Support
supportStaticCSATB = "O_HMG_01_support_F";
//Tall Support
supportStaticCSATB2 = "O_HMG_01_support_high_F";
//Mortar Support
supportStaticCSATB3 = "O_Mortar_01_support_F";
