///////////////////////////
//   Rebel Information   //
///////////////////////////

["name", ""] call _fnc_saveToTemplate; 						//this line determines the faction name -- Example: ["name", "NATO"] - ENTER ONLY ONE OPTION

["flag", ""] call _fnc_saveToTemplate; 						//this line determines the flag -- Example: ["flag", "Flag_NATO_F"] - ENTER ONLY ONE OPTION
["flagTexture", ""] call _fnc_saveToTemplate; 				//this line determines the flag texture -- Example: ["flagTexture", "\A3\Data_F\Flags\Flag_NATO_CO.paa"] - ENTER ONLY ONE OPTION
["flagMarkerType", ""] call _fnc_saveToTemplate; 			//this line determines the flag marker type -- Example: ["flagMarkerType", "flag_NATO"] - ENTER ONLY ONE OPTION

["vehicleBasic", ""] call _fnc_saveToTemplate; 			//this line determines basic vehicles, the lightest kind available. -- Example: ["vehiclesBasic", ["B_Quadbike_01_F"]] -- Array, can contain multiple assets
["vehicleLightUnarmed", ""] call _fnc_saveToTemplate; 		//this line determines light and unarmed vehicles. -- Example: ["vehiclesLightUnarmed", ["B_MRAP_01_F"]] -- Array, can contain multiple assets
["vehicleLightArmed", ""] call _fnc_saveToTemplate; 		//this line determines light and armed vehicles -- Example: ["vehiclesLightArmed",["B_MRAP_01_hmg_F","B_MRAP_01_gmg_F"]] -- Array, can contain multiple assets
["vehicleTruck", ""] call _fnc_saveToTemplate; 			//this line determines the trucks -- Example: ["vehiclesTrucks", ["B_Truck_01_transport_F","B_Truck_01_covered_F"]] -- Array, can contain multiple assets
["vehicleAT", ""] call _fnc_saveToTemplate; 		//this line determines cargo trucks -- Example: ["vehiclesCargoTrucks", ["B_Truck_01_transport_F","B_Truck_01_covered_F"]] -- Array, can contain multiple assets

["vehicleBoats", ""] call _fnc_saveToTemplate; 	//this line determines transport boats -- Example: ["vehiclesTransportBoats", ["B_Boat_Transport_01_F"]] -- Array, can contain multiple assets
["vehicleRepair", ""] call _fnc_saveToTemplate; 			//this line determines gun boats -- Example: ["vehiclesGunboats", ["B_Boat_Armed_01_minigun_F"]] -- Array, can contain multiple assets

["vehiclePlane", ""] call _fnc_saveToTemplate; 		//this line determines CAS planes -- Example: ["vehiclesPlanesCAS", ["B_Plane_CAS_01_dynamicLoadout_F"]] -- Array, can contain multiple assets
["vehicleHeli", ""] call _fnc_saveToTemplate; 		//this line determines light helis -- Example: ["vehiclesHelisLight", ["B_Heli_Light_01_F"]] -- Array, can contain multiple assets

["staticMG", ""] call _fnc_saveToTemplate; 					//this line determines static MGs -- Example: ["staticMG", ["B_HMG_01_high_F"]] -- Array, can contain multiple assets
["staticAT", ""] call _fnc_saveToTemplate; 					//this line determinesstatic ATs -- Example: ["staticAT", ["B_static_AT_F"]] -- Array, can contain multiple assets
["staticAA", ""] call _fnc_saveToTemplate; 					//this line determines static AAs -- Example: ["staticAA", ["B_static_AA_F"]] -- Array, can contain multiple assets
["staticMortar", ""] call _fnc_saveToTemplate; 				//this line determines static mortars -- Example: ["staticMortar", ["B_Mortar_01_F"]] -- Array, can contain multiple assets

//Static weapon definitions
["packableMG", ""] call _fnc_saveToTemplate; 				//this line determines packable static MGs -- Example: ["packableMG", ["B_HMG_01_high_F"]] -- Array, can contain multiple assets
["packableAT", ""] call _fnc_saveToTemplate; 				//this line determines packable static ATs -- Example: ["packableAT", ["B_static_AT_F"]] -- Array, can contain multiple assets
["packableAA", ""] call _fnc_saveToTemplate; 				//this line determines packable static ATs -- Example: ["packableAT", ["B_static_AT_F"]] -- Array, can contain multiple assets
["packableMortar", ""] call _fnc_saveToTemplate; 			//this line determines packable static mortars -- Example: ["packableMortar", ["B_Mortar_01_F"]] -- Array, can contain multiple assets

["mineAT", ""] call _fnc_saveToTemplate; 				//this line determines AT mines used for spawning in minefields -- Example: ["minefieldAT", ["ATMine_Range_Mag"]] -- Array, can contain multiple assets
["mineAPERS", ""] call _fnc_saveToTemplate; 			//this line determines APERS mines used for spawning in minefields -- Example: ["minefieldAPERS", ["APERSMine_Range_Mag"]] -- Array, can contain multiple assets

["breachingExplosivesAPC", []] call _fnc_saveToTemplate;
["breachingExplosivesTank", []] call _fnc_saveToTemplate;

//////////////////////////
//       Loadouts       //
//////////////////////////
private _loadoutData = call _fnc_createLoadoutData;
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


//The following lines are determining the loadout of the Rebel commander (Petros)
["loadouts_Petros", [_loadoutData] call A3A_fnc_createSquadLeaderLoadouts] call _fnc_saveToTemplate; //don't touch as it's automation

//The following lines are determining the loadout of the Rebel SquadLeader
["loadouts_SquadLeader", [_loadoutData] call A3A_fnc_createSquadLeaderLoadouts] call _fnc_saveToTemplate; //don't touch as it's automation
//The following lines are determining the loadout of the Rebel Rifleman
["loadouts_Rifleman", [_loadoutData] call A3A_fnc_createRiflemanLoadouts] call _fnc_saveToTemplate; //don't touch as it's automation
//The following lines are determining the loadout of the Rebel Medic
["loadouts_Medic", [_loadoutData] call A3A_fnc_createMedicLoadouts] call _fnc_saveToTemplate; //don't touch as it's automation
//The following lines are determining the loadout of the Rebel Engineer
["loadouts_Engineer", [_loadoutData] call A3A_fnc_createEngineerLoadouts] call _fnc_saveToTemplate; //don't touch as it's automation
//The following lines are determining the loadout of the Rebel Explosives Expert
["loadouts_ExplosivesExpert", [_loadoutData] call A3A_fnc_createExplosivesExpertLoadouts] call _fnc_saveToTemplate; //don't touch as it's automation
//The following lines are determining the loadout of the Rebel Grenadier
["loadouts_Grenadier", [_loadoutData] call A3A_fnc_createGrenadierLoadouts] call _fnc_saveToTemplate; //don't touch as it's automation
//The following lines are determining the loadout of the Rebel AT unit
["loadouts_AT", [_loadoutData] call A3A_fnc_createAntiTankLoadouts] call _fnc_saveToTemplate; //don't touch as it's automation
//The following lines are determining the loadout of the Rebel Machinegunner unit
["loadouts_MachineGunner", [_loadoutData] call A3A_fnc_createMachineGunnerLoadouts] call _fnc_saveToTemplate; //don't touch as it's automation
//The following lines are determining the loadout of the Rebel Sniper unit
["loadouts_military_Sniper", [_loadoutData] call A3A_fnc_createSniperLoadouts] call _fnc_saveToTemplate; //don't touch as it's automation


///////////////////////////
//  Rebel Starting Gear  //
///////////////////////////

private _initialRebelEquipment = [];
if (hasTFAR) then {initialRebelEquipment append ["tf_microdagr","tf_anprc154"]};
//if (hasTFAR && startWithLongRangeRadio) then {initialRebelEquipment pushBack "LONG_RANGE_RADIO"};

["initialRebelEquipment", _initialRebelEquipment] call _fnc_saveToTemplate;