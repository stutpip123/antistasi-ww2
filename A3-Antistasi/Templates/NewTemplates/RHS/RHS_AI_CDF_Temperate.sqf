//////////////////////////
//   Side Information   //
//////////////////////////

["name", "CDF"] call _fnc_saveToTemplate; 						//this line determines the faction name -- Example: ["name", "NATO"] - ENTER ONLY ONE OPTION
["spawnMarkerName", "CDF support corridor"] call _fnc_saveToTemplate; 			//this line determines the name tag for the "carrier" on the map -- Example: ["spawnMarkerName", "NATO support corridor"] - ENTER ONLY ONE OPTION

["flag", "Flag_AltisColonial_F"] call _fnc_saveToTemplate; 						//this line determines the flag -- Example: ["flag", "Flag_NATO_F"] - ENTER ONLY ONE OPTION
["flagTexture", "\rhsgref\addons\rhsgref_main\data\Flags\flag_cdf_co.paa"] call _fnc_saveToTemplate; 				//this line determines the flag texture -- Example: ["flagTexture", "\A3\Data_F\Flags\Flag_NATO_CO.paa"] - ENTER ONLY ONE OPTION
["flagMarkerType", "rhs_flag_insurgents"] call _fnc_saveToTemplate; 			//this line determines the flag marker type -- Example: ["flagMarkerType", "flag_NATO"] - ENTER ONLY ONE OPTION

//////////////////////////
//       Vehicles       //
//////////////////////////

["ammobox", "B_supplyCrate_F"] call _fnc_saveToTemplate; 	//Don't touch or you die a sad and lonely death!

["vehiclesBasic", ["I_Quadbike_01_F"]] call _fnc_saveToTemplate; 			//this line determines basic vehicles, the lightest kind available. -- Example: ["vehiclesBasic", ["B_Quadbike_01_F"]] -- Array, can contain multiple assets
["vehiclesLightUnarmed", ["rhsgref_cdf_b_reg_uaz","rhsgref_cdf_b_reg_uaz_open","rhsgref_BRDM2UM_b"]] call _fnc_saveToTemplate; 		//this line determines light and unarmed vehicles. -- Example: ["vehiclesLightUnarmed", ["B_MRAP_01_F"]] -- Array, can contain multiple assets
["vehiclesLightArmed",["rhsgref_cdf_b_reg_uaz_ags","rhsgref_cdf_b_reg_uaz_dshkm","rhsgref_BRDM2_b","rhsgref_BRDM2_ATGM_b","rhsgref_BRDM2_HQ_b"]] call _fnc_saveToTemplate; 		//this line determines light and armed vehicles -- Example: ["vehiclesLightArmed",["B_MRAP_01_hmg_F","B_MRAP_01_gmg_F"]] -- Array, can contain multiple assets
["vehiclesTrucks", ["rhsgref_cdf_b_gaz66","rhsgref_cdf_b_gaz66_flat","rhsgref_cdf_b_gaz66o","rhsgref_cdf_b_gaz66o_flat","rhsgref_cdf_b_ural","rhsgref_cdf_b_ural_open","rhsgref_cdf_b_zil131","rhsgref_cdf_b_zil131_flatbed_cover","rhsgref_cdf_b_zil131_open","rhsgref_cdf_b_zil131_flatbed"]] call _fnc_saveToTemplate; 			//this line determines the trucks -- Example: ["vehiclesTrucks", ["B_Truck_01_transport_F","B_Truck_01_covered_F"]] -- Array, can contain multiple assets
["vehiclesCargoTrucks", ["rhsgref_cdf_b_gaz66","rhsgref_cdf_b_gaz66_flat","rhsgref_cdf_b_gaz66o","rhsgref_cdf_b_gaz66o_flat","rhsgref_cdf_b_ural","rhsgref_cdf_b_ural_open","rhsgref_cdf_b_zil131","rhsgref_cdf_b_zil131_flatbed_cover","rhsgref_cdf_b_zil131_open","rhsgref_cdf_b_zil131_flatbed"]] call _fnc_saveToTemplate; 		//this line determines cargo trucks -- Example: ["vehiclesCargoTrucks", ["B_Truck_01_transport_F","B_Truck_01_covered_F"]] -- Array, can contain multiple assets
["vehiclesAmmoTrucks", ["rhsgref_cdf_b_gaz66_ammo"]] call _fnc_saveToTemplate; 		//this line determines ammo trucks -- Example: ["vehiclesAmmoTrucks", ["B_Truck_01_ammo_F"]] -- Array, can contain multiple assets
["vehiclesRepairTrucks", ["rhsgref_cdf_b_gaz66_repair","rhsgref_cdf_b_ural_repair"]] call _fnc_saveToTemplate; 		//this line determines repair trucks -- Example: ["vehiclesRepairTrucks", ["B_Truck_01_Repair_F"]] -- Array, can contain multiple assets
["vehiclesFuelTrucks", ["rhsgref_cdf_b_ural_fuel"]] call _fnc_saveToTemplate;		//this line determines fuel trucks -- Array, can contain multiple assets
["vehiclesMedical", ["rhsgref_cdf_b_gaz66_ap2"]] call _fnc_saveToTemplate;			//this line determines medical vehicles -- Array, can contain multiple assets
["vehiclesAPCs", ["rhsgref_cdf_b_btr60","rhsgref_cdf_b_btr70","rhsgref_cdf_b_btr80","rhsgref_cdf_b_bmd1","rhsgref_cdf_b_bmd1k","rhsgref_cdf_b_bmd1p","rhsgref_cdf_b_bmd1pk","rhsgref_cdf_b_bmd2","rhsgref_cdf_b_bmd2k","rhsgref_cdf_b_bmp1","rhsgref_cdf_b_bmp1d","rhsgref_cdf_b_bmp1k","rhsgref_cdf_b_bmp1p","rhsgref_cdf_b_bmp2e","rhsgref_cdf_b_bmp2","rhsgref_cdf_b_bmp2d","rhsgref_cdf_b_bmp2k"]] call _fnc_saveToTemplate; 				//this line determines APCs -- Example: ["vehiclesAPCs", ["B_APC_Tracked_01_rcws_F","B_APC_Tracked_01_CRV_F"]] -- Array, can contain multiple assets
["vehiclesTanks", ["rhsgref_cdf_b_t72ba_tv","rhsgref_cdf_b_t72bb_tv","rhsgref_cdf_b_t80b_tv","rhsgref_cdf_b_t80bv_tv"]] call _fnc_saveToTemplate; 			//this line determines tanks -- Example: ["vehiclesTanks", ["B_MBT_01_cannon_F","B_MBT_01_TUSK_F"]] -- Array, can contain multiple assets
["vehiclesAA", ["rhsgref_cdf_b_ural_Zu23","rhsgref_cdf_b_gaz66_zu23","rhsgref_cdf_b_zsu234"]] call _fnc_saveToTemplate; 				//this line determines AA vehicles -- Example: ["vehiclesAA", ["B_APC_Tracked_01_AA_F"]] -- Array, can contain multiple assets

["vehiclesTransportBoats", ["B_Boat_Transport_01_F"]] call _fnc_saveToTemplate; 	//this line determines transport boats -- Example: ["vehiclesTransportBoats", ["B_Boat_Transport_01_F"]] -- Array, can contain multiple assets
["vehiclesGunBoats", ["rhsusf_mkvsoc"]] call _fnc_saveToTemplate; 			//this line determines gun boats -- Example: ["vehiclesGunboats", ["B_Boat_Armed_01_minigun_F"]] -- Array, can contain multiple assets
["vehiclesAmphibious", ["rhsgref_cdf_b_btr60","rhsgref_cdf_b_btr70","rhsgref_cdf_b_btr80","rhsgref_cdf_b_bmd1","rhsgref_cdf_b_bmd1k","rhsgref_cdf_b_bmd1p","rhsgref_cdf_b_bmd1pk","rhsgref_cdf_b_bmd2","rhsgref_cdf_b_bmd2k","rhsgref_cdf_b_bmp1","rhsgref_cdf_b_bmp1k","rhsgref_cdf_b_bmp1p","rhsgref_cdf_b_bmp2e","rhsgref_cdf_b_bmp2","rhsgref_cdf_b_bmp2k"]] call _fnc_saveToTemplate; 		//this line determines amphibious vehicles  -- Example: ["vehiclesAmphibious", ["B_APC_Wheeled_01_cannon_F"]] -- Array, can contain multiple assets

["vehiclesPlanesCAS", ["rhs_l159_cdf_b_CDF","rhsgref_cdf_b_su25","rhs_l159_cdf_b_CDF_plamen","rhs_l159_cdf_b_CDF_CAS"]] call _fnc_saveToTemplate; 		//this line determines CAS planes -- Example: ["vehiclesPlanesCAS", ["B_Plane_CAS_01_dynamicLoadout_F"]] -- Array, can contain multiple assets
["vehiclesPlanesAA", ["rhs_l159_cdf_b_CDF_CAP","rhsgref_cdf_b_mig29s"]] call _fnc_saveToTemplate; 			//this line determines air supperiority planes -- Example: ["vehiclesPlanesAA", ["B_Plane_Fighter_01_F"]] -- Array, can contain multiple assets
["vehiclesPlanesTransport", ["RHS_AN2_B"]] call _fnc_saveToTemplate; 	//this line determines transport planes -- Example: ["vehiclesPlanesTransport", ["B_T_VTOL_01_infantry_F"]] -- Array, can contain multiple assets

["vehiclesHelisLight", ["rhsgref_cdf_reg_Mi8amt"]] call _fnc_saveToTemplate; 		//this line determines light helis -- Example: ["vehiclesHelisLight", ["B_Heli_Light_01_F"]] -- Array, can contain multiple assets
["vehiclesHelisTransport", ["rhsgref_cdf_reg_Mi8amt"]] call _fnc_saveToTemplate; 	//this line determines transport helis -- Example: ["vehiclesHelisTransport", ["B_Heli_Transport_01_F"]] -- Array, can contain multiple assets
["vehiclesHelisAttack", ["rhsgref_cdf_b_Mi24D","rhsgref_cdf_b_Mi24D_Early","rhsgref_b_mi24g_CAS","rhsgref_cdf_b_Mi35","rhsgref_cdf_b_reg_Mi17Sh"]] call _fnc_saveToTemplate; 		//this line determines attack helis -- Example: ["vehiclesHelisAttack", ["B_Heli_Attack_01_F"]] -- Array, can contain multiple assets

["vehiclesArtillery", [
["rhsgref_cdf_b_reg_d30",["rhs_mag_3of56_10"]],
["rhsgref_cdf_b_2s1",["rhs_mag_3of56_10"]],
["rhsgref_cdf_b_reg_BM21", ["rhs_mag_m21of_1"]]
]] call _fnc_saveToTemplate; 		//this line determines artillery vehicles -- Example: ["vehiclesArtillery", [["B_MBT_01_arty_F", ["32Rnd_155mm_Mo_shells"]]]] -- Array, can contain multiple assets

["uavsAttack", ["B_UAV_02_dynamicLoadout_F"]] call _fnc_saveToTemplate; 				//this line determines attack UAVs -- Example: ["uavsAttack", ["B_UAV_02_CAS_F"]] -- Array, can contain multiple assets
["uavsPortable", ["B_UAV_01_F"]] call _fnc_saveToTemplate; 				//this line determines portable UAVs -- Example: ["uavsPortable", ["B_UAV_01_F"]] -- Array, can contain multiple assets

//Config special vehicles - militia vehicles are mostly used in the early game, police cars are being used by troops around cities -- Example:
["vehiclesMilitiaLightArmed", ["rhsgref_cdf_b_reg_uaz_ags","rhsgref_cdf_b_reg_uaz_dshkm","rhsgref_cdf_b_reg_uaz_spg9","rhsgref_BRDM2_b","rhsgref_BRDM2_HQ_b"]] call _fnc_saveToTemplate; //this line determines lightly armed militia vehicles -- Example: ["vehiclesMilitiaLightArmed", ["B_G_Offroad_01_armed_F"]] -- Array, can contain multiple assets
["vehiclesMilitiaTrucks", ["rhsgref_cdf_b_gaz66","rhsgref_cdf_b_gaz66_flat","rhsgref_cdf_b_gaz66o","rhsgref_cdf_b_gaz66o_flat"]] call _fnc_saveToTemplate; 	//this line determines militia trucks (unarmed) -- Example: ["vehiclesMilitiaTrucks", ["B_G_Van_01_transport_F"]] -- Array, can contain multiple assets
["vehiclesMilitiaCars", ["rhsgref_cdf_b_reg_uaz","rhsgref_cdf_b_reg_uaz_open","rhsgref_BRDM2UM_b"]] call _fnc_saveToTemplate; 		//this line determines militia cars (unarmed) -- Example: ["vehiclesMilitiaCars", ["	B_G_Offroad_01_F"]] -- Array, can contain multiple assets

["vehiclesPolice", ["B_GEN_Offroad_01_gen_F"]] call _fnc_saveToTemplate; 			//this line determines police cars -- Example: ["vehiclesPolice", ["B_GEN_Offroad_01_gen_F"]] -- Array, can contain multiple assets

["staticMGs", ["rhsgref_cdf_b_DSHKM"]] call _fnc_saveToTemplate; 					//this line determines static MGs -- Example: ["staticMG", ["B_HMG_01_high_F"]] -- Array, can contain multiple assets
["staticAT", ["rhsgref_cdf_b_SPG9M"]] call _fnc_saveToTemplate; 					//this line determinesstatic ATs -- Example: ["staticAT", ["B_static_AT_F"]] -- Array, can contain multiple assets
["staticAA", ["rhsgref_cdf_b_Igla_AA_pod","rhsgref_cdf_b_ZU23"]] call _fnc_saveToTemplate; 					//this line determines static AAs -- Example: ["staticAA", ["B_static_AA_F"]] -- Array, can contain multiple assets
["staticMortars", ["rhsgref_cdf_b_reg_M252"]] call _fnc_saveToTemplate; 				//this line determines static mortars -- Example: ["staticMortars", ["B_Mortar_01_F"]] -- Array, can contain multiple assets

["mortarMagazineHE", "rhs_12Rnd_m821_HE"] call _fnc_saveToTemplate; 			//this line determines available HE-shells for the static mortars - !needs to be compatible with the mortar! -- Example: ["mortarMagazineHE", "8Rnd_82mm_Mo_shells"] - ENTER ONLY ONE OPTION
["mortarMagazineSmoke", "8Rnd_82mm_Mo_Smoke_white"] call _fnc_saveToTemplate; 		//this line determines smoke-shells for the static mortar - !needs to be compatible with the mortar! -- Example: ["mortarMagazineSmoke", "8Rnd_82mm_Mo_Smoke_white"] - ENTER ONLY ONE OPTION

//Bagged weapon definitions
["baggedMGs", ["RHS_DShkM_Gun_Bag","RHS_DShkM_TripodHigh_Bag"]] call _fnc_saveToTemplate; 				//this line determines bagged static MGs -- Example: ["baggedMGs", [["B_HMG_01_high_F", "B_HMG_01_support_high_F"]]] -- Array, can contain multiple assets
["baggedAT", ["RHS_SPG9_Gun_Bag","RHS_SPG9_Tripod_Bag"]] call _fnc_saveToTemplate; 					//this line determines bagged static ATs -- Example: ["baggedAT", [["B_AT_01_weapon_F", "B_HMG_01_support_F"]]] -- Array, can contain multiple assets
["baggedAA", []] call _fnc_saveToTemplate; 					//this line determines bagged static AAs -- Example: ["baggedAA", [["B_AA_01_weapon_F", "B_HMG_01_support_F"]]] -- Array, can contain multiple assets
["baggedMortars", ["rhs_M252_Gun_Bag","rhs_M252_Bipod_Bag"]] call _fnc_saveToTemplate; 			//this line determines bagged static mortars -- Example: ["baggedMortars", [["B_Mortar_01_F", "B_Mortar_01_weapon_F"]]] -- Array, can contain multiple assets

//Minefield definition
["minefieldAT", ["rhs_mine_M19_mag"]] call _fnc_saveToTemplate; 				//this line determines AT mines used for spawning in minefields -- Example: ["minefieldAT", ["ATMine_Range_Mag"]] -- Array, can contain multiple assets
["minefieldAPERS", ["rhsusf_mine_m14_mag"]] call _fnc_saveToTemplate; 			//this line determines APERS mines used for spawning in minefields -- Example: ["minefieldAPERS", ["APERSMine_Range_Mag"]] -- Array, can contain multiple assets

//PvP definitions
["playerDefaultLoadout", []] call _fnc_saveToTemplate;		//this and PvP could be made from below, unarmed for spawn, PvP from role loadouts - don't touch as it's automation
["pvpLoadouts", []] call _fnc_saveToTemplate; 				//don't touch as it's automation
["pvpVehicles", ["rhsgref_cdf_b_reg_uaz","rhsgref_cdf_b_reg_uaz_open","rhsgref_BRDM2UM_b"]] call _fnc_saveToTemplate; 				//this line determines the vehicles PvP players can spawn in -- Example: ["pvpVehicles", ["B_MRAP_01_F","B_MRAP_01_hmg_F"]] -- Array, can contain multiple assets


//////////////////////////
//       Loadouts       //
//////////////////////////
//     "Weapon", "Muzzle", "Rail", "Sight", [], [], "Bipod"
private _loadoutData = call _fnc_createLoadoutData;
_loadoutData setVariable ["rifles", [
									["rhs_weap_akm","rhs_acc_dtk1l","rhs_acc_2dpZenit","",[],[],""],
									["rhs_weap_akms","rhs_acc_dtk1l","rhs_acc_2dpZenit","",[],[],""],
									["rhs_weap_aks74","rhs_acc_dtk3","rhs_acc_2dpZenit","",[],[],""],
									["rhs_weap_aks74n","rhs_acc_dtk3","rhs_acc_2dpZenit","",[],[],""],
									["rhs_weap_aks74u","rhs_acc_dtk3","","",[],[],""],
									["rhs_weap_ak103","rhs_acc_dtk3","rhs_acc_2dpZenit","",[],[],""],
									["rhs_weap_ak104","rhs_acc_dtk3","rhs_acc_2dpZenit","",[],[],""],
									["rhs_weap_ak105","rhs_acc_dtk1983","rhs_acc_2dpZenit","",[],[],""],
									["rhs_weap_ak74_2","rhs_acc_dtk3","rhs_acc_2dpZenit","",[],[],""]
									]]; 					//this line determines rifles -- Example: ["arifle_MX_F","arifle_MX_pointer_F"] -- Array, can contain multiple assets
//
_loadoutData setVariable ["carbines", [
									["rhs_weap_akmn","rhs_acc_dtk1l","","rhs_acc_1p63",[],[],""],
									["rhs_weap_aks74n","rhs_acc_dtk1983","rhs_acc_2dpZenit","rhs_acc_pkas",[],[],""],
									["rhs_weap_aks74n_2_npz","rhs_acc_dtk4short","rhs_acc_2dpZenit","rhs_acc_rakursPM",[],[],""],
									["rhs_weap_aks74un","rhs_acc_dtk4short","","rhs_acc_1p63",[],[],""],
									["rhs_weap_ak103_1","rhs_acc_dtk4long","rhs_acc_2dpZenit","rhs_acc_pkas",[],[],""],
									["rhs_weap_ak104_zenitco01","rhs_acc_dtk4long","rhs_acc_perst3_2dp_h","rhs_acc_1p63",[],[],"rhs_acc_grip_ffg2"],
									["rhs_weap_ak105_zenitco01","rhs_acc_dtk1983","rhs_acc_perst3_2dp_h","rhs_acc_1p63",[],[],"rhs_acc_grip_ffg2"],
									["rhs_weap_ak74mr","rhs_acc_dtk1983","rhs_acc_perst3_2dp_h","rhs_acc_rakursPM",[],[],"rhs_acc_grip_ffg2"],
									["rhs_weap_asval","","","rhs_acc_1p78",[],[],""]
									]]; 					//this line determines carbines -- Example: ["arifle_MXC_F","arifle_MXC_Holo_F"] -- Array, can contain multiple assets
//
_loadoutData setVariable ["grenadeLaunchers", [
									["rhs_weap_akmn_gp25","rhs_acc_dtk1l","","rhs_acc_1p63",[],[],""],
									["rhs_weap_ak74m_gp25","rhs_acc_dtk1983","","rhs_acc_1p63",[],[],""],
									["rhs_weap_ak74m_fullplum_gp25","rhs_acc_dtk1983","","rhs_acc_pkas",[],[],""],
									["rhs_weap_ak103_gp25","rhs_acc_dtk3","","rhs_acc_pkas",[],[],""],
									["rhs_weap_aks74n_gp25","rhs_acc_dtk3","","rhs_acc_pkas",[],[],""]
									]]; 			//this line determines grenade launchers -- Example: ["arifle_MX_GL_ACO_F","arifle_MX_GL_ACO_pointer_F"] -- Array, can contain multiple assets
//
_loadoutData setVariable ["SMGs", [
									["rhs_weap_vss","","","rhs_acc_pkas",[],[],""],
									["rhs_weap_vss_grip","","rhs_acc_2dpZenit_ris","rhs_acc_pkas",[],[],"rhs_acc_grip_rk2"],
									["rhs_weap_vss_grip_npz","","rhs_acc_2dpZenit_ris","rhs_acc_rakursPM",[],[],"rhs_acc_grip_rk2"],
									["rhs_weap_pm63","rhs_acc_dtk1l","rhs_acc_2dpZenit","",[],[],""],
									["rhs_weap_pp2000","","","rhs_acc_1p87",[],[],""]
									]]; 						//this line determines SMGs -- Example: ["SMG_01_F","SMG_01_Holo_F"] -- Array, can contain multiple assets
//
_loadoutData setVariable ["machineGuns", [
									["rhs_weap_pkm","","","",[],[],""],
									["rhs_weap_pkp","","","rhs_acc_pkas_pkp",[],[],""]
									]]; 				//this line determines machine guns -- Example: ["arifle_MX_SW_F","arifle_MX_SW_Hamr_pointer_F"] -- Array, can contain multiple assets
//
_loadoutData setVariable ["marksmanRifles", [
									["rhs_weap_svdp","","","rhs_acc_pso1m2",[],[],""],
									["rhs_weap_svdp_wd","","","rhs_acc_pso1m2",[],[],""],
									["rhs_weap_svdp_wd_npz","","","rhs_acc_dh520x56",[],[],""],
									["rhs_weap_svdp_npz","","","rhs_acc_dh520x56",[],[],""],
									["rhs_weap_svds","","","rhs_acc_pso1m21",[],[],""]
									]]; 			//this line determines markman rifles -- Example: ["arifle_MXM_F","arifle_MXM_Hamr_pointer_F"] -- Array, can contain multiple assets
//
_loadoutData setVariable ["sniperRifles", [
									["rhs_weap_svds_npz","rhs_acc_tgpv2","","rhs_acc_dh520x56",[],[],""],
									["rhs_weap_t5000","","","rhs_acc_dh520x56",[],[],"rhs_acc_harris_swivel"]
									]]; 				//this line determines sniper rifles -- Example: ["srifle_LRR_camo_F","srifle_LRR_camo_SOS_F"] -- Array, can contain multiple assets
//
_loadoutData setVariable ["lightATLaunchers", ["rhs_weap_rpg26","rhs_weap_rshg2"]]; 			//this line determines light AT launchers -- Example: ["launch_NLAW_F"] -- Array, can contain multiple assets
//
_loadoutData setVariable ["ATLaunchers", [
									["rhs_weap_rpg7","","","rhs_acc_pgo7v",["rhs_rpg7_PG7VR_mag"],[],""],
									["rhs_weap_rpg7","","","rhs_acc_pgo7v2",["rhs_rpg7_PG7VR_mag"],[],""],
									["rhs_weap_rpg7","","","rhs_acc_pgo7v3",["rhs_rpg7_PG7VR_mag"],[],""],
									["rhs_weap_rpg7","","","rhs_acc_pgo7v",["rhs_rpg7_TBG7V_mag"],[],""],
									["rhs_weap_rpg7","","","rhs_acc_pgo7v2",["rhs_rpg7_TBG7V_mag"],[],""],
									["rhs_weap_rpg7","","","rhs_acc_pgo7v3",["rhs_rpg7_TBG7V_mag"],[],""]
									]]; 				//this line determines light AT launchers -- Example: ["launch_NLAW_F"] -- Array, can contain multiple assets
//
_loadoutData setVariable ["heavyATLaunchers", [
["rhs_weap_rpg7","","","rhs_acc_pgo7v",["rhs_rpg7_PG7VR_mag"],[],""],
["rhs_weap_rpg7","","","rhs_acc_pgo7v2",["rhs_rpg7_PG7VR_mag"],[],""],
["rhs_weap_rpg7","","","rhs_acc_pgo7v3",["rhs_rpg7_PG7VR_mag"],[],""],
["rhs_weap_rpg7","","","rhs_acc_pgo7v",["rhs_rpg7_TBG7V_mag"],[],""],
["rhs_weap_rpg7","","","rhs_acc_pgo7v2",["rhs_rpg7_TBG7V_mag"],[],""],
["rhs_weap_rpg7","","","rhs_acc_pgo7v3",["rhs_rpg7_TBG7V_mag"],[],""]
]];
_loadoutData setVariable ["AALaunchers", ["rhs_weap_igla"]]; 				//this line determines AA launchers -- Example: ["launch_B_Titan_F"] -- Array, can contain multiple assets
//
_loadoutData setVariable ["sidearms", ["rhs_weap_6p53","rhs_weap_pb_6p9","rhs_weap_makarov_pm"]]; 					//this line determines handguns/sidearms -- Example: ["hgun_Pistol_heavy_01_F", "hgun_P07_F"] -- Array, can contain multiple assets

_loadoutData setVariable ["ATMines", ["rhs_mine_M19_mag"]]; 					//this line determines the AT mines which can be carried by units -- Example: ["ATMine_Range_Mag"] -- Array, can contain multiple assets
_loadoutData setVariable ["APMines", ["rhsusf_mine_m14_mag"]]; 					//this line determines the APERS mines which can be carried by units -- Example: ["APERSMine_Range_Mag"] -- Array, can contain multiple assets
_loadoutData setVariable ["lightExplosives", ["rhsusf_m112_mag"]]; 			//this line determines light explosives -- Example: ["DemoCharge_Remote_Mag"] -- Array, can contain multiple assets
_loadoutData setVariable ["heavyExplosives", ["rhsusf_m112x4_mag"]]; 			//this line determines heavy explosives -- Example: ["SatchelCharge_Remote_Mag"] -- Array, can contain multiple assets

_loadoutData setVariable ["antiInfantryGrenades", ["rhs_mag_m67"]]; 		//this line determines anti infantry grenades (frag and such) -- Example: ["HandGrenade","MiniGrenade"] -- Array, can contain multiple assets
_loadoutData setVariable ["antiTankGrenades", []]; 			//this line determines anti tank grenades. Leave empty when not available. -- Array, can contain multiple assets
_loadoutData setVariable ["smokeGrenades", ["SmokeShell"]]; 			//this line determines smoke grenades -- Example: ["SmokeShell", "SmokeShellRed"] -- Array, can contain multiple assets


//Basic equipment. Shouldn't need touching most of the time.
//Mods might override this, or certain mods might want items removed (No GPSs in WW2, for example)
_loadoutData setVariable ["maps", ["ItemMap"]];				//this line determines map
_loadoutData setVariable ["watches", ["ItemWatch"]];		//this line determines watch
_loadoutData setVariable ["compasses", ["ItemCompass"]];	//this line determines compass
_loadoutData setVariable ["radios", ["ItemRadio"]];			//this line determines radio
_loadoutData setVariable ["gpses", ["ItemGPS"]];			//this line determines GPS
_loadoutData setVariable ["NVGs", ["rhs_1PN138"]];			//this line determines NVGs -- Array, can contain multiple assets
_loadoutData setVariable ["binoculars", ["Binocular"]];		//this line determines the binoculars

_loadoutData setVariable ["uniforms", []];					//don't fill this line - this is only to set the variable
_loadoutData setVariable ["vests", []];						//don't fill this line - this is only to set the variable
_loadoutData setVariable ["backpacks", []];					//don't fill this line - this is only to set the variable
_loadoutData setVariable ["longRangeRadios", []];			//don't fill this line - this is only to set the variable
_loadoutData setVariable ["helmets", []];					//don't fill this line - this is only to set the variable

//Item *set* definitions. These are added in their entirety to unit loadouts. No randomisation is applied.
_loadoutData setVariable ["items_medical_basic", [["FirstAidKit", 2]]];		//this line defines the basic medical loadout for vanilla
_loadoutData setVariable ["items_medical_standard", [["FirstAidKit", 3]]];		//this line defines the standard medical loadout for vanilla
_loadoutData setVariable ["items_medical_medic", ["Medikit", ["FirstAidKit", 10]]];		//this line defines the medic medical loadout for vanilla
_loadoutData setVariable ["items_miscEssentials", []];

//Unit type specific item sets. Add or remove these, depending on the unit types in use.
_loadoutData setVariable ["items_squadleader_extras", []];	//this line defines specific items for the class squadleader
_loadoutData setVariable ["items_rifleman_extras", []];		//this line defines specific items for the class rifleman
_loadoutData setVariable ["items_medic_extras", []];		//this line defines specific items for the class medic
_loadoutData setVariable ["items_grenadier_extras", []];	//this line defines specific items for the class grenadier
_loadoutData setVariable ["items_explosivesExpert_extras", []];		//this line defines specific items for the class explosives expert
_loadoutData setVariable ["items_engineer_extras", ["Toolkit", "MineDetector"]];		//this line defines specific items for the class engineer
_loadoutData setVariable ["items_lat_extras", []];			//this line defines specific items for the class light AT
_loadoutData setVariable ["items_at_extras", []];			//this line defines specific items for the class AT
_loadoutData setVariable ["items_aa_extras", []];			//this line defines specific items for the class AA
_loadoutData setVariable ["items_machineGunner_extras", []];		//this line defines specific items for the class machine gunner
_loadoutData setVariable ["items_marksman_extras", []];		//this line defines specific items for the class marksman
_loadoutData setVariable ["items_sniper_extras", []];		//this line defines specific items for the class sniper
_loadoutData setVariable ["items_police_extras", []];		//this line defines specific items for the class police
_loadoutData setVariable ["items_crew_extras", []];			//this line defines specific items for the class crew
_loadoutData setVariable ["items_unarmed_extras", []];		//this line defines specific items for the class unarmed

//TODO - ACE overrides for misc essentials, medical and engineer gear
//TODO - TFAR overrides for radios

///////////////////////////////////////
//    Special Forces Loadout Data    //
///////////////////////////////////////

private _sfLoadoutData = _loadoutData call _fnc_copyLoadoutData; // touch and shit breaks
_sfLoadoutData setVariable ["uniforms", ["rhsgref_uniform_para_ttsko_urban"]];			//this line determines uniforms for special forces -- Example: ["U_B_CombatUniform_mcam","U_B_CombatUniform_mcam_tshirt"]] -- Array, can contain multiple assets
_sfLoadoutData setVariable ["vests", ["rhs_6b5","rhs_6b5_rifleman","rhs_6b5_medic","rhs_6b5_officer","rhs_6b5_sniper"]];				//this line determines vests for special forces -- Example: ["V_PlateCarrierSpec_mtp","V_PlateCarrierGL_mtp"] -- Array, can contain multiple assets
_sfLoadoutData setVariable ["backpacks", ["B_Carryall_oli"]];			//this line determines backpacks for special forces -- Example: ["B_AssaultPack_mcamo","B_Kitbag_mcamo"] -- Array, can contain multiple assets
_sfLoadoutData setVariable ["helmets", ["rhsgref_6b27m_ttsko_digi"]];				//this line determines helmets for special forces -- Example: ["H_HelmetB_camo","H_HelmetB_desert"] -- Array, can contain multiple assets

/////////////////////////////////
//    Military Loadout Data    //
/////////////////////////////////

private _militaryLoadoutData = _loadoutData call _fnc_copyLoadoutData; // touch and shit breaks
_militaryLoadoutData setVariable ["uniforms", ["rhsgref_uniform_ttsko_mountain"]];		//this line determines uniforms for military loadouts -- Example: ["U_B_CombatUniform_mcam","U_B_CombatUniform_mcam_tshirt"] -- Array, can contain multiple assets
_militaryLoadoutData setVariable ["vests", ["rhs_6b5_ttsko","rhs_6b5_rifleman_ttsko","rhs_6b5_medic_ttsko","rhs_6b5_officer_ttsko","rhs_6b5_sniper_ttsko"]];			//this line determines vests for military loadouts -- Example: ["V_PlateCarrierSpec_mtp","V_PlateCarrierGL_mtp"] -- Array, can contain multiple assets
_militaryLoadoutData setVariable ["backpacks", ["B_Carryall_oli"]];		//this line determines backpacks for military loadouts -- Example: ["B_AssaultPack_mcamo","B_Kitbag_mcamo"] -- Array, can contain multiple assets
_militaryLoadoutData setVariable ["helmets", ["rhsgref_6b27m_ttsko_mountain"]];		//this line determines helmets for military loadouts -- Example: ["H_HelmetB_camo","H_HelmetB_desert"] -- Array, can contain multiple assets

///////////////////////////////
//    Police Loadout Data    //
///////////////////////////////

private _policeLoadoutData = _loadoutData call _fnc_copyLoadoutData; // touch and shit breaks
_policeLoadoutData setVariable ["rifles", ["rhs_weap_ak103_1"]];			//this line determines the rifles for police loadouts -- Example: ["arifle_MX_F","arifle_MX_pointer_F"] -- Array, can contain multiple assets
_policeLoadoutData setVariable ["grenadelaunchers", [
["rhs_weap_ak74_gp25","","","",[""],["rhs_VG40SZ"],""]
]];//this line determines the grenadelaunchers for police loadouts -- Example: ["arifle_MX_GL_ACO_F","arifle_MX_GL_ACO_pointer_F"] -- Array, can contain multiple assets
_policeLoadoutData setVariable ["smgs", [
["rhsusf_weap_MP7A2","","","rhsusf_acc_eotech_552",[""],[],""],
["rhsusf_weap_MP7A2","","","rhsusf_acc_compm4",[""],[],""],
"rhs_weap_pp2000"]];			//this line determines the smgs for police loadouts -- Example: ["SMG_01_F","SMG_01_Holo_F"] -- Array, can contain multiple assets
_policeLoadoutData setVariable ["carbines", ["rhs_weap_aks74u"]];		//this line determines the carbines for police loadouts -- Example: ["arifle_MXC_F","arifle_MXC_Holo_F"] -- Array, can contain multiple assets
_policeLoadoutData setVariable ["uniforms", ["U_B_GEN_Soldier_F","U_B_GEN_Commander_F"]];		//this line determines uniforms for police loadouts -- Example: ["U_B_GEN_Commander_F"] -- Array, can contain multiple assets
_policeLoadoutData setVariable ["vests", ["V_TacVest_gen_F"]];			//this line determines vests for police loadouts -- Example: ["V_TacVest_gen_F"] -- Array, can contain multiple assets
_policeLoadoutData setVariable ["backpacks", []];		//this line determines backpacks for police loadouts -- Example: ["B_Kitbag_mcamo"] -- Array, can contain multiple assets
_policeLoadoutData setVariable ["helmets", ["H_MilCap_gen_F","H_Beret_gen_F"]];			//this line determines helmets for police loadouts -- Example: ["H_Beret_gen_F"] -- Array, can contain multiple assets

////////////////////////////////
//    Militia Loadout Data    //
////////////////////////////////

private _militiaLoadoutData = _loadoutData call _fnc_copyLoadoutData; // touch and shit breaks
_militiaLoadoutData setVariable ["uniforms", ["rhsgref_uniform_ttsko_forest"]];		//this line determines uniforms for militia loadouts -- Example: ["U_B_CombatUniform_mcam","U_B_CombatUniform_mcam_tshirt"] -- Array, can contain multiple assets
_militiaLoadoutData setVariable ["vests", ["rhs_6b5_khaki","rhs_6b5_rifleman_khaki","rhs_6b5_medic_khaki","rhs_6b5_officer_khaki","rhs_6b5_sniper_khaki"]];			//this line determines vests for militia loadouts -- Example: ["V_PlateCarrierSpec_mtp","V_PlateCarrierGL_mtp"] -- Array, can contain multiple assets
_militiaLoadoutData setVariable ["backpacks", ["B_Carryall_oli"]];		//this line determines backpacks for militia loadouts -- Example: ["B_AssaultPack_mcamo","B_Kitbag_mcamo"] -- Array, can contain multiple assets
_militiaLoadoutData setVariable ["helmets", ["rhsgref_ssh68_ttsko_forest"]];		//this line determines helmets for police loadouts -- Example: ["H_HelmetB_camo","H_HelmetB_desert"] -- Array, can contain multiple assets

//////////////////////////
//    Misc Loadouts     //
//////////////////////////
//The following lines are determining the loadout of the vehicle crew
private _crewLoadoutData = _militaryLoadoutData call _fnc_copyLoadoutData; // touch and shit breaks
_crewLoadoutData setVariable ["uniforms", ["rhsgref_uniform_ttsko_mountain"]];			//this line determines uniforms for vehicle crew loadouts -- Example: ["U_B_CombatUniform_mcam","U_B_CombatUniform_mcam_tshirt"] -- Array, can contain multiple assets
_crewLoadoutData setVariable ["vests", ["rhs_vest_pistol_holster"]];				//this line determines vests for vehicle crew loadouts -- Example: ["V_PlateCarrierSpec_mtp","V_PlateCarrierGL_mtp"] -- Array, can contain multiple assets
_crewLoadoutData setVariable ["helmets", ["rhs_tsh4_ess"]];			//this line determines backpacks for vehicle crew loadouts -- Example: ["B_AssaultPack_mcamo","B_Kitbag_mcamo"] -- Array, can contain multiple assets

//The following lines are determining the loadout of the pilots
private _pilotLoadoutData = _militaryLoadoutData call _fnc_copyLoadoutData;
_pilotLoadoutData setVariable ["uniforms", ["rhsgref_uniform_ttsko_mountain"]];			//this line determines uniforms for pilot loadouts -- Example: ["U_B_CombatUniform_mcam","U_B_CombatUniform_mcam_tshirt"] -- Array, can contain multiple assets
_pilotLoadoutData setVariable ["vests", ["rhs_vest_commander"]];			//this line determines vests for pilot loadouts -- Example: ["V_PlateCarrierSpec_mtp","V_PlateCarrierGL_mtp"] -- Array, can contain multiple assets
_pilotLoadoutData setVariable ["helmets", ["rhs_zsh7a_mike"]];			//this line determines backpacks for pilot loadouts -- Example: ["B_AssaultPack_mcamo","B_Kitbag_mcamo"] -- Array, can contain multiple assets


// ##################### DO NOT TOUCH ANYTHING BELOW THIS LINE #####################


/////////////////////////////////
//    Unit Type Definitions    //
/////////////////////////////////
//These define the loadouts for different unit types.
//For example, rifleman, grenadier, squad leader, etc.
//In 95% of situations, you *should not need to edit these*.
//Almost all factions can be set up just by modifying the loadout data above.
//However, these exist in case you really do want to do a lot of custom alterations.

private _squadLeaderTemplate = {
	["helmets"] call _fnc_addHelmet;
	["vests"] call _fnc_addVest;
	["uniforms"] call _fnc_addUniform;
	//TODO - Long range radios
	[["longRangeRadios", "backpacks"] call _fnc_fallback] call _fnc_addBackpack;

	[["grenadeLaunchers", "rifles"] call _fnc_fallback] call _fnc_addPrimary;
	["primary", 5] call _fnc_addMagazines;
	//TODO: How to add underslung grenade mags.

	["sidearms"] call _fnc_addHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_standard"] call _fnc_addItemSet;
	["items_squadLeader_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;
	["antiInfantryGrenades", 2] call _fnc_addItem;
	["antiTankGrenades", 1] call _fnc_addItem;
	["smokeGrenades", 2] call _fnc_addItem;
	["smokeGrenades", 2] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
	["gpses"] call _fnc_addGPS;
	["binoculars"] call _fnc_addBinoculars;
	["NVGs"] call _fnc_addNVGs;
};

private _riflemanTemplate = {
	["helmets"] call _fnc_addHelmet;
	["vests"] call _fnc_addVest;
	["uniforms"] call _fnc_addUniform;
	["backpacks"] call _fnc_addBackpack;

	["rifles"] call _fnc_addPrimary;
	["primary", 8] call _fnc_addMagazines;

	["sidearms"] call _fnc_addHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_standard"] call _fnc_addItemSet;
	["items_rifleman_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;
	["antiInfantryGrenades", 2] call _fnc_addItem;
	["antiTankGrenades", 1] call _fnc_addItem;
	["smokeGrenades", 2] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
	["NVGs"] call _fnc_addNVGs;
};

private _medicTemplate = {
	["helmets"] call _fnc_addHelmet;
	["vests"] call _fnc_addVest;
	["uniforms"] call _fnc_addUniform;
	["backpacks"] call _fnc_addBackpack;

	["carbines"] call _fnc_addPrimary;
	["primary", 5] call _fnc_addMagazines;

	["sidearms"] call _fnc_addHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_medic"] call _fnc_addItemSet;
	["items_medic_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;
	["antiInfantryGrenades", 1] call _fnc_addItem;
	["smokeGrenades", 2] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
	["NVGs"] call _fnc_addNVGs;
};

private _grenadierTemplate = {
	["helmets"] call _fnc_addHelmet;
	["vests"] call _fnc_addVest;
	["uniforms"] call _fnc_addUniform;
	["backpacks"] call _fnc_addBackpack;

	["grenadeLaunchers"] call _fnc_addPrimary;
	["primary", 5] call _fnc_addMagazines;
	//TODO: How to add underslung grenade mags.

	["sidearms"] call _fnc_addHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_standard"] call _fnc_addItemSet;
	["items_grenadier_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;
	["antiInfantryGrenades", 4] call _fnc_addItem;
	["antiTankGrenades", 3] call _fnc_addItem;
	["smokeGrenades", 2] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
	["NVGs"] call _fnc_addNVGs;
};

private _explosivesExpertTemplate = {
	["helmets"] call _fnc_addHelmet;
	["vests"] call _fnc_addVest;
	["uniforms"] call _fnc_addUniform;
	["backpacks"] call _fnc_addBackpack;

	["rifles"] call _fnc_addPrimary;
	["primary", 5] call _fnc_addMagazines;
	//TODO: How to add underslung grenade mags.

	["sidearms"] call _fnc_addHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_standard"] call _fnc_addItemSet;
	["items_grenadier_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;

	["lightExplosives", 2] call _fnc_addItem;
	if (random 1 > 0.5) then {["heavyExplosives", 1] call _fnc_addItem;};
	if (random 1 > 0.5) then {["atMines", 1] call _fnc_addItem;};
	if (random 1 > 0.5) then {["apMines", 1] call _fnc_addItem;};

	["antiInfantryGrenades", 1] call _fnc_addItem;
	["smokeGrenades", 1] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
	["NVGs"] call _fnc_addNVGs;
};

private _engineerTemplate = {
	["helmets"] call _fnc_addHelmet;
	["vests"] call _fnc_addVest;
	["uniforms"] call _fnc_addUniform;
	["backpacks"] call _fnc_addBackpack;

	["carbines"] call _fnc_addPrimary;
	["primary", 5] call _fnc_addMagazines;

	["sidearms"] call _fnc_addHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_standard"] call _fnc_addItemSet;
	["items_engineer_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;

	if (random 1 > 0.5) then {["lightExplosives", 1] call _fnc_addItem;};

	["antiInfantryGrenades", 1] call _fnc_addItem;
	["smokeGrenades", 2] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
	["NVGs"] call _fnc_addNVGs;
};

private _latTemplate = {
	["helmets"] call _fnc_addHelmet;
	["vests"] call _fnc_addVest;
	["uniforms"] call _fnc_addUniform;
	["backpacks"] call _fnc_addBackpack;

	["rifles"] call _fnc_addPrimary;
	["primary", 8] call _fnc_addMagazines;

	[selectRandom ["ATLaunchers", "lightATLaunchers"]] call _fnc_addLauncher;
	//TODO - Add a check if it's disposable.
	["launcher", 1] call _fnc_addMagazines;

	["sidearms"] call _fnc_addHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_standard"] call _fnc_addItemSet;
	["items_lat_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;
	["antiInfantryGrenades", 1] call _fnc_addItem;
	["antiTankGrenades", 2] call _fnc_addItem;
	["smokeGrenades", 1] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
	["NVGs"] call _fnc_addNVGs;
};

private _atTemplate = {
	["helmets"] call _fnc_addHelmet;
	["vests"] call _fnc_addVest;
	["uniforms"] call _fnc_addUniform;
	["backpacks"] call _fnc_addBackpack;

	["rifles"] call _fnc_addPrimary;
	["primary", 5] call _fnc_addMagazines;

	[selectRandom ["ATLaunchers", "heavyATLaunchers"]] call _fnc_addLauncher;
	//TODO - Add a check if it's disposable.
	["launcher", 2] call _fnc_addMagazines;

	["sidearms"] call _fnc_addHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_standard"] call _fnc_addItemSet;
	["items_at_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;
	["antiInfantryGrenades", 1] call _fnc_addItem;
	["antiTankGrenades", 2] call _fnc_addItem;
	["smokeGrenades", 1] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
	["NVGs"] call _fnc_addNVGs;
};

private _aaTemplate = {
	["helmets"] call _fnc_addHelmet;
	["vests"] call _fnc_addVest;
	["uniforms"] call _fnc_addUniform;
	["backpacks"] call _fnc_addBackpack;

	["rifles"] call _fnc_addPrimary;
	["primary", 5] call _fnc_addMagazines;

	["AALaunchers"] call _fnc_addLauncher;
	//TODO - Add a check if it's disposable.
	["launcher", 2] call _fnc_addMagazines;

	["sidearms"] call _fnc_addHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_standard"] call _fnc_addItemSet;
	["items_aa_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;
	["antiInfantryGrenades", 2] call _fnc_addItem;
	["smokeGrenades", 2] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
	["NVGs"] call _fnc_addNVGs;
};

private _machineGunnerTemplate = {
	["helmets"] call _fnc_addHelmet;
	["vests"] call _fnc_addVest;
	["uniforms"] call _fnc_addUniform;
	["backpacks"] call _fnc_addBackpack;

	["machineGuns"] call _fnc_addPrimary;
	["primary", 4] call _fnc_addMagazines;

	["sidearms"] call _fnc_addHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_standard"] call _fnc_addItemSet;
	["items_machineGunner_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;
	["antiInfantryGrenades", 2] call _fnc_addItem;
	["smokeGrenades", 2] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
	["NVGs"] call _fnc_addNVGs;
};

private _marksmanTemplate = {
	["helmets"] call _fnc_addHelmet;
	["vests"] call _fnc_addVest;
	["uniforms"] call _fnc_addUniform;
	["backpacks"] call _fnc_addBackpack;

	["marksmanRifles"] call _fnc_addPrimary;
	["primary", 8] call _fnc_addMagazines;

	["sidearms"] call _fnc_addHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_standard"] call _fnc_addItemSet;
	["items_marksman_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;
	["antiInfantryGrenades", 2] call _fnc_addItem;
	["smokeGrenades", 3] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
	["NVGs"] call _fnc_addNVGs;
};

private _sniperTemplate = {
	["helmets"] call _fnc_addHelmet;
	["vests"] call _fnc_addVest;
	["uniforms"] call _fnc_addUniform;
	["backpacks"] call _fnc_addBackpack;

	["sniperRifles"] call _fnc_addPrimary;
	["primary", 5] call _fnc_addMagazines;

	["sidearms"] call _fnc_addHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_standard"] call _fnc_addItemSet;
	["items_sniper_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;
	["antiInfantryGrenades", 2] call _fnc_addItem;
	["smokeGrenades", 3] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
	["NVGs"] call _fnc_addNVGs;
};

private _policeTemplate = {
	["vests"] call _fnc_addVest;
	["uniforms"] call _fnc_addUniform;
	["backpacks"] call _fnc_addBackpack;

	[selectRandom ["smgs", "carbines"]] call _fnc_addPrimary;
	["primary", 5] call _fnc_addMagazines;

	["sidearms"] call _fnc_addHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_standard"] call _fnc_addItemSet;
	["items_police_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;
	["smokeGrenades", 1] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
};

private _crewTemplate = {
	["helmets"] call _fnc_addHelmet;
	["vests"] call _fnc_addVest;
	["uniforms"] call _fnc_addUniform;

	["smgs"] call _fnc_addPrimary;
	["primary", 3] call _fnc_addMagazines;

	["sidearms"] call _fnc_addHandgun;
	["handgun", 2] call _fnc_addMagazines;

	["items_medical_basic"] call _fnc_addItemSet;
	["items_crew_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;
	["smokeGrenades", 2] call _fnc_addItem;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
	["gpses"] call _fnc_addGPS;
	["NVGs"] call _fnc_addNVGs;
};

private _unarmedTemplate = {
	["vests"] call _fnc_addVest;
	["uniforms"] call _fnc_addUniform;

	["items_medical_basic"] call _fnc_addItemSet;
	["items_unarmed_extras"] call _fnc_addItemSet;
	["items_miscEssentials"] call _fnc_addItemSet;

	["maps"] call _fnc_addMap;
	["watches"] call _fnc_addWatch;
	["compasses"] call _fnc_addCompass;
	["radios"] call _fnc_addRadio;
};

////////////////////////////////////////////////////////////////////////////////////////
//  You shouldn't touch below this line unless you really really know what you're doing.
//  Things below here can and will break the gamemode if improperly changed.
////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////
//  Special Forces Units   //
/////////////////////////////
private _prefix = "SF";
private _unitTypes = [
	["SquadLeader", _squadLeaderTemplate],
	["Rifleman", _riflemanTemplate],
	["Medic", _medicTemplate],
	["Engineer", _engineerTemplate],
	["ExplosivesExpert", _explosivesExpertTemplate],
	["Grenadier", _grenadierTemplate],
	["LAT", _latTemplate],
	["AT", _atTemplate],
	["AA", _aaTemplate],
	["MachineGunner", _machineGunnerTemplate],
	["Marksman", _marksmanTemplate],
	["Sniper", _sniperTemplate]
];

[_prefix, _unitTypes, _sfLoadoutData] call _fnc_saveUnitLoadoutsToTemplate;

/*{
	params ["_name", "_loadoutTemplate"];
	private _loadouts = [_sfLoadoutData, _loadoutTemplate] call _fnc_buildLoadouts;
	private _finalName = _prefix + _name;
	[_finalName, _loadouts] call _fnc_saveToTemplate;
} forEach _unitTypes;
*/

///////////////////////
//  Military Units   //
///////////////////////
private _prefix = "military";
private _unitTypes = [
	["SquadLeader", _squadLeaderTemplate],
	["Rifleman", _riflemanTemplate],
	["Medic", _medicTemplate],
	["Engineer", _engineerTemplate],
	["ExplosivesExpert", _explosivesExpertTemplate],
	["Grenadier", _grenadierTemplate],
	["LAT", _latTemplate],
	["AT", _atTemplate],
	["AA", _aaTemplate],
	["MachineGunner", _machineGunnerTemplate],
	["Marksman", _marksmanTemplate],
	["Sniper", _sniperTemplate]
];

[_prefix, _unitTypes, _militaryLoadoutData] call _fnc_saveUnitLoadoutsToTemplate;

////////////////////////
//    Police Units    //
////////////////////////
private _prefix = "police";
private _unitTypes = [
	["SquadLeader", _squadLeaderTemplate],
	["Standard", _policeTemplate]
];

[_prefix, _unitTypes, _policeLoadoutData] call _fnc_saveUnitLoadoutsToTemplate;

////////////////////////
//    Militia Units    //
////////////////////////
private _prefix = "militia";
private _unitTypes = [
	["Rifleman", _riflemanTemplate],
	["Marksman", _marksmanTemplate]
];

[_prefix, _unitTypes, _policeLoadoutData] call _fnc_saveUnitLoadoutsToTemplate;

//////////////////////
//    Misc Units    //
//////////////////////

//The following lines are determining the loadout of vehicle crew
["loadouts_", ["Crew", _crewTemplate], _crewLoadoutData] call _saveUnitLoadoutsToTemplate;
//The following lines are determining the loadout of the pilots
["loadouts_", ["Pilot", _crewTemplate], _pilotLoadoutData] call _saveUnitLoadoutsToTemplate;
//The following lines are determining the loadout for the unit used in the "kill the official" mission
["loadouts_", ["Official", _policeTemplate], _militaryLoadoutData] call _saveUnitLoadoutsToTemplate;
//The following lines are determining the loadout for the AI used in the "kill the traitor" mission
["loadouts_", ["Traitor", _unarmedTemplate], _militaryLoadoutData] call _saveUnitLoadoutsToTemplate;
