//////////////////////////
//   Side Information   //
//////////////////////////

["name", ""] call _saveToTemplate; 						//this line determines the faction name -- Example: ["name", "NATO"] - ENTER ONLY ONE OPTION
["spawnMarkerName", ""] call _saveToTemplate; 			//this line determines the name tag for the "carrier" on the map -- Example: ["spawnMarkerName", "NATO support corridor"] - ENTER ONLY ONE OPTION

["flag", ""] call _saveToTemplate; 						//this line determines the flag -- Example: ["flag", "Flag_NATO_F"] - ENTER ONLY ONE OPTION
["flagTexture", ""] call _saveToTemplate; 				//this line determines the flag texture -- Example: ["flagTexture", "\A3\Data_F\Flags\Flag_NATO_CO.paa"] - ENTER ONLY ONE OPTION
["flagMarkerType", ""] call _saveToTemplate; 			//this line determines the flag marker type -- Example: ["flagMarkerType", "flag_NATO"] - ENTER ONLY ONE OPTION

//////////////////////////
//       Vehicles       //
//////////////////////////

["ammobox", "B_supplyCrate_F"] call _saveToTemplate; 	//Don't touch or you die a sad and lonely death!

["vehiclesBasic", []] call _saveToTemplate; 			//this line determines basic vehicles, the lightest kind available. -- Example: ["vehiclesBasic", ["B_Quadbike_01_F"]] -- Array, can contain multiple assets
["vehiclesLightUnarmed", []] call _saveToTemplate; 		//this line determines light and unarmed vehicles. -- Example: ["vehiclesLightUnarmed", ["B_MRAP_01_F"]] -- Array, can contain multiple assets
["vehiclesLightArmed",[]] call _saveToTemplate; 		//this line determines light and armed vehicles -- Example: ["vehiclesLightArmed",["B_MRAP_01_hmg_F","B_MRAP_01_gmg_F"]] -- Array, can contain multiple assets
["vehiclesTrucks", []] call _saveToTemplate; 			//this line determines the trucks -- Example: ["vehiclesTrucks", ["B_Truck_01_transport_F","B_Truck_01_covered_F"]] -- Array, can contain multiple assets
["vehiclesCargoTrucks", []] call _saveToTemplate; 		//this line determines cargo trucks -- Example: ["vehiclesCargoTrucks", ["B_Truck_01_transport_F","B_Truck_01_covered_F"]] -- Array, can contain multiple assets
["vehiclesAmmoTrucks", []] call _saveToTemplate; 		//this line determines ammo trucks -- Example: ["vehiclesAmmoTrucks", ["B_Truck_01_ammo_F"]] -- Array, can contain multiple assets
["vehiclesRepairTrucks", []] call _saveToTemplate; 		//this line determines repair trucks -- Example: ["vehiclesRepairTrucks", ["B_Truck_01_Repair_F"]] -- Array, can contain multiple assets
["vehiclesAPCs", []] call _saveToTemplate; 				//this line determines APCs -- Example: ["vehiclesAPCs", ["B_APC_Tracked_01_rcws_F","B_APC_Tracked_01_CRV_F"]] -- Array, can contain multiple assets
["vehiclesTanks", []] call _saveToTemplate; 			//this line determines tanks -- Example: ["vehiclesTanks", ["B_MBT_01_cannon_F","B_MBT_01_TUSK_F"]] -- Array, can contain multiple assets
["vehiclesAA", []] call _saveToTemplate; 				//this line determines AA vehicles -- Example: ["vehiclesAA", ["B_APC_Tracked_01_AA_F"]] -- Array, can contain multiple assets

["vehiclesTransportBoats", []] call _saveToTemplate; 	//this line determines transport boats -- Example: ["vehiclesTransportBoats", ["B_Boat_Transport_01_F"]] -- Array, can contain multiple assets
["vehiclesGunboats", []] call _saveToTemplate; 			//this line determines gun boats -- Example: ["vehiclesGunboats", ["B_Boat_Armed_01_minigun_F"]] -- Array, can contain multiple assets
["vehiclesAmphibious", []] call _saveToTemplate; 		//this line determines amphibious vehicles  -- Example: ["vehiclesAmphibious", ["B_APC_Wheeled_01_cannon_F"]] -- Array, can contain multiple assets

["vehiclesPlanesCAS", []] call _saveToTemplate; 		//this line determines CAS planes -- Example: ["vehiclesPlanesCAS", ["B_Plane_CAS_01_dynamicLoadout_F"]] -- Array, can contain multiple assets
["vehiclesPlanesAA", []] call _saveToTemplate; 			//this line determines air supperiority planes -- Example: ["vehiclesPlanesAA", ["B_Plane_Fighter_01_F"]] -- Array, can contain multiple assets
["vehiclesPlanesTransport", []] call _saveToTemplate; 	//this line determines transport planes -- Example: ["vehiclesPlanesTransport", ["B_T_VTOL_01_infantry_F"]] -- Array, can contain multiple assets

["vehiclesHelisLight", []] call _saveToTemplate; 		//this line determines light helis -- Example: ["vehiclesHelisLight", ["B_Heli_Light_01_F"]] -- Array, can contain multiple assets
["vehiclesHelisTransport", []] call _saveToTemplate; 	//this line determines transport helis -- Example: ["vehiclesHelisTransport", ["B_Heli_Transport_01_F"]] -- Array, can contain multiple assets
["vehiclesHelisAttack", []] call _saveToTemplate; 		//this line determines attack helis -- Example: ["vehiclesHelisAttack", ["B_Heli_Attack_01_F"]] -- Array, can contain multiple assets

["vehiclesArtillery", []] call _saveToTemplate; 		//this line determines artillery vehicles -- Example: ["vehiclesArtillery", ["B_MBT_01_arty_F"]] -- Array, can contain multiple assets

["uavsAttack", []] call _saveToTemplate; 				//this line determines attack UAVs -- Example: ["uavsAttack", ["B_UAV_02_CAS_F"]] -- Array, can contain multiple assets
["uavsPortable", []] call _saveToTemplate; 				//this line determines portable UAVs -- Example: ["uavsPortable", ["B_UAV_01_F"]] -- Array, can contain multiple assets

//Config special vehicles - militia vehicles are mostly used in the early game, police cars are being used by troops around cities -- Example: 
["vehiclesMilitiaLightArmed", []] call _saveToTemplate; //this line determines lightly armed militia vehicles -- Example: ["vehiclesMilitiaLightArmed", ["B_G_Offroad_01_armed_F"]] -- Array, can contain multiple assets
["vehiclesMilitiaTrucks", []] call _saveToTemplate; 	//this line determines militia trucks (unarmed) -- Example: ["vehiclesMilitiaTrucks", ["B_G_Van_01_transport_F"]] -- Array, can contain multiple assets
["vehiclesMilitiaCars", []] call _saveToTemplate; 		//this line determines militia cars (unarmed) -- Example: ["vehiclesMilitiaCars", ["	B_G_Offroad_01_F"]] -- Array, can contain multiple assets

["vehiclesPolice", []] call _saveToTemplate; 			//this line determines police cars -- Example: ["vehiclesPolice", ["B_GEN_Offroad_01_gen_F"]] -- Array, can contain multiple assets

["staticMG", []] call _saveToTemplate; 					//this line determines static MGs -- Example: ["staticMG", ["B_HMG_01_high_F"]] -- Array, can contain multiple assets
["staticAT", []] call _saveToTemplate; 					//this line determinesstatic ATs -- Example: ["staticAT", ["B_static_AT_F"]] -- Array, can contain multiple assets
["staticAA", []] call _saveToTemplate; 					//this line determines static AAs -- Example: ["staticAA", ["B_static_AA_F"]] -- Array, can contain multiple assets
["staticMortar", []] call _saveToTemplate; 				//this line determines static mortars -- Example: ["staticMortar", ["B_Mortar_01_F"]] -- Array, can contain multiple assets

["mortarMagazineHE", ""] call _saveToTemplate; 			//this line determines available HE-shells for the static mortars - !needs to be comtible with the mortar! -- Example: ["mortarMagazineHE", "8Rnd_82mm_Mo_shells"] - ENTER ONLY ONE OPTION
["mortarMagazineSmoke", ""] call _saveToTemplate; 		//this line determines smoke-shells for the static mortar - !needs to be comtible with the mortar! -- Example: ["mortarMagazineSmoke", "8Rnd_82mm_Mo_Smoke_white"] - ENTER ONLY ONE OPTION

//Static weapon definitions
["packableMG", []] call _saveToTemplate; 				//this line determines packable static MGs -- Example: ["packableMG", ["B_HMG_01_high_F"]] -- Array, can contain multiple assets
["packableAT", []] call _saveToTemplate; 				//this line determines packable static ATs -- Example: ["packableAT", ["B_static_AT_F"]] -- Array, can contain multiple assets
["packableMortar", []] call _saveToTemplate; 			//this line determines packable static mortars -- Example: ["packableMortar", ["B_Mortar_01_F"]] -- Array, can contain multiple assets

["minefieldAT", []] call _saveToTemplate; 				//this line determines AT mines used for spawning in minefields -- Example: ["minefieldAT", ["ATMine_Range_Mag"]] -- Array, can contain multiple assets
["minefieldAPERS", []] call _saveToTemplate; 			//this line determines APERS mines used for spawning in minefields -- Example: ["minefieldAPERS", ["APERSMine_Range_Mag"]] -- Array, can contain multiple assets

["playerDefaultLoadout", $PLAYER_DEFAULT_LOADOUT$] call _saveToTemplate;//this and PvP could be made from below, unarmed for spawn, PvP from role loadouts - don't touch as it's automation
["pvpLoadouts", $PVP_LOADOUTS$] call _saveToTemplate; 	//don't touch as it's automation
["pvpVehicles", []] call _saveToTemplate; 				//this line determines the vehicles PvP players can spawn in -- Example: ["pvpVehicles", ["B_MRAP_01_F","B_MRAP_01_hmg_F"]] -- Array, can contain multiple assets


//////////////////////////
//       Loadouts       //
//////////////////////////
private _loadoutData = call _createLoadoutData;
_loadoutData setVariable ["rifles", []]; //this line determines rifles -- Example: ["arifle_MX_F","arifle_MX_pointer_F"] -- Array, can contain multiple assets
_loadoutData setVariable ["carbines", []]; //this line determines carbines -- Example: ["arifle_MXC_F","arifle_MXC_Holo_F"] -- Array, can contain multiple assets
_loadoutData setVariable ["grenadeLaunchers", []]; //this line determines grenade launchers -- Example: ["arifle_MX_GL_ACO_F","arifle_MX_GL_ACO_pointer_F"] -- Array, can contain multiple assets
_loadoutData setVariable ["SMGs", []]; //this line determines SMGs -- Example: ["SMG_01_F","SMG_01_Holo_F"] -- Array, can contain multiple assets
_loadoutData setVariable ["machineGuns", []]; //this line determines machine guns -- Example: ["arifle_MX_SW_F","arifle_MX_SW_Hamr_pointer_F"] -- Array, can contain multiple assets
_loadoutData setVariable ["marksmanRifles", []]; //this line determines markman rifles -- Example: ["arifle_MXM_F","arifle_MXM_Hamr_pointer_F"] -- Array, can contain multiple assets
_loadoutData setVariable ["sniperRifles", []]; //this line determines sniper rifles -- Example: ["srifle_LRR_camo_F","srifle_LRR_camo_SOS_F"] -- Array, can contain multiple assets
_loadoutData setVariable ["lightATLaunchers", []]; //this line determines light AT launchers -- Example: ["launch_NLAW_F"] -- Array, can contain multiple assets
_loadoutData setVariable ["ATLaunchers", []]; //this line determines light AT launchers -- Example: ["launch_NLAW_F"] -- Array, can contain multiple assets
_loadoutData setVariable ["missileATLaunchers", []]; //this line determines missile AT launchers -- Example: ["launch_B_Titan_short_F"] -- Array, can contain multiple assets
_loadoutData setVariable ["AALaunchers", []]; //this line determines AA launchers -- Example: ["launch_B_Titan_F"] -- Array, can contain multiple assets
_loadoutData setVariable ["sidearms", []]; //this line determines handguns/sidearms -- Example: ["hgun_Pistol_heavy_01_F", "hgun_P07_F"] -- Array, can contain multiple assets

_loadoutData setVariable ["ATMines", []]; //this line determines the AT mines which can be carried by units -- Example: ["ATMine_Range_Mag"] -- Array, can contain multiple assets 
_loadoutData setVariable ["APMines", []]; //this line determines the APERS mines which can be carried by units -- Example: ["APERSMine_Range_Mag"] -- Array, can contain multiple assets
_loadoutData setVariable ["lightExplosives", []]; //this line determines light explosives -- Example: ["DemoCharge_Remote_Mag"] -- Array, can contain multiple assets 
_loadoutData setVariable ["heavyExplosives", []]; //this line determines heavy explosives -- Example: ["SatchelCharge_Remote_Mag"] -- Array, can contain multiple assets 

_loadoutData setVariable ["antiInfantryGrenades", []]; //this line determines anti infantry grenades (frag and such) -- Example: ["HandGrenade","MiniGrenade"] -- Array, can contain multiple assets 
_loadoutData setVariable ["antiTankGrenades", []]; //this line determines anti tank grenades. Leave empty when not available. -- Array, can contain multiple assets 
_loadoutData setVariable ["smokeGrenades", []]; //this line determines smoke grenades -- Example: ["SmokeShell", "SmokeShellRed"] -- Array, can contain multiple assets 

_loadoutData setVariable ["NVGs", []]; //this line determines NVGs -- Array, can contain multiple assets 

_loadoutData setVariable ["uniforms", []];
_loadoutData setVariable ["vests", []];
_loadoutData setVariable ["backpacks", []];
_loadoutData setVariable ["helmets", []];

////////////////////////////////
//  Special Forces Loadouts   //
////////////////////////////////
private _sfLoadoutData = _loadoutData call _copyLoadoutData;
_sfLoadoutData setVariable ["uniforms", []];
_sfLoadoutData setVariable ["vests", []];
_sfLoadoutData setVariable ["backpacks", []];
_sfLoadoutData setVariable ["helmets", []];

//The following lines are determining the loadout of the Special Forces SquadLeader
["loadouts_SF_SquadLeader", [_sfLoadoutData] call A3A_fnc_createSquadLeaderLoadouts] call _saveToTemplate; //don't touch as it's automation
//The following lines are determining the loadout of the Special Forces Rifleman
["loadouts_SF_Rifleman", [_sfLoadoutData] call A3A_fnc_createRiflemanLoadouts] call _saveToTemplate; //don't touch as it's automation
//The following lines are determining the loadout of the Special Forces Medic
["loadouts_SF_Medic", [_sfLoadoutData] call A3A_fnc_createMedicLoadouts] call _saveToTemplate; //don't touch as it's automation
//The following lines are determining the loadout of the Special Forces Engineer
["loadouts_SF_Engineer", [_sfLoadoutData] call A3A_fnc_createEngineerLoadouts] call _saveToTemplate; //don't touch as it's automation
//The following lines are determining the loadout of the Special Forces Explosives Expert
["loadouts_SF_ExplosivesExpert", [_sfLoadoutData] call A3A_fnc_createExplosivesExpertLoadouts] call _saveToTemplate; //don't touch as it's automation
//The following lines are determining the loadout of the Special Forces Grenadier
["loadouts_SF_Grenadier", [_sfLoadoutData] call A3A_fnc_createGrenadierLoadouts] call _saveToTemplate; //don't touch as it's automation
//The following lines are determining the loadout of the Special Forces Light AT unit
["loadouts_SF_LAT", [_sfLoadoutData] call A3A_fnc_createAntiTankLoadouts] call _saveToTemplate; //don't touch as it's automation
//The following lines are determining the loadout of the Special Forces AT unit
["loadouts_SF_AT", [_sfLoadoutData] call A3A_fnc_createAntiTankLoadouts] call _saveToTemplate; //don't touch as it's automation
//The following lines are determining the loadout of the Special Forces AA unit
["loadouts_SF_AA", [_sfLoadoutData] call A3A_fnc_createAntiAirLoadouts] call _saveToTemplate; //don't touch as it's automation
//The following lines are determining the loadout of the Special Forces AmmoBearer units
["loadouts_SF_ATAmmoBearers", [_sfLoadoutData, ("loadouts_SF_AT" call _getFromTemplate)] call A3A_fnc_createAmmoBearerLoadouts] call _saveToTemplate;//don't touch as it's automation
["loadouts_SF_AAAmmoBearers", [_sfLoadoutData, ("loadouts_SF_AA" call _getFromTemplate)] call A3A_fnc_createAmmoBearerLoadouts] call _saveToTemplate;//don't touch as it's automation
//The following lines are determining the loadout of the Special Forces Machinegunner unit
["loadouts_SF_MachineGunner", [_sfLoadoutData] call A3A_fnc_createMachineGunnerLoadouts] call _saveToTemplate; //don't touch as it's automation
//The following lines are determining the loadout of the Special Forces Marksman unit
["loadouts_SF_Marksman", [_sfLoadoutData] call A3A_fnc_createMarksmanLoadouts] call _saveToTemplate; //don't touch as it's automation
//The following lines are determining the loadout of the Special Forces Sniper unit
["loadouts_SF_Sniper", [_sfLoadoutData] call A3A_fnc_createSniperLoadouts] call _saveToTemplate; //don't touch as it's automation

//////////////////////////
//  Military Loadouts   //
//////////////////////////
private _militaryLoadoutData = _loadoutData call _copyLoadoutData;
_militaryLoadoutData setVariable ["uniforms", []];
_militaryLoadoutData setVariable ["vests", []];
_militaryLoadoutData setVariable ["backpacks", []];
_militaryLoadoutData setVariable ["helmets", []];

//The following lines are determining the loadout of the Military SquadLeader
["loadouts_military_SquadLeader", [_militaryLoadoutData] call A3A_fnc_createSquadLeaderLoadouts] call _saveToTemplate; //don't touch as it's automation
//The following lines are determining the loadout of the Military Rifleman
["loadouts_military_Rifleman", [_militaryLoadoutData] call A3A_fnc_createRiflemanLoadouts] call _saveToTemplate; //don't touch as it's automation
//The following lines are determining the loadout of the Military Medic
["loadouts_military_Medic", [_militaryLoadoutData] call A3A_fnc_createMedicLoadouts] call _saveToTemplate; //don't touch as it's automation
//The following lines are determining the loadout of the Military Engineer
["loadouts_military_Engineer", [_militaryLoadoutData] call A3A_fnc_createEngineerLoadouts] call _saveToTemplate; //don't touch as it's automation
//The following lines are determining the loadout of the Military Explosives Expert
["loadouts_military_ExplosivesExpert", [_militaryLoadoutData] call A3A_fnc_createExplosivesExpertLoadouts] call _saveToTemplate; //don't touch as it's automation
//The following lines are determining the loadout of the Military Grenadier
["loadouts_military_Grenadier", [_militaryLoadoutData] call A3A_fnc_createGrenadierLoadouts] call _saveToTemplate; //don't touch as it's automation
//The following lines are determining the loadout of the Military Light AT unit
["loadouts_military_LAT", [_militaryLoadoutData] call A3A_fnc_createAntiTankLoadouts] call _saveToTemplate; //don't touch as it's automation
//The following lines are determining the loadout of the Military AT unit
["loadouts_military_AT", [_militaryLoadoutData] call A3A_fnc_createAntiTankLoadouts] call _saveToTemplate; //don't touch as it's automation
//The following lines are determining the loadout of the Military AA unit
["loadouts_military_AA", [_militaryLoadoutData] call A3A_fnc_createAntiAirLoadouts] call _saveToTemplate; //don't touch as it's automation
//The following lines are determining the loadout of the Military AmmoBearer units
["loadouts_military_ATAmmoBearers", [_militaryLoadoutData, ("loadouts_military_AT" call _getFromTemplate)] call A3A_fnc_createAmmoBearerLoadouts] call _saveToTemplate;//don't touch as it's automation
["loadouts_military_AAAmmoBearers", [_militaryLoadoutData, ("loadouts_military_AA" call _getFromTemplate)] call A3A_fnc_createAmmoBearerLoadouts] call _saveToTemplate;//don't touch as it's automation
//The following lines are determining the loadout of the Military Machinegunner unit
["loadouts_military_MachineGunner", [_militaryLoadoutData] call A3A_fnc_createMachineGunnerLoadouts] call _saveToTemplate; //don't touch as it's automation
//The following lines are determining the loadout of the Military Marksman unit
["loadouts_military_Marksman", [_militaryLoadoutData] call A3A_fnc_createMarksmanLoadouts] call _saveToTemplate; //don't touch as it's automation
//The following lines are determining the loadout of the Military Sniper unit
["loadouts_military_Sniper", [_militaryLoadoutData] call A3A_fnc_createSniperLoadouts] call _saveToTemplate; //don't touch as it's automation

////////////////////////////
//    Police Loadouts     //
////////////////////////////
private _policeLoadoutData = _loadoutData call _copyLoadoutData;
_policeLoadoutData setVariable ["uniforms", []];
_policeLoadoutData setVariable ["vests", []];
_policeLoadoutData setVariable ["backpacks", []];
_policeLoadoutData setVariable ["helmets", []];

["loadouts_police_SquadLeader", [_policeLoadoutData] call A3A_fnc_createSquadLeaderLoadouts] call _saveToTemplate; //don't touch as it's automation
["loadouts_police_Standard", [_policeLoadoutData] call A3A_fnc_createPoliceLoadouts] call _saveToTemplate; //don't touch as it's automation

////////////////////////////
//    Militia Loadouts    //
////////////////////////////
private _militiaLoadoutData = _loadoutData call _copyLoadoutData;
_militiaLoadoutData setVariable ["uniforms", []];
_militiaLoadoutData setVariable ["vests", []];
_militiaLoadoutData setVariable ["backpacks", []];
_militiaLoadoutData setVariable ["helmets", []];

//The following lines are determining the loadout of the militia rifleman
["loadouts_militia_Rifleman", [_militiaLoadoutData] call A3A_fnc_createRiflemanLoadouts] call _saveToTemplate; //don't touch as it's automation
//The following lines are determining the loadout of the militia marksman
["loadouts_militia_Marksman", [_militiaLoadoutData] call A3A_fnc_createMarksmanLoadouts] call _saveToTemplate; //don't touch as it's automation

//////////////////////////
//    Misc Loadouts     //
//////////////////////////
private _crewLoadoutData = _militaryLoadoutData call _copyLoadoutData;
//Customise crew gear here.
//The following lines are determining the loadout of the vehicle crew
["loadouts_Crew", [_crewLoadoutData] call A3A_fnc_createMinimalArmedLoadouts] call _saveToTemplate; //don't touch as it's automation

private _pilotLoadoutData = _militaryLoadoutData call _copyLoadoutData;
//Customise pilot gear here.
//The following lines are determining the loadout of the pilots
["loadouts_Pilot", [_pilotLoadoutData] call A3A_fnc_createMinimalArmedLoadouts] call _saveToTemplate; //don't touch as it's automation

//The following lines are determining the loadout for the unit used in the "kill the official" mission
["loadouts_Official", [_militaryLoadoutData] call A3A_fnc_createMinimalArmedLoadouts] call _saveToTemplate; //don't touch as it's automation

//The following lines are determining the loadout for the AI used in the "kill the traitor" mission
["loadouts_Traitor", [_militiaLoadoutData] call A3A_fnc_createMinimalArmedLoadouts] call _saveToTemplate; //don't touch as it's automation
