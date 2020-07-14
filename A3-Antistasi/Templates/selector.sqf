/*
    This file controls the selection of templates based on the mods loaded and map used.
    When porting new mods/maps be sure to add them to their respective sections!
*/
private _filename = "selector.sqf";
//Map checker
aridmaps = ["Altis","Kunduz","Malden","tem_anizay","Tembelan"];
tropicalmaps = ["Tanoa"];
temperatemaps = ["Enoch","chernarus_summer","vt7"];
arcticmaps = ["chernarus_winter"];

//Mod selector
if(teamplayer != independent) then {//This section is for Altis Blufor ONLY!
  switch(true) do {
    case (has3CB): {
      call compile preProcessFileLineNumbers "Templates\3CB_Reb_TPGM_Arid.sqf";
      call compile preProcessFileLineNumbers "Templates\3CB_Occ_TKA_Arid.sqf";
      call compile preProcessFileLineNumbers "Templates\3CB_Inv_TKM_Arid.sqf";
      call compile preProcessFileLineNumbers "Templates\3CB_Civ.sqf";
      [2, "Using arid_b TGPM, TKA, TKM, 3CB Civ Templates", _filename] call A3A_fnc_log;
    };
    case (hasRHS): {
      call compile preProcessFileLineNumbers "Templates\RHS_Reb_CDF_Arid.sqf";
      call compile preProcessFileLineNumbers "Templates\RHS_Occ_CDF_Arid.sqf";
      call compile preProcessFileLineNumbers "Templates\RHS_Inv_AFRF_Arid.sqf";
      call compile preProcessFileLineNumbers "Templates\RHS_Civ.sqf";
      [2, "Using arid_b CDF, CDF, AFRF, RHS Civ Templates", _filename] call A3A_fnc_log;
    };
    default {
      call compile preProcessFileLineNumbers "Templates\Vanilla_Reb_FIA_B_Altis.sqf";
      call compile preProcessFileLineNumbers "Templates\Vanilla_Occ_AAF_Altis.sqf";
      call compile preProcessFileLineNumbers "Templates\Vanilla_Inv_CSAT_Altis.sqf";
      call compile preProcessFileLineNumbers "Templates\Vanilla_Civ.sqf";
      [2, "Using arid_b FIA_B, AAF, CSAT, Vanilla Civ Templates", _filename] call A3A_fnc_log;
    };
  };
}else{//This is for non-blufor (THE ONE THAT MATTERS!!)
  switch(true) do{
    case (has3CB): {
      switch(true) do {
        case (worldName in arcticmaps): {
          call compile preProcessFileLineNumbers "Templates\3CB_Reb_CNM_Temp.sqf";
          call compile preProcessFileLineNumbers "Templates\3CB_Occ_BAF_Temp.sqf";
          call compile preProcessFileLineNumbers "Templates\3CB_Inv_SOV_Temp.sqf";
          [2, "Using arctic CNM, BAF, SOV, 3CB Civ Templates", _filename] call A3A_fnc_log;
        };
        case (worldName in temperatemaps): {
          call compile preProcessFileLineNumbers "Templates\3CB_Reb_CNM_Temp.sqf";
          call compile preProcessFileLineNumbers "Templates\3CB_Occ_BAF_Temp.sqf";
          call compile preProcessFileLineNumbers "Templates\3CB_Inv_SOV_Temp.sqf";
          [2, "Using temperate CNM, BAF, SOV, 3CB Civ Templates", _filename] call A3A_fnc_log;
        };
        case (worldName in tropicalmaps): {
          call compile preProcessFileLineNumbers "Templates\3CB_Reb_CNM_Trop.sqf";
          call compile preProcessFileLineNumbers "Templates\3CB_Occ_BAF_Trop.sqf";
          call compile preProcessFileLineNumbers "Templates\3CB_Inv_SOV_Temp.sqf";
          [2, "Using tropical CNM, BAF, SOV, 3CB Civ Templates", _filename] call A3A_fnc_log;
        };
        default {
          call compile preProcessFileLineNumbers "Templates\3CB_Reb_TTF_Arid.sqf";
          call compile preProcessFileLineNumbers "Templates\3CB_Occ_BAF_Arid.sqf";
          call compile preProcessFileLineNumbers "Templates\3CB_Inv_TKM_Arid.sqf";
          [2, "Using arid TTF, BAF, TKM, 3CB Civ Templates", _filename] call A3A_fnc_log;
        };
      };
      call compile preProcessFileLineNumbers "Templates\3CB_Civ.sqf";
    };
    case (hasRHS): {
      switch(true) do {
        case (worldName in arcticmaps): {
          call compile preProcessFileLineNumbers "Templates\RHS_Reb_NAPA_Temp.sqf";
          call compile preProcessFileLineNumbers "Templates\RHS_Occ_USAF_Temp.sqf";
          call compile preProcessFileLineNumbers "Templates\RHS_Inv_AFRF_Temp.sqf";
          [2, "Using arctic NAPA, USAF, AFRF, RHS Civ Templates", _filename] call A3A_fnc_log;
        };
        case (worldName in temperatemaps): {
          call compile preProcessFileLineNumbers "Templates\RHS_Reb_NAPA_Temp.sqf";
          call compile preProcessFileLineNumbers "Templates\RHS_Occ_USAF_Temp.sqf";
          call compile preProcessFileLineNumbers "Templates\RHS_Inv_AFRF_Temp.sqf";
          [2, "Using temperate NAPA, USAF, AFRF, RHS Civ Templates", _filename] call A3A_fnc_log;
        };
        case (worldName in tropicalmaps): {
          call compile preProcessFileLineNumbers "Templates\RHS_Reb_NAPA_Temp.sqf";
          call compile preProcessFileLineNumbers "Templates\RHS_Occ_USAF_Temp.sqf";
          call compile preProcessFileLineNumbers "Templates\RHS_Inv_AFRF_Temp.sqf";
          [2, "Using tropical NAPA, USAF, AFRF, RHS Civ Templates", _filename] call A3A_fnc_log;
        };
        default {
          call compile preProcessFileLineNumbers "Templates\RHS_Reb_NAPA_Arid.sqf";
          call compile preProcessFileLineNumbers "Templates\RHS_Occ_USAF_Arid.sqf";
          call compile preProcessFileLineNumbers "Templates\RHS_Inv_AFRF_Arid.sqf";
          [2, "Using arid NAPA, USAF, AFRF, RHS Civ Templates", _filename] call A3A_fnc_log;
        };
      };
      call compile preProcessFileLineNumbers "Templates\RHS_Civ.sqf";
    };
    case (hasIFA): {
      switch(true) do {
        case (worldName in arcticmaps): {
          call compile preProcessFileLineNumbers "Templates\IFA_Reb_POL_Arct.sqf";
          call compile preProcessFileLineNumbers "Templates\IFA_Inv_SOV_Arct.sqf";
          call compile preProcessFileLineNumbers "Templates\IFA_Occ_WEH_Arct.sqf";
          [2, "Using arctic POL, SOV, WEH, IFA Civ Templates", _filename] call A3A_fnc_log;
        };
        case (worldName in temperatemaps): {
          call compile preProcessFileLineNumbers "Templates\IFA_Reb_POL_Temp.sqf";
          call compile preProcessFileLineNumbers "Templates\IFA_Inv_SOV_Temp.sqf";
          call compile preProcessFileLineNumbers "Templates\IFA_Occ_WEH_Temp.sqf";
          [2, "Using temperate POL, SOV, WEH, IFA Civ Templates", _filename] call A3A_fnc_log;
        };
        case (worldName in tropicalmaps): {
          call compile preProcessFileLineNumbers "Templates\IFA_Reb_POL_Temp.sqf";
          call compile preProcessFileLineNumbers "Templates\IFA_Inv_SOV_Temp.sqf";
          call compile preProcessFileLineNumbers "Templates\IFA_Occ_WEH_Temp.sqf";
          [2, "Using tropical POL, SOV, WEH, IFA Civ Templates", _filename] call A3A_fnc_log;
        };
        default {
          call compile preProcessFileLineNumbers "Templates\IFA_Reb_POL_Arid.sqf";
          call compile preProcessFileLineNumbers "Templates\IFA_Inv_SOV_Arid.sqf";
          call compile preProcessFileLineNumbers "Templates\IFA_Occ_WEH_Arid.sqf";
          [2, "Using arid POL, SOV, WEH, IFA Civ Templates", _filename] call A3A_fnc_log;
        };
      };
      call compile preProcessFileLineNumbers "Templates\IFA_Civ.sqf";
    };
    default {
      switch(true) do {//This one (vanilla) works differently so that we don't get DLC kit on modded maps.
        case (worldName == "Enoch"): {
          call compile preProcessFileLineNumbers "Templates\Vanilla_Reb_FIA_Enoch.sqf";
          call compile preProcessFileLineNumbers "Templates\Vanilla_Occ_NATO_Temp.sqf";
          call compile preProcessFileLineNumbers "Templates\Vanilla_Inv_CSAT_Enoch.sqf";
          [2, "Using Enoch FIA, NATO, CSAT, Vanilla Civ Templates", _filename] call A3A_fnc_log;
        };
        case (worldName == "Tanoa"): {
          call compile preProcessFileLineNumbers "Templates\Vanilla_Reb_SDK_Tanoa.sqf";
          call compile preProcessFileLineNumbers "Templates\Vanilla_Occ_NATO_Tanoa.sqf";
          call compile preProcessFileLineNumbers "Templates\Vanilla_Inv_CSAT_Tanoa.sqf";
          [2, "Using tanoa SDK, NATO, CSAT, Vanilla Civ Templates", _filename] call A3A_fnc_log;
        };
        case (worldName in temperatemaps): {
          call compile preProcessFileLineNumbers "Templates\Vanilla_Reb_FIA_Altis.sqf";
          call compile preProcessFileLineNumbers "Templates\Vanilla_Occ_NATO_Temp.sqf";
          call compile preProcessFileLineNumbers "Templates\Vanilla_Inv_CSAT_Altis.sqf";
          [2, "Using temperate FIA, NATO, CSAT, Vanilla Civ Templates", _filename] call A3A_fnc_log;
        };
        default {
          call compile preProcessFileLineNumbers "Templates\Vanilla_Reb_FIA_Altis.sqf";
          call compile preProcessFileLineNumbers "Templates\Vanilla_Occ_NATO_Altis.sqf";
          call compile preProcessFileLineNumbers "Templates\Vanilla_Inv_CSAT_Altis.sqf";
          [2, "Using arid FIA, NATO, CSAT, Vanilla Civ Templates", _filename] call A3A_fnc_log;
        };
      };
      call compile preProcessFileLineNumbers "Templates\Vanilla_Civ.sqf";
    };
  };
};

//Addon mod loading
if (hasIvory) then {call compile preProcessFileLineNumbers "Templates\Ivory_Civ.sqf";[2, "Using Addon Ivory Cars Template", _filename] call A3A_fnc_log;};
