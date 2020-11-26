//////////////////////////
//   Side Information   //
//////////////////////////

["name", "NATO"] call _saveToTemplate; 						//this line determines the faction name -- Example: ["name", "NATO"] - ENTER ONLY ONE OPTION
["spawnMarkerName", "USS Enterprise"] call _saveToTemplate; 			//this line determines the name tag for the "carrier" on the map -- Example: ["spawnMarkerName", "NATO support corridor"] - ENTER ONLY ONE OPTION

["flag", "Flag_NATO_F"] call _saveToTemplate; 						//this line determines the flag -- Example: ["flag", "Flag_NATO_F"] - ENTER ONLY ONE OPTION
["flagTexture", "\A3\Data_F\Flags\Flag_NATO_CO.paa"] call _saveToTemplate; 				//this line determines the flag texture -- Example: ["flagTexture", "\A3\Data_F\Flags\Flag_NATO_CO.paa"] - ENTER ONLY ONE OPTION
["flagMarkerType", "flag_NATO"] call _saveToTemplate; 			//this line determines the flag marker type -- Example: ["flagMarkerType", "flag_NATO"] - ENTER ONLY ONE OPTION

//////////////////////////
//       Vehicles       //
//////////////////////////

["ammobox", "B_supplyCrate_F"] call _saveToTemplate; 	//Don't touch or you die a sad and lonely death!

["vehiclesBasic", ["B_Quadbike_01_F"]] call _saveToTemplate; 			//this line determines basic vehicles, the lightest kind available. -- Example: ["vehiclesBasic", ["B_Quadbike_01_F"]] -- Array, can contain multiple assets
["vehiclesLightUnarmed", ["B_MRAP_01_F"]] call _saveToTemplate; 		//this line determines light and unarmed vehicles. -- Example: ["vehiclesLightUnarmed", ["B_MRAP_01_F"]] -- Array, can contain multiple assets
["vehiclesLightArmed", ["B_MRAP_01_hmg_F","B_MRAP_01_gmg_F"]] call _saveToTemplate; 		//this line determines light and armed vehicles -- Example: ["vehiclesLightArmed",["B_MRAP_01_hmg_F","B_MRAP_01_gmg_F"]] -- Array, can contain multiple assets
["vehiclesTrucks", ["B_Truck_01_transport_F","B_Truck_01_covered_F"]] call _saveToTemplate; 			//this line determines the trucks -- Example: ["vehiclesTrucks", ["B_Truck_01_transport_F","B_Truck_01_covered_F"]] -- Array, can contain multiple assets
["vehiclesCargoTrucks", ["B_Truck_01_transport_F","B_Truck_01_covered_F"]] call _saveToTemplate; 		//this line determines cargo trucks -- Example: ["vehiclesCargoTrucks", ["B_Truck_01_transport_F","B_Truck_01_covered_F"]] -- Array, can contain multiple assets
["vehiclesAmmoTrucks", ["B_Truck_01_ammo_F"]] call _saveToTemplate; 		//this line determines ammo trucks -- Example: ["vehiclesAmmoTrucks", ["B_Truck_01_ammo_F"]] -- Array, can contain multiple assets
["vehiclesRepairTrucks", ["B_Truck_01_Repair_F"]] call _saveToTemplate; 		//this line determines repair trucks -- Example: ["vehiclesRepairTrucks", ["B_Truck_01_Repair_F"]] -- Array, can contain multiple assets
["vehiclesFuelTrucks", []] call _saveToTemplate;		//this line determines fuel trucks -- Array, can contain multiple assets
["vehiclesMedical", []] call _saveToTemplate;			//this line determines medical vehicles -- Array, can contain multiple assets["vehiclesAPCs", []] call _saveToTemplate; 				//this line determines APCs -- Example: ["vehiclesAPCs", ["B_APC_Tracked_01_rcws_F","B_APC_Tracked_01_CRV_F"]] -- Array, can contain multiple assets
["vehiclesAPCs", ["B_APC_Tracked_01_rcws_F","B_APC_Tracked_01_CRV_F","B_APC_Wheeled_01_cannon_F"]] call _saveToTemplate; 				//this line determines APCs -- Example: ["vehiclesAPCs", ["B_APC_Tracked_01_rcws_F","B_APC_Tracked_01_CRV_F"]] -- Array, can contain multiple assets
["vehiclesTanks", ["B_MBT_01_cannon_F","B_MBT_01_TUSK_F"]] call _saveToTemplate; 			//this line determines tanks -- Example: ["vehiclesTanks", ["B_MBT_01_cannon_F","B_MBT_01_TUSK_F"]] -- Array, can contain multiple assets
["vehiclesAA", ["B_APC_Tracked_01_AA_F"]] call _saveToTemplate; 				//this line determines AA vehicles -- Example: ["vehiclesAA", ["B_APC_Tracked_01_AA_F"]] -- Array, can contain multiple assets

["vehiclesTransportBoats", ["B_Boat_Transport_01_F"]] call _saveToTemplate; 	//this line determines transport boats -- Example: ["vehiclesTransportBoats", ["B_Boat_Transport_01_F"]] -- Array, can contain multiple assets
["vehiclesGunboats", ["B_Boat_Armed_01_minigun_F"]] call _saveToTemplate; 			//this line determines gun boats -- Example: ["vehiclesGunboats", ["B_Boat_Armed_01_minigun_F"]] -- Array, can contain multiple assets
["vehiclesAmphibious", ["B_APC_Wheeled_01_cannon_F"]] call _saveToTemplate; 		//this line determines amphibious vehicles  -- Example: ["vehiclesAmphibious", ["B_APC_Wheeled_01_cannon_F"]] -- Array, can contain multiple assets

["vehiclesPlanesCAS", ["B_Plane_CAS_01_dynamicLoadout_F"]] call _saveToTemplate; 		//this line determines CAS planes -- Example: ["vehiclesPlanesCAS", ["B_Plane_CAS_01_dynamicLoadout_F"]] -- Array, can contain multiple assets
["vehiclesPlanesAA", ["B_Plane_Fighter_01_F"]] call _saveToTemplate; 			//this line determines air supperiority planes -- Example: ["vehiclesPlanesAA", ["B_Plane_Fighter_01_F"]] -- Array, can contain multiple assets
["vehiclesPlanesTransport", [B_T_VTOL_01_infantry_F"]] call _saveToTemplate; 	//this line determines transport planes -- Example: ["vehiclesPlanesTransport", ["B_T_VTOL_01_infantry_F"]] -- Array, can contain multiple assets

["vehiclesHelisLight", ["B_Heli_Light_01_F"]] call _saveToTemplate; 		//this line determines light helis -- Example: ["vehiclesHelisLight", ["B_Heli_Light_01_F"]] -- Array, can contain multiple assets
["vehiclesHelisTransport", ["B_Heli_Transport_01_F"]] call _saveToTemplate; 	//this line determines transport helis -- Example: ["vehiclesHelisTransport", ["B_Heli_Transport_01_F"]] -- Array, can contain multiple assets
["vehiclesHelisAttack", ["B_Heli_Attack_01_F"]] call _saveToTemplate; 		//this line determines attack helis -- Example: ["vehiclesHelisAttack", ["B_Heli_Attack_01_F"]] -- Array, can contain multiple assets

["vehiclesArtillery", ["B_MBT_01_arty_F"]] call _saveToTemplate; 		//this line determines artillery vehicles -- Example: ["vehiclesArtillery", ["B_MBT_01_arty_F"]] -- Array, can contain multiple assets

["uavsAttack", ["B_UAV_02_CAS_F"]] call _saveToTemplate; 				//this line determines attack UAVs -- Example: ["uavsAttack", ["B_UAV_02_CAS_F"]] -- Array, can contain multiple assets
["uavsPortable", ["B_UAV_01_F"]] call _saveToTemplate; 				//this line determines portable UAVs -- Example: ["uavsPortable", ["B_UAV_01_F"]] -- Array, can contain multiple assets

//Config special vehicles - militia vehicles are mostly used in the early game, police cars are being used by troops around cities
["vehiclesMilitiaLightArmed", [B_G_Offroad_01_armed_F"]] call _saveToTemplate; //this line determines lightly armed militia vehicles -- Example: ["vehiclesMilitiaLightArmed", ["B_G_Offroad_01_armed_F"]] -- Array, can contain multiple assets
["vehiclesMilitiaTrucks", ["B_G_Van_01_transport_F"]] call _saveToTemplate; 	//this line determines militia trucks (unarmed) -- Example: ["vehiclesMilitiaTrucks", ["B_G_Van_01_transport_F"]] -- Array, can contain multiple assets
["vehiclesMilitiaCars", ["B_G_Offroad_01_F"]] call _saveToTemplate; 		//this line determines militia cars (unarmed) -- Example: ["vehiclesMilitiaCars", ["	B_G_Offroad_01_F"]] -- Array, can contain multiple assets

["vehiclesPolice", ["B_GEN_Offroad_01_gen_F"]] call _saveToTemplate; 			//this line determines police cars -- Example: ["vehiclesPolice", ["B_GEN_Offroad_01_gen_F"]] -- Array, can contain multiple assets

//Static weapon definitions
["staticMG", ["B_HMG_01_high_F"]] call _saveToTemplate; 					//this line determines static MGs -- Example: ["staticMG", ["B_HMG_01_high_F"]] -- Array, can contain multiple assets
["staticAT", ["B_static_AT_F"]] call _saveToTemplate; 					//this line determinesstatic ATs -- Example: ["staticAT", ["B_static_AT_F"]] -- Array, can contain multiple assets
["staticAA", ["B_static_AA_F"]] call _saveToTemplate; 					//this line determines static AAs -- Example: ["staticAA", ["B_static_AA_F"]] -- Array, can contain multiple assets
["staticMortar", ["B_Mortar_01_F"]] call _saveToTemplate; 				//this line determines static mortars -- Example: ["staticMortar", ["B_Mortar_01_F"]] -- Array, can contain multiple assets

["mortarMagazineHE", "8Rnd_82mm_Mo_shells"] call _saveToTemplate; 			//this line determines available HE-shells for the static mortars - !needs to be comtible with the mortar! -- Example: ["mortarMagazineHE", "8Rnd_82mm_Mo_shells"] - ENTER ONLY ONE OPTION
["mortarMagazineSmoke", "8Rnd_82mm_Mo_Smoke_white"] call _saveToTemplate; 		//this line determines smoke-shells for the static mortar - !needs to be comtible with the mortar! -- Example: ["mortarMagazineSmoke", "8Rnd_82mm_Mo_Smoke_white"] - ENTER ONLY ONE OPTION

["packableMG", ["B_HMG_01_high_F"]] call _saveToTemplate; 				//this line determines packable static MGs -- Example: ["packableMG", ["B_HMG_01_high_F"]] -- Array, can contain multiple assets
["packableAT", ["B_static_AT_F"]] call _saveToTemplate; 				//this line determines packable static ATs -- Example: ["packableAT", ["B_static_AT_F"]] -- Array, can contain multiple assets
["packableMortar", ["B_Mortar_01_F"]] call _saveToTemplate; 			//this line determines packable static mortars -- Example: ["packableMortar", ["B_Mortar_01_F"]] -- Array, can contain multiple assets

//Minefield definition
["minefieldAT", ["ATMine_Range_Mag"]] call _saveToTemplate; 				//this line determines AT mines used for spawning in minefields -- Example: ["minefieldAT", ["ATMine_Range_Mag"]] -- Array, can contain multiple assets
["minefieldAPERS", ["APERSMine_Range_Mag"]] call _saveToTemplate; 			//this line determines APERS mines used for spawning in minefields -- Example: ["minefieldAPERS", ["APERSMine_Range_Mag"]] -- Array, can contain multiple assets

//PvP definitions
["playerDefaultLoadout", $PLAYER_DEFAULT_LOADOUT$] call _saveToTemplate;//this and PvP could be made from below, unarmed for spawn, PvP from role loadouts - don't touch as it's automation
["pvpLoadouts", $PVP_LOADOUTS$] call _saveToTemplate; 	//don't touch as it's automation
["pvpVehicles", ["B_MRAP_01_F","B_MRAP_01_hmg_F"]] call _saveToTemplate; 				//this line determines the vehicles PvP players can spawn in -- Example: ["pvpVehicles", ["B_MRAP_01_F","B_MRAP_01_hmg_F"]] -- Array, can contain multiple assets


//////////////////////////
//       Loadouts       //
//////////////////////////
private _loadoutData = call _createLoadoutData;			// touch and shit breaks
_loadoutData setVariable ["rifles", ["arifle_MX_F","arifle_MX_pointer_F","arifle_MX_Holo_pointer_F","arifle_MX_Hamr_pointer_F","arifle_MX_ACO_pointer_F","arifle_MX_ACO_F"]]; 				//this line determines rifles -- Example: ["arifle_MX_F","arifle_MX_pointer_F"] -- Array, can contain multiple assets
_loadoutData setVariable ["carbines", ["arifle_MXC_F","arifle_MXC_Holo_F","arifle_MXC_Holo_pointer_F","arifle_MXC_ACO_F","arifle_MXC_ACO_pointer_F"]]; 				//this line determines carbines -- Example: ["arifle_MXC_F","arifle_MXC_Holo_F"] -- Array, can contain multiple assets
_loadoutData setVariable ["grenadeLaunchers", ["arifle_MXC_F","arifle_MX_GL_ACO_F","arifle_MX_GL_ACO_pointer_F","arifle_MX_GL_Hamr_pointer_F"]]; 		//this line determines grenade launchers -- Example: ["arifle_MX_GL_ACO_F","arifle_MX_GL_ACO_pointer_F"] -- Array, can contain multiple assets
_loadoutData setVariable ["SMGs", ["SMG_01_F","SMG_01_Holo_F","SMG_01_Holo_pointer_snds_F","SMG_01_ACO_F","SMG_03_khaki","SMG_03C_khaki","SMG_03_TR_khaki"]]]; 					//this line determines SMGs -- Example: ["SMG_01_F","SMG_01_Holo_F"] -- Array, can contain multiple assets
_loadoutData setVariable ["machineGuns", ["arifle_MX_SW_F","arifle_MX_SW_Hamr_pointer_F", "MMG_02_camo_F","MMG_02_sand_F","MMG_02_sand_RCO_LP_F"]]; 			//this line determines machine guns -- Example: ["arifle_MX_SW_F","arifle_MX_SW_Hamr_pointer_F"] -- Array, can contain multiple assets
_loadoutData setVariable ["marksmanRifles", ["arifle_MXM_F","arifle_MXM_Hamr_pointer_F","arifle_MXM_SOS_pointer_F","arifle_MXM_DMS_F"]]; 		//this line determines markman rifles -- Example: ["arifle_MXM_F","arifle_MXM_Hamr_pointer_F"] -- Array, can contain multiple assets
_loadoutData setVariable ["sniperRifles", ["srifle_LRR_camo_F","srifle_LRR_camo_SOS_F","srifle_LRR_camo_LRPS_F"]]; 			//this line determines sniper rifles -- Example: ["srifle_LRR_camo_F","srifle_LRR_camo_SOS_F"] -- Array, can contain multiple assets
_loadoutData setVariable ["lightATLaunchers", ["launch_NLAW_F"]]; 		//this line determines light AT launchers -- Example: ["launch_NLAW_F"] -- Array, can contain multiple assets
_loadoutData setVariable ["ATLaunchers", ["launch_NLAW_F"]]; 			//this line determines light AT launchers -- Example: ["launch_NLAW_F"] -- Array, can contain multiple assets
_loadoutData setVariable ["missileATLaunchers", ["launch_B_Titan_short_F"]]; 	//this line determines missile AT launchers -- Example: ["launch_B_Titan_short_F"] -- Array, can contain multiple assets
_loadoutData setVariable ["AALaunchers", ["launch_B_Titan_F"]]; 			//this line determines AA launchers -- Example: ["launch_B_Titan_F"] -- Array, can contain multiple assets
_loadoutData setVariable ["sidearms", ["hgun_Pistol_heavy_01_F", "hgun_P07_F"]]; 				//this line determines handguns/sidearms -- Example: ["hgun_Pistol_heavy_01_F", "hgun_P07_F"] -- Array, can contain multiple assets

_loadoutData setVariable ["ATMines", ["ATMine_Range_Mag"]]; 				//this line determines the AT mines which can be carried by units -- Example: ["ATMine_Range_Mag"] -- Array, can contain multiple assets
_loadoutData setVariable ["APMines", ["APERSMine_Range_Mag"]]; 				//this line determines the APERS mines which can be carried by units -- Example: ["APERSMine_Range_Mag"] -- Array, can contain multiple assets
_loadoutData setVariable ["lightExplosives", ["DemoCharge_Remote_Mag"]]; 		//this line determines light explosives -- Example: ["DemoCharge_Remote_Mag"] -- Array, can contain multiple assets
_loadoutData setVariable ["heavyExplosives", ["SatchelCharge_Remote_Mag"]]; 		//this line determines heavy explosives -- Example: ["SatchelCharge_Remote_Mag"] -- Array, can contain multiple assets

_loadoutData setVariable ["antiInfantryGrenades", ["HandGrenade","MiniGrenade"]]; 	//this line determines anti infantry grenades (frag and such) -- Example: ["HandGrenade","MiniGrenade"] -- Array, can contain multiple assets
_loadoutData setVariable ["antiTankGrenades", []]; 		//this line determines anti tank grenades. Leave empty when not available. -- Array, can contain multiple assets
_loadoutData setVariable ["smokeGrenades", ["SmokeShell", "SmokeShellRed", "SmokeShellGreen", "SmokeShellYellow", "SmokeShellPurple", "SmokeShellBlue", "SmokeShellOrange"]]; 		//this line determines smoke grenades -- Example: ["SmokeShell", "SmokeShellRed"] -- Array, can contain multiple assets

_loadoutData setVariable ["NVGs", []]; 					//this line determines NVGs -- Array, can contain multiple assets

_loadoutData setVariable ["uniforms", ["U_B_CombatUniform_mcam","U_B_CombatUniform_mcam_tshirt", "U_B_CombatUniform_mcam_vest"]];
_loadoutData setVariable ["vests", ["V_PlateCarrierSpec_mtp","V_PlateCarrierGL_mtp"]];
_loadoutData setVariable ["backpacks", ["B_AssaultPack_mcamo","B_Kitbag_mcamo","B_TacticalPack_mcamo","B_Carryall_mcamo"]];
_loadoutData setVariable ["helmets", ["H_MilCap_mcamo","H_Booniehat_mcamo","H_HelmetB_camo","H_HelmetB_desert","H_HelmetB_sand"]];

////////////////////////////////
//  Special Forces Loadouts   //
////////////////////////////////
private _sfLoadoutData = _loadoutData call _copyLoadoutData; // touch and shit breaks
_sfLoadoutData setVariable ["uniforms", ["U_B_CombatUniform_mcam","U_B_CombatUniform_mcam_tshirt", "U_B_CombatUniform_mcam_vest"]];			//this line determines uniforms for special forces -- Example: ["U_B_CombatUniform_mcam","U_B_CombatUniform_mcam_tshirt"] -- Array, can contain multiple assets
_sfLoadoutData setVariable ["vests", ["V_PlateCarrierSpec_mtp","V_PlateCarrierGL_mtp"]];				//this line determines vests for special forces -- Example: ["V_PlateCarrierSpec_mtp","V_PlateCarrierGL_mtp"] -- Array, can contain multiple assets
_sfLoadoutData setVariable ["backpacks", ["B_AssaultPack_mcamo","B_Kitbag_mcamo","B_TacticalPack_mcamo","B_Carryall_mcamo"]];			//this line determines backpacks for special forces -- Example: ["B_AssaultPack_mcamo","B_Kitbag_mcamo"] -- Array, can contain multiple assets
_sfLoadoutData setVariable ["helmets", ["H_HelmetB_camo","H_HelmetB_desert","H_HelmetB_sand"]];				//this line determines helmets for special forces -- Example: ["H_HelmetB_camo","H_HelmetB_desert"] -- Array, can contain multiple assets

//The following lines are determining the calls for template creation. Don't touch them.
["loadouts_SF_SquadLeader", [_sfLoadoutData] call A3A_fnc_createSquadLeaderLoadouts] call _saveToTemplate; //don't touch as it's automation
["loadouts_SF_Rifleman", [_sfLoadoutData] call A3A_fnc_createRiflemanLoadouts] call _saveToTemplate; //don't touch as it's automation
["loadouts_SF_Medic", [_sfLoadoutData] call A3A_fnc_createMedicLoadouts] call _saveToTemplate; //don't touch as it's automation
["loadouts_SF_Engineer", [_sfLoadoutData] call A3A_fnc_createEngineerLoadouts] call _saveToTemplate; //don't touch as it's automation
["loadouts_SF_ExplosivesExpert", [_sfLoadoutData] call A3A_fnc_createExplosivesExpertLoadouts] call _saveToTemplate; //don't touch as it's automation
["loadouts_SF_Grenadier", [_sfLoadoutData] call A3A_fnc_createGrenadierLoadouts] call _saveToTemplate; //don't touch as it's automation
["loadouts_SF_LAT", [_sfLoadoutData] call A3A_fnc_createAntiTankLoadouts] call _saveToTemplate; //don't touch as it's automation
["loadouts_SF_AT", [_sfLoadoutData] call A3A_fnc_createAntiTankLoadouts] call _saveToTemplate; //don't touch as it's automation
["loadouts_SF_AA", [_sfLoadoutData] call A3A_fnc_createAntiAirLoadouts] call _saveToTemplate; //don't touch as it's automation
["loadouts_SF_ATAmmoBearers", [_sfLoadoutData, ("loadouts_SF_AT" call _getFromTemplate)] call A3A_fnc_createAmmoBearerLoadouts] call _saveToTemplate;//don't touch as it's automation
["loadouts_SF_AAAmmoBearers", [_sfLoadoutData, ("loadouts_SF_AA" call _getFromTemplate)] call A3A_fnc_createAmmoBearerLoadouts] call _saveToTemplate;//don't touch as it's automation
["loadouts_SF_MachineGunner", [_sfLoadoutData] call A3A_fnc_createMachineGunnerLoadouts] call _saveToTemplate; //don't touch as it's automation
["loadouts_SF_Marksman", [_sfLoadoutData] call A3A_fnc_createMarksmanLoadouts] call _saveToTemplate; //don't touch as it's automation
["loadouts_SF_Sniper", [_sfLoadoutData] call A3A_fnc_createSniperLoadouts] call _saveToTemplate; //don't touch as it's automation

//////////////////////////
//  Military Loadouts   //
//////////////////////////
private _militaryLoadoutData = _loadoutData call _copyLoadoutData; // touch and shit breaks
_militaryLoadoutData setVariable ["uniforms", ["U_B_CombatUniform_mcam","U_B_CombatUniform_mcam_tshirt", "U_B_CombatUniform_mcam_vest"]];		//this line determines uniforms for military loadouts -- Example: ["U_B_CombatUniform_mcam","U_B_CombatUniform_mcam_tshirt"] -- Array, can contain multiple assets
_militaryLoadoutData setVariable ["vests", ["V_PlateCarrierSpec_mtp","V_PlateCarrierGL_mtp"]];			//this line determines vests for military loadouts -- Example: ["V_PlateCarrierSpec_mtp","V_PlateCarrierGL_mtp"] -- Array, can contain multiple assets
_militaryLoadoutData setVariable ["backpacks", ["B_AssaultPack_mcamo","B_Kitbag_mcamo","B_TacticalPack_mcamo","B_Carryall_mcamo"]];		//this line determines backpacks for military loadouts -- Example: ["B_AssaultPack_mcamo","B_Kitbag_mcamo"] -- Array, can contain multiple assets
_militaryLoadoutData setVariable ["helmets", ["H_HelmetB_camo","H_HelmetB_desert","H_HelmetB_sand"]];		//this line determines helmets for military loadouts -- Example: ["H_HelmetB_camo","H_HelmetB_desert"] -- Array, can contain multiple assets

//The following lines are determining the calls for template creation. Don't touch them.
["loadouts_military_SquadLeader", [_militaryLoadoutData] call A3A_fnc_createSquadLeaderLoadouts] call _saveToTemplate; //don't touch as it's automation
["loadouts_military_Rifleman", [_militaryLoadoutData] call A3A_fnc_createRiflemanLoadouts] call _saveToTemplate; //don't touch as it's automation
["loadouts_military_Medic", [_militaryLoadoutData] call A3A_fnc_createMedicLoadouts] call _saveToTemplate; //don't touch as it's automation
["loadouts_military_Engineer", [_militaryLoadoutData] call A3A_fnc_createEngineerLoadouts] call _saveToTemplate; //don't touch as it's automation
["loadouts_military_ExplosivesExpert", [_militaryLoadoutData] call A3A_fnc_createExplosivesExpertLoadouts] call _saveToTemplate; //don't touch as it's automation
["loadouts_military_Grenadier", [_militaryLoadoutData] call A3A_fnc_createGrenadierLoadouts] call _saveToTemplate; //don't touch as it's automation
["loadouts_military_LAT", [_militaryLoadoutData] call A3A_fnc_createAntiTankLoadouts] call _saveToTemplate; //don't touch as it's automation
["loadouts_military_AT", [_militaryLoadoutData] call A3A_fnc_createAntiTankLoadouts] call _saveToTemplate; //don't touch as it's automation
["loadouts_military_AA", [_militaryLoadoutData] call A3A_fnc_createAntiAirLoadouts] call _saveToTemplate; //don't touch as it's automation
["loadouts_military_ATAmmoBearers", [_militaryLoadoutData, ("loadouts_military_AT" call _getFromTemplate)] call A3A_fnc_createAmmoBearerLoadouts] call _saveToTemplate;//don't touch as it's automation
["loadouts_military_AAAmmoBearers", [_militaryLoadoutData, ("loadouts_military_AA" call _getFromTemplate)] call A3A_fnc_createAmmoBearerLoadouts] call _saveToTemplate;//don't touch as it's automation
["loadouts_military_MachineGunner", [_militaryLoadoutData] call A3A_fnc_createMachineGunnerLoadouts] call _saveToTemplate; //don't touch as it's automation
["loadouts_military_Marksman", [_militaryLoadoutData] call A3A_fnc_createMarksmanLoadouts] call _saveToTemplate; //don't touch as it's automation
["loadouts_military_Sniper", [_militaryLoadoutData] call A3A_fnc_createSniperLoadouts] call _saveToTemplate; //don't touch as it's automation

////////////////////////////
//    Police Loadouts     //
////////////////////////////
private _policeLoadoutData = _loadoutData call _copyLoadoutData; // touch and shit breaks
_policeLoadoutData setVariable ["uniforms", ["U_B_GEN_Commander_F"]];		//this line determines uniforms for police loadouts -- Example: ["U_B_GEN_Commander_F"] -- Array, can contain multiple assets
_policeLoadoutData setVariable ["vests", ["V_TacVest_gen_F"]];			//this line determines vests for police loadouts -- Example: ["V_TacVest_gen_F"] -- Array, can contain multiple assets
_policeLoadoutData setVariable ["backpacks", []];		//this line determines backpacks for police loadouts -- Example: ["B_Kitbag_mcamo"] -- Array, can contain multiple assets
_policeLoadoutData setVariable ["helmets", ["H_Beret_gen_F"]];			//this line determines helmets for police loadouts -- Example: ["H_Beret_gen_F"] -- Array, can contain multiple assets

//The following lines are determining the calls for template creation. Don't touch them.
["loadouts_police_SquadLeader", [_policeLoadoutData] call A3A_fnc_createSquadLeaderLoadouts] call _saveToTemplate; //don't touch as it's automation
["loadouts_police_Standard", [_policeLoadoutData] call A3A_fnc_createPoliceLoadouts] call _saveToTemplate; //don't touch as it's automation

////////////////////////////
//    Militia Loadouts    //
////////////////////////////
private _militiaLoadoutData = _loadoutData call _copyLoadoutData; // touch and shit breaks
_militiaLoadoutData setVariable ["uniforms", ["U_B_CombatUniform_mcam","U_B_CombatUniform_mcam_tshirt", "U_B_CombatUniform_mcam_vest"]];		//this line determines uniforms for militia loadouts -- Example: ["U_B_CombatUniform_mcam","U_B_CombatUniform_mcam_tshirt"] -- Array, can contain multiple assets
_militiaLoadoutData setVariable ["vests", ["V_PlateCarrierSpec_mtp","V_PlateCarrierGL_mtp"]];			//this line determines vests for militia loadouts -- Example: ["V_PlateCarrierSpec_mtp","V_PlateCarrierGL_mtp"] -- Array, can contain multiple assets
_militiaLoadoutData setVariable ["backpacks", ["B_AssaultPack_mcamo","B_Kitbag_mcamo","B_TacticalPack_mcamo","B_Carryall_mcamo"]];		//this line determines backpacks for militia loadouts -- Example: ["B_AssaultPack_mcamo","B_Kitbag_mcamo"] -- Array, can contain multiple assets
_militiaLoadoutData setVariable ["helmets", ["H_HelmetB_camo","H_HelmetB_desert","H_HelmetB_sand"]];		//this line determines helmets for police loadouts -- Example: ["H_HelmetB_camo","H_HelmetB_desert"] -- Array, can contain multiple assets

//The following lines are determining the calls for template creation. Don't touch them.
["loadouts_militia_Rifleman", [_militiaLoadoutData] call A3A_fnc_createRiflemanLoadouts] call _saveToTemplate; //don't touch as it's automation
["loadouts_militia_Marksman", [_militiaLoadoutData] call A3A_fnc_createMarksmanLoadouts] call _saveToTemplate; //don't touch as it's automation

//////////////////////////
//    Misc Loadouts     //
//////////////////////////
//The following lines are determining the loadout of the vehicle crew
private _crewLoadoutData = _militaryLoadoutData call _copyLoadoutData; // touch and shit breaks
_sfLoadoutData setVariable ["uniforms", ["U_B_CombatUniform_mcam_tshirt"]];
_sfLoadoutData setVariable ["helmets", ["H_HelmetCrew_B"]];
["loadouts_Crew", [_crewLoadoutData] call A3A_fnc_createMinimalArmedLoadouts] call _saveToTemplate; //don't touch as it's automation

//The following lines are determining the loadout of the pilots
private _pilotLoadoutData = _militaryLoadoutData call _copyLoadoutData; // touch and shit breaks
_sfLoadoutData setVariable ["uniforms", ["U_B_HeliPilotCoveralls"]];
_sfLoadoutData setVariable ["helmets", ["H_PilotHelmetHeli_B"]];
["loadouts_Pilot", [_pilotLoadoutData] call A3A_fnc_createMinimalArmedLoadouts] call _saveToTemplate; //don't touch as it's automation

//The following lines are determining the loadout for the unit used in the "kill the official" mission
["loadouts_Official", [_militaryLoadoutData] call A3A_fnc_createMinimalArmedLoadouts] call _saveToTemplate; //don't touch as it's automation

//The following lines are determining the loadout for the AI used in the "kill the traitor" mission
["loadouts_Traitor", [_militiaLoadoutData] call A3A_fnc_createMinimalArmedLoadouts] call _saveToTemplate; //don't touch as it's automation
