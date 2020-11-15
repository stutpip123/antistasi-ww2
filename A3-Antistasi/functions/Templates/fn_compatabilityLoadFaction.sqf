/*
 * File: fn_compatabilityLoadFaction.sqf
 * Author: Spoffy
 * Description:
 *    Loads a faction definition file, and transforms it into the old global variable system for sides.
 * Params:
 *    _file - Faction definition file path
 *    _side - Side to load them in as
 * Returns:
 *    Namespace containing faction information
 * Example Usage:
 */

//TODO: Remove factionMaleInvaders from Antistasi
//TODO: Remove factionFIA from Antistasi
//TODO: Remove factionGEN
//TODO: Remove factionMaleOccupants

params ["_file", "_side"];

private _faction = [_file] call A3A_fnc_loadFaction;

if (_side isEqualTo east) then {
	nameInvaders = _faction getVariable "name";

	//Flag images
	CSATFlag = _faction getVariable "flag";
	CSATFlagTexture = _faction getVariable "flagTexture";
	flagCSATmrk = _faction getVariable "flagMarkerType";
	
	//Loot crate
	CSATAmmoBox = _faction getVariable "ammobox";

	//PVP Loadouts
	CSATPlayerLoadouts = _faction getVariable "pvpLoadouts";
	vehCSATPVP = _faction getVariable "pvpVehicles";

	CSATGrunt = _faction getVariable "loadouts_military_SquadLeader";
	CSATOfficer = _faction getVariable "loadouts_Official";
	CSATBodyG = _faction getVariable "loadouts_military_Rifleman";
	CSATCrew = _faction getVariable "loadouts_Crew";
	CSATMarksman = _faction getVariable "loadouts_military_Marksman";
	staticCrewInvaders = _faction getVariable "loadouts_military_Rifleman";
	CSATPilot = _faction getVariable "loadouts_Pilot";

	if (gameMode == 4) then {
		FIARifleman = _faction getVariable "loadouts_militia_Rifleman";
		FIAMarksman = _faction getVariable "loadouts_militia_Marksman";
	};

	groupsCSATSentry = [_faction getVariable "loadouts_military_Grenadier", _faction getVariable "loadouts_military_Rifleman"];
	//TODO Change Rifleman to spotter.
	groupsCSATSniper = [_faction getVariable "loadouts_military_Sniper", _faction getVariable "loadouts_military_Rifleman"];
	//TODO Create lighter Recon loadouts, and add a group of them to here.
	groupsCSATSmall = [groupsCSATSentry, groupsCSATSniper];
	//TODO Add ammobearers
	groupsCSATAA = [
		_faction getVariable "loadouts_military_SquadLeader",
		_faction getVariable "loadouts_military_AA",
		_faction getVariable "loadouts_military_AA"
	];
	groupsCSATAT = [
		_faction getVariable "loadouts_military_SquadLeader",
		_faction getVariable "loadouts_military_AT",
		_faction getVariable "loadouts_military_AT"
	];
	private _groupsCSATMediumSquad = [
		_faction getVariable "loadouts_military_SquadLeader", 
		_faction getVariable "loadouts_military_MachineGunner",
		_faction getVariable "loadouts_military_Grenadier",
		_faction getVariable "loadouts_military_LAT"
	];
	groupsCSATmid = [_groupsCSATMediumSquad, groupsCSATAA, groupsCSATAT];
	
	groupsCSATSquad = [];
	for "_i" from 1 to 5 do {
		groupsCSATSquad pushBack [
			_faction getVariable "loadouts_military_SquadLeader",
			selectRandomWeighted [_faction getVariable "loadouts_military_LAT", 2, _faction getVariable "loadouts_military_MachineGunner", 1],
			selectRandomWeighted [_faction getVariable "loadouts_military_Rifleman", 2, _faction getVariable "loadouts_military_Grenadier", 1],
			selectRandomWeighted [_faction getVariable "loadouts_military_MachineGunner", 2, _faction getVariable "loadouts_military_Marksman", 1],
			selectRandomWeighted [_faction getVariable "loadouts_military_Rifleman", 4, _faction getVariable "loadouts_military_AT", 1],
			selectRandomWeighted [_faction getVariable "loadouts_military_AA", 1, _faction getVariable "loadouts_military_Engineer", 4],
			_faction getVariable "loadouts_military_Rifleman",
			_faction getVariable "loadouts_military_Medic"
		];
	};

	CSATSquad = groupsCSATSquad select 0;
	CSATSpecOp = [
		_faction getVariable "loadouts_SF_SquadLeader",
		_faction getVariable "loadouts_SF_Rifleman",
		_faction getVariable "loadouts_SF_MachineGunner",
		_faction getVariable "loadouts_SF_ExplosivesExpert",
		_faction getVariable "loadouts_SF_LAT",
		_faction getVariable "loadouts_SF_Medic"
	];

	if (gamemode == 4) then {
		groupsFIASmall = [
			[_faction getVariable "loadouts_military_Grenadier", _faction getVariable "loadouts_militia_Rifleman"],
			[_faction getVariable "loadouts_militia_Marksman", _faction getVariable "loadouts_militia_Rifleman"],
			[_faction getVariable "loadouts_militia_Marksman", _faction getVariable "loadouts_military_Grenadier"]
		];
		groupsFIAMid = [];
		for "_i" from 1 to 6 do {
			groupsFIAMid pushBack [
				_faction getVariable "loadouts_military_SquadLeader",
				_faction getVariable "loadouts_military_Grenadier",
				_faction getVariable "loadouts_military_MachineGunner",
				selectRandomWeighted [
					_faction getVariable "loadouts_military_LAT", 1, 
					_faction getVariable "loadouts_militia_Marksman", 1
					_faction getVariable "loadouts_military_Engineer", 1
				]
			];
		};

		groupsFIASquad = [];
		for "_i" from 1 to 5 do {
			groupsFIASquad pushBack [
				_faction getVariable "loadouts_military_SquadLeader",
				_faction getVariable "loadouts_military_MachineGunner",
				_faction getVariable "loadouts_military_Grenadier",
				_faction getVariable "loadouts_militia_Rifleman",
				selectRandomWeighted [_faction getVariable "loadouts_militia_Rifleman", 1, _faction getVariable "loadouts_militia_Marksman", 1],
				selectRandomWeighted [_faction getVariable "loadouts_militia_Rifleman", 2, _faction getVariable "loadouts_militia_Marksman", 1],
				selectRandomWeighted [_faction getVariable "loadouts_militia_Rifleman", 1, _faction getVariable "loadouts_military_ExplosivesExpert", 1],
				_faction getVariable "loadouts_military_LAT",
				_faction getVariable "loadouts_military_Medic"
			];
		};

		FIASquad = groupsFIASquad select 0;
	};

	vehCSATBike = _faction getVariable "vehiclesBasic" select 0;
	vehCSATLightArmed = _faction getVariable "vehiclesLightArmed";
	vehCSATLightUnarmed = _faction getVariable "vehiclesLightUnarmed";
	vehCSATTrucks = _faction getVariable "vehiclesTrucks";
	vehCSATAmmoTruck = _faction getVariable "vehiclesAmmoTrucks" select 0;
	vehCSATLight = vehCSATLightArmed + vehCSATLightUnarmed;

	vehCSATAPC = _faction getVariable "vehiclesAPCs";
	vehCSATTank = _faction getVariable "vehiclesTanks" select 0;
	vehCSATAA = _faction getVariable "vehiclesAA" select 0;
	vehCSATAttack = vehCSATAPC + [vehCSATTank];

	vehCSATBoat = _faction getVariable "vehiclesGunboatsBoats" select 0;
	vehCSATRBoat = _faction getVariable "vehiclesTransportBoats" select 0;
	vehCSATBoats = [vehCSATBoat, vehCSATRBoat] + (_faction getVariable "vehiclesAmphibious");

	vehCSATPlane = _faction getVariable "vehiclesPlanesCAS" select 0;
	vehCSATPlaneAA = _faction getVariable "vehiclesPlanesAA" select 0;
	vehCSATTransportPlanes = _faction getVariable "vehiclesPlanesTransport";

	vehCSATPatrolHeli = _faction getVariable "vehiclesHelisLight" select 0;
	vehCSATTransportHelis = (_faction getVariable "vehiclesHelisLight") + (_faction getVariable "vehiclesHelisTransport");
	vehCSATAttackHelis = _faction getVariable "vehiclesHelisAttack";

	vehCSATUAV = _faction getVariable "uavsAttack" select 0;
	vehCSATUAVSmall = _faction getVariable "uavsPortable" select 0;

	vehCSATMRLS = _faction getVariable "vehiclesArtillery" select 0 select 0;
	vehCSATMRLSMags = _faction getVariable "vehiclesArtillery" select 0 select 1 select 0;

	vehCSATNormal = 
		  vehCSATLight 
		+ vehCSATTrucks 
		+ (_faction getVariable "vehiclesAmmoTrucks") 
		+ (_faction getVariable "vehiclesRepairTrucks") 
		+ (_faction getVariable "vehiclesFuelTrucks")
		+ (_faction getVariable "vehiclesMedical");

	vehCSATAir = 
		  vehCSATTransportHelis
		+ vehCSATAttackHelis
		+ [vehCSATPlane, vehCSATPlaneAA]
		+ vehCSATTransportPlanes;

	if (gameMode == 4) then {
		vehFIAArmedCar = _faction getVariable "vehiclesMilitiaLightArmed" select 0;
		vehFIATruck = _faction getVariable "vehiclesMilitiaTrucks" select 0;
		vehFIACar = _faction getVariable "vehiclesMilitiaCars" select 0;
	};

	CSATMG = _faction getVariable "staticMGs" select 0;
	staticATInvaders = _faction getVariable "staticAT" select 0;
	staticAAInvaders = _faction getVariable "staticAA" select 0;
	CSATMortar = _faction getVariable "staticMortar" select 0;

	MGStaticCSATB = _faction getVariable "baggedMGs" select 0 select 0;
	//TODO: Add tall/short support support.
	supportStaticCSATB = _faction getVariable "baggedMGs" select 0 select 1;
	supportStaticCSATB2 = _faction getVariable "baggedMGs" select 0 select 1;
	ATStaticCSATB = _faction getVariable "baggedAT" select 0 select 0;
	AAStaticCSATB = _faction getVariable "baggedAA" select 0 select 0;
	MortStaticCSATB = _faction getVariable "baggedMortars" select 0 select 0;
	supportStaticCSATB3 = _faction getVariable "baggedMortars" select 0 select 1;
};


if (_side isEqualTo west) then {
	nameOccupants = _faction getVariable "name";

	//Militia faction (complete with weird mod compat)
	if ((gameMode != 4) and (!hasFFAA)) then {factionFIA = ""};

	//Flag images
	NATOFlag = _faction getVariable "flag";
	NATOFlagTexture = _faction getVariable "flagTexture";
	flagNATOmrk = _faction getVariable "flagMarkerType";
	if (isServer) then {"NATO_carrier" setMarkerText (_faction getVariable "spawnMarkerName")};
	
	//Loot crate
	NATOAmmobox = _faction getVariable "ammobox";

	//PVP Loadouts
	NATOPlayerLoadouts = _faction getVariable "pvpLoadouts";
	vehNATOPVP = _faction getVariable "pvpVehicles";

	NATOGrunt = _faction getVariable "loadouts_military_SquadLeader";
	NATOOfficer = _faction getVariable "loadouts_Official";
	NATOOfficer2 = _faction getVariable "loadouts_Traitor";
	NATOBodyG = _faction getVariable "loadouts_military_Rifleman";
	NATOCrew = _faction getVariable "loadouts_Crew";
	NATOUnarmed = _faction getVariable "loadouts_Unarmed";
	NATOMarksman = _faction getVariable "loadouts_military_Marksman";
	staticCrewOccupants = _faction getVariable "loadouts_military_Rifleman";
	NATOPilot = _faction getVariable "loadouts_Pilot";

	if ((gameMode != 4) and (!hasFFAA)) then
		FIARifleman = _faction getVariable "loadouts_militia_Rifleman";
		FIAMarksman = _faction getVariable "loadouts_militia_Marksman";
	};

	policeOfficer = _faction getVariable "loadouts_police_SquadLeader";
	policeGrunt = _faction getVariable "loadouts_police_Standard";
	groupsNATOGen = [policeOfficer, policeGrunt];

	groupsNATOSentry = [_faction getVariable "loadouts_military_Grenadier", _faction getVariable "loadouts_military_Rifleman"];
	//TODO Change Rifleman to spotter.
	groupsNATOSniper = [_faction getVariable "loadouts_military_Sniper", _faction getVariable "loadouts_military_Rifleman"];
	//TODO Create lighter Recon loadouts, and add a group of them to here.
	groupsNATOSmall = [groupsNATOSentry, groupsNATOSniper];
	//TODO Add ammobearers
	groupsNATOAA = [
		_faction getVariable "loadouts_military_SquadLeader",
		_faction getVariable "loadouts_military_AA",
		_faction getVariable "loadouts_military_AA"
	];
	groupsNATOAT = [
		_faction getVariable "loadouts_military_SquadLeader",
		_faction getVariable "loadouts_military_AT",
		_faction getVariable "loadouts_military_AT"
	];
	private _groupsNATOMediumSquad = [
		_faction getVariable "loadouts_military_SquadLeader", 
		_faction getVariable "loadouts_military_MachineGunner",
		_faction getVariable "loadouts_military_Grenadier",
		_faction getVariable "loadouts_military_LAT"
	];
	groupsNATOmid = [_groupsNATOMediumSquad, groupsNATOAA, groupsNATOAT];
	
	groupsNATOSquad = [];
	for "_i" from 1 to 5 do {
		groupsNATOSquad pushBack [
			_faction getVariable "loadouts_military_SquadLeader",
			selectRandomWeighted [_faction getVariable "loadouts_military_LAT", 2, _faction getVariable "loadouts_military_MachineGunner", 1],
			selectRandomWeighted [_faction getVariable "loadouts_military_Rifleman", 2, _faction getVariable "loadouts_military_Grenadier", 1],
			selectRandomWeighted [_faction getVariable "loadouts_military_MachineGunner", 2, _faction getVariable "loadouts_military_Marksman", 1],
			selectRandomWeighted [_faction getVariable "loadouts_military_Rifleman", 4, _faction getVariable "loadouts_military_AT", 1],
			selectRandomWeighted [_faction getVariable "loadouts_military_AA", 1, _faction getVariable "loadouts_military_Engineer", 4],
			_faction getVariable "loadouts_military_Rifleman",
			_faction getVariable "loadouts_military_Medic"
		];
	};

	NATOSquad = groupsNATOSquad select 0;
	NATOSpecOp = [
		_faction getVariable "loadouts_SF_SquadLeader",
		_faction getVariable "loadouts_SF_Rifleman",
		_faction getVariable "loadouts_SF_MachineGunner",
		_faction getVariable "loadouts_SF_ExplosivesExpert",
		_faction getVariable "loadouts_SF_LAT",
		_faction getVariable "loadouts_SF_Medic"
	];

	if ((gameMode != 4) and (!hasFFAA)) then
		groupsFIASmall = [
			[_faction getVariable "loadouts_military_Grenadier", _faction getVariable "loadouts_militia_Rifleman"],
			[_faction getVariable "loadouts_militia_Marksman", _faction getVariable "loadouts_militia_Rifleman"],
			[_faction getVariable "loadouts_militia_Marksman", _faction getVariable "loadouts_military_Grenadier"]
		];
		groupsFIAMid = [];
		for "_i" from 1 to 6 do {
			groupsFIAMid pushBack [
				_faction getVariable "loadouts_military_SquadLeader",
				_faction getVariable "loadouts_military_Grenadier",
				_faction getVariable "loadouts_military_MachineGunner",
				selectRandomWeighted [
					_faction getVariable "loadouts_military_LAT", 1, 
					_faction getVariable "loadouts_militia_Marksman", 1
					_faction getVariable "loadouts_military_Engineer", 1
				]
			];
		};

		groupsFIASquad = [];
		for "_i" from 1 to 5 do {
			groupsFIASquad pushBack [
				_faction getVariable "loadouts_military_SquadLeader",
				_faction getVariable "loadouts_military_MachineGunner",
				_faction getVariable "loadouts_military_Grenadier",
				_faction getVariable "loadouts_militia_Rifleman",
				selectRandomWeighted [_faction getVariable "loadouts_militia_Rifleman", 1, _faction getVariable "loadouts_militia_Marksman", 1],
				selectRandomWeighted [_faction getVariable "loadouts_militia_Rifleman", 2, _faction getVariable "loadouts_militia_Marksman", 1],
				selectRandomWeighted [_faction getVariable "loadouts_militia_Rifleman", 1, _faction getVariable "loadouts_military_ExplosivesExpert", 1],
				_faction getVariable "loadouts_military_LAT",
				_faction getVariable "loadouts_military_Medic"
			];
		};

		FIASquad = groupsFIASquad select 0;
	};

	vehNATOBike = _faction getVariable "vehiclesBasic" select 0;
	vehNATOLightArmed = _faction getVariable "vehiclesLightArmed";
	vehNATOLightUnarmed = _faction getVariable "vehiclesLightUnarmed";
	vehNATOTrucks = _faction getVariable "vehiclesTrucks";
	vehNATOCargoTrucks = _faction getVariable "vehiclesCargoTrucks";
	vehNATOAmmoTruck = _faction getVariable "vehiclesAmmoTrucks" select 0;
	vehNATORepairTruck = _faction getVariable "vehiclesRepairTrucks" select 0;
	vehNATOLight = vehNATOLightArmed + vehNATOLightUnarmed;

	vehNATOAPC = _faction getVariable "vehiclesAPCs";
	vehNATOTank = _faction getVariable "vehiclesTanks" select 0;
	vehNATOAA = _faction getVariable "vehiclesAA" select 0;
	vehNATOAttack = vehNATOAPC + [vehNATOTank];

	vehNATOBoat = _faction getVariable "vehiclesGunboatsBoats" select 0;
	vehNATORBoat = _faction getVariable "vehiclesTransportBoats" select 0;
	vehNATOBoats = [vehNATOBoat, vehNATORBoat] + (_faction getVariable "vehiclesAmphibious");

	vehNATOPlane = _faction getVariable "vehiclesPlanesCAS" select 0;
	vehNATOPlaneAA = _faction getVariable "vehiclesPlanesAA" select 0;
	vehNATOTransportPlanes = _faction getVariable "vehiclesPlanesTransport";

	vehNATOPatrolHeli = _faction getVariable "vehiclesHelisLight" select 0;
	vehNATOTransportHelis = (_faction getVariable "vehiclesHelisLight") + (_faction getVariable "vehiclesHelisTransport");
	vehNATOAttackHelis = _faction getVariable "vehiclesHelisAttack";

	vehNATOUAV = _faction getVariable "uavsAttack" select 0;
	vehNATOUAVSmall = _faction getVariable "uavsPortable" select 0;

	vehNATOMRLS = _faction getVariable "vehiclesArtillery" select 0 select 0;
	vehNATOMRLSMags = _faction getVariable "vehiclesArtillery" select 0 select 1 select 0;

	vehNATONormal = 
		  vehNATOLight 
		+ vehNATOTrucks 
		+ (_faction getVariable "vehiclesAmmoTrucks") 
		+ (_faction getVariable "vehiclesRepairTrucks") 
		+ (_faction getVariable "vehiclesFuelTrucks")
		+ (_faction getVariable "vehiclesMedical");

	vehNATOAir = 
		  vehNATOTransportHelis
		+ vehNATOAttackHelis
		+ [vehNATOPlane, vehNATOPlaneAA]
		+ vehNATOTransportPlanes;

	if ((gameMode != 4) and (!hasFFAA)) then
		vehFIAArmedCar = _faction getVariable "vehiclesMilitiaLightArmed" select 0;
		vehFIATruck = _faction getVariable "vehiclesMilitiaTrucks" select 0;
		vehFIACar = _faction getVariable "vehiclesMilitiaCars" select 0;
	};

	vehPoliceCar = _faction getVariable "vehiclesPolice" select 0;

	NATOMG = _faction getVariable "staticMGs" select 0;
	staticATOccupants = _faction getVariable "staticAT" select 0;
	staticAAOccupants = _faction getVariable "staticAA" select 0;
	NATOMortar = _faction getVariable "staticMortar" select 0;

	MGStaticNATOB = _faction getVariable "baggedMGs" select 0 select 0;
	//TODO: Add tall/short support support.
	supportStaticNATOB = _faction getVariable "baggedMGs" select 0 select 1;
	supportStaticNATOB2 = _faction getVariable "baggedMGs" select 0 select 1;
	ATStaticNATOB = _faction getVariable "baggedAT" select 0 select 0;
	AAStaticNATOB = _faction getVariable "baggedAA" select 0 select 0;
	MortStaticNATOB = _faction getVariable "baggedMortars" select 0 select 0;
	supportStaticNATOB3 = _faction getVariable "baggedMortars" select 0 select 1;
};

if (_side isEqualTo independent) then {
	nameTeamPlayer = _faction getVariable "name";

	//Flag images
	SDKFlag = _faction getVariable "flag";
	SDKFlagTexture = _faction getVariable "flagTexture";
	typePetros = _faction getVariable "petrosLoadout";

	//TODO: Continue this
};