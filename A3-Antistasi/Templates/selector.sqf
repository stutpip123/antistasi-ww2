/*
    This file controls the selection of templates based on the mods loaded and map used.
    When porting new mods/maps be sure to add them to their respective sections!
*/

/* //this part was a shortcut by Spoffy to test the template system
if (true) exitWith {
  ["Templates\NewTemplates\Vanilla\Vanilla_Reb_FIA_Arid.sqf", independent] call A3A_fnc_compatabilityLoadFaction;
  ["Templates\NewTemplates\Vanilla\Vanilla_AI_NATO_Arid.sqf", west] call A3A_fnc_compatabilityLoadFaction;
  ["Templates\NewTemplates\Vanilla\Vanilla_AI_CSAT_Arid.sqf", east] call A3A_fnc_compatabilityLoadFaction;
  ["Templates\NewTemplates\Vanilla\Vanilla_Civ.sqf", civilian] call A3A_fnc_compatabilityLoadFaction;
};
*/

//Map checker
aridmaps = ["Altis","Kunduz","Malden","tem_anizay","takistan"];
tropicalmaps = ["Tanoa"];
temperatemaps = ["Enoch","chernarus_summer","vt7","Tembelan"];
arcticmaps = ["Chernarus_Winter"];
//Mod selector

if(teamplayer != independent) then {//This section is for Altis Blufor ONLY!
  switch(true) do {
    case (has3CB): {
        ["Templates\NewTemplates\3CB\3CB_Reb_TPGM_Arid.sqf", independent] call A3A_fnc_compatabilityLoadFaction;
        ["Templates\NewTemplates\3CB\3CB_AI_BAF_Arid.sqf", west] call A3A_fnc_compatabilityLoadFaction;
        ["Templates\NewTemplates\3CB\3CB_AI_TKA_Arid.sqf", east] call A3A_fnc_compatabilityLoadFaction;
        ["Templates\NewTemplates\3CB\3CB_Civ.sqf", civilian]] call A3A_fnc_compatabilityLoadFaction;

    };
    case (hasRHS): {
        ["Templates\NewTemplates\RHS\RHS_Reb_NAPA_Arid.sqf", independent] call A3A_fnc_compatabilityLoadFaction;
        ["Templates\NewTemplates\RHS\RHS_AI_USAF_Army_Arid.sqf", west] call A3A_fnc_compatabilityLoadFaction;
        ["Templates\NewTemplates\RHS\RHS_AI_AFRF_Arid.sqf", east] call A3A_fnc_compatabilityLoadFaction;
        ["Templates\NewTemplates\RHS\RHS_Civ.sqf", civilian]] call A3A_fnc_compatabilityLoadFaction;

    };
    default {
        ["Templates\NewTemplates\Vanilla\Vanilla_Reb_FIA_Arid.sqf", independent] call A3A_fnc_compatabilityLoadFaction;
        ["Templates\NewTemplates\Vanilla\Vanilla_AI_NATO_Arid.sqf", west] call A3A_fnc_compatabilityLoadFaction;
        ["Templates\NewTemplates\Vanilla\Vanilla_AI_CSAT_Arid.sqf", east] call A3A_fnc_compatabilityLoadFaction;
        ["Templates\NewTemplates\Vanilla\Vanilla_Civ.sqf", civilian]] call A3A_fnc_compatabilityLoadFaction;

    };
  };
}else{//This is for non-blufor (THE ONE THAT MATTERS!!)
  switch(true) do{
    case (has3CB): {
      switch(true) do {
        case (worldName in arcticmaps): {
            ["Templates\NewTemplates\3CB\3CB_Reb_CNM_Temperate.sqf", independent] call A3A_fnc_compatabilityLoadFaction;
            ["Templates\NewTemplates\3CB\3CB_AI_BAF_Arctic.sqf", west] call A3A_fnc_compatabilityLoadFaction;
            ["Templates\NewTemplates\3CB\3CB_AI_SOV_Temperate.sqf", east] call A3A_fnc_compatabilityLoadFaction;

        case (worldName in temperatemaps): {
            ["Templates\NewTemplates\3CB\3CB_Reb_CNM_Temperate.sqf", independent] call A3A_fnc_compatabilityLoadFaction;
            ["Templates\NewTemplates\3CB\3CB_AI_BAF_Temperate.sqf", west] call A3A_fnc_compatabilityLoadFaction;
            ["Templates\NewTemplates\3CB\3CB_AI_SOV_Temperate.sqf", east] call A3A_fnc_compatabilityLoadFaction;

        };
        case (worldName in tropicalmaps): {
            ["Templates\NewTemplates\3CB\3CB_AI_CNM_Tropical.sqf", independent] call A3A_fnc_compatabilityLoadFaction;
            ["Templates\NewTemplates\3CB\3CB_AI_BAF_Tropical.sqf", west] call A3A_fnc_compatabilityLoadFaction;
            ["Templates\NewTemplates\3CB\3CB_AI_SOV_Temperate.sqf", east] call A3A_fnc_compatabilityLoadFaction;

        };
        default {
            ["Templates\NewTemplates\3CB\3CB_Reb_TTF_Arid.sqf", independent] call A3A_fnc_compatabilityLoadFaction;
            ["Templates\NewTemplates\3CB\3CB_AI_BAF_Arid.sqf", west] call A3A_fnc_compatabilityLoadFaction;
            ["Templates\NewTemplates\3CB\3CB_AI_TKM_Arid.sqf", east] call A3A_fnc_compatabilityLoadFaction;

        };
      };
        ["Templates\NewTemplates\3CB\3CB_Civ.sqf", civilian]] call A3A_fnc_compatabilityLoadFaction;

    };
    case (hasRHS): {
      switch(true) do {
        case (worldName in arcticmaps): {
            ["Templates\NewTemplates\RHS\RHS_Reb_NAPA_Temperate.sqf", independent] call A3A_fnc_compatabilityLoadFaction;
            ["Templates\NewTemplates\RHS\RHS_AI_USAF_Army_Temperate.sqf", west] call A3A_fnc_compatabilityLoadFaction;
            ["Templates\NewTemplates\RHS\RHS_AI_AFRF_Temperate.sqf", east] call A3A_fnc_compatabilityLoadFaction;

        };
        case (worldName in temperatemaps): {
            ["Templates\NewTemplates\RHS\RHS_Reb_NAPA_Temperate.sqf", independent] call A3A_fnc_compatabilityLoadFaction;
            ["Templates\NewTemplates\RHS\RHS_AI_USAF_Army_Temperate.sqf", west] call A3A_fnc_compatabilityLoadFaction;
            ["Templates\NewTemplates\RHS\RHS_AI_AFRF_Temperate.sqf", east] call A3A_fnc_compatabilityLoadFaction;

        };
        case (worldName in tropicalmaps): {
            ["Templates\NewTemplates\RHS\RHS_Reb_NAPA_Temperate.sqf", independent] call A3A_fnc_compatabilityLoadFaction;
            ["Templates\NewTemplates\RHS\RHS_AI_USAF_Army_Temperate.sqf", west] call A3A_fnc_compatabilityLoadFaction;
            ["Templates\NewTemplates\RHS\RHS_AI_AFRF_Tropical.sqf", east] call A3A_fnc_compatabilityLoadFaction;

        };
        default {
            ["Templates\NewTemplates\RHS\RHS_Reb_NAPA_Arid.sqf", independent] call A3A_fnc_compatabilityLoadFaction;
            ["Templates\NewTemplates\RHS\RHS_AI_USAF_Army_Arid.sqf", west] call A3A_fnc_compatabilityLoadFaction;
            ["Templates\NewTemplates\RHS\RHS_AI_AFRF_Arid.sqf", east] call A3A_fnc_compatabilityLoadFaction;

        };
      };
        ["Templates\NewTemplates\RHS\RHS_Civ.sqf", civilian]] call A3A_fnc_compatabilityLoadFaction;

    };
/*    case (hasIFA): {
      switch(true) do {
        case (worldName in arcticmaps): {
          call compile preProcessFileLineNumbers "Templates\IFA_Reb_POL_Arct.sqf";
          call compile preProcessFileLineNumbers "Templates\IFA_Inv_SOV_Arct.sqf";
          call compile preProcessFileLineNumbers "Templates\IFA_Occ_WEH_Arct.sqf";
        };
        case (worldName in temperatemaps): {
          call compile preProcessFileLineNumbers "Templates\IFA_Reb_POL_Temp.sqf";
          call compile preProcessFileLineNumbers "Templates\IFA_Inv_SOV_Temp.sqf";
          call compile preProcessFileLineNumbers "Templates\IFA_Occ_WEH_Temp.sqf";
        };
        case (worldName in tropicalmaps): {
          call compile preProcessFileLineNumbers "Templates\IFA_Reb_POL_Temp.sqf";
          call compile preProcessFileLineNumbers "Templates\IFA_Inv_SOV_Temp.sqf";
          call compile preProcessFileLineNumbers "Templates\IFA_Occ_WEH_Temp.sqf";
        };
        default {
          call compile preProcessFileLineNumbers "Templates\IFA_Reb_POL_Arid.sqf";
          call compile preProcessFileLineNumbers "Templates\IFA_Inv_SOV_Arid.sqf";
          call compile preProcessFileLineNumbers "Templates\IFA_Occ_WEH_Arid.sqf";
        };
      };
      call compile preProcessFileLineNumbers "Templates\IFA_Civ.sqf";
  }; */
    default {
      switch(true) do {//This one (vanilla) works differently so that we don't get DLC kit on modded maps.
        case (worldName == "Enoch"): {
            ["Templates\NewTemplates\Vanilla\Vanilla_Reb_FIA_Enoch.sqf", independent] call A3A_fnc_compatabilityLoadFaction;
            ["Templates\NewTemplates\Vanilla\Vanilla_AI_LDF_Enoch.sqf", west] call A3A_fnc_compatabilityLoadFaction;
            ["Templates\NewTemplates\Vanilla\Vanilla_AI_CSAT_Enoch.sqf", east] call A3A_fnc_compatabilityLoadFaction;

        };
        case (worldName == "Tanoa"): {
            ["Templates\NewTemplates\Vanilla\Vanilla_Reb_SDK_Tanoa.sqf", independent] call A3A_fnc_compatabilityLoadFaction;
            ["Templates\NewTemplates\Vanilla\Vanilla_AI_NATO_Tropical.sqf", west] call A3A_fnc_compatabilityLoadFaction;
            ["Templates\NewTemplates\Vanilla\Vanilla_AI_CSAT_Tropical.sqf", east] call A3A_fnc_compatabilityLoadFaction;

        };
        case (worldName in temperatemaps): {
            ["Templates\NewTemplates\Vanilla\Vanilla_Reb_FIA_Arid.sqf", independent] call A3A_fnc_compatabilityLoadFaction;
            ["Templates\NewTemplates\Vanilla\Vanilla_AI_NATO_Temperate.sqf", west] call A3A_fnc_compatabilityLoadFaction;
            ["Templates\NewTemplates\Vanilla\Vanilla_AI_CSAT_Arid.sqf", east] call A3A_fnc_compatabilityLoadFaction;

        };
        default {
            ["Templates\NewTemplates\Vanilla\Vanilla_Reb_FIA_Arid.sqf", independent] call A3A_fnc_compatabilityLoadFaction;
            ["Templates\NewTemplates\Vanilla\Vanilla_AI_NATO_Arid.sqf", west] call A3A_fnc_compatabilityLoadFaction;
            ["Templates\NewTemplates\Vanilla\Vanilla_AI_CSAT_Arid.sqf", east] call A3A_fnc_compatabilityLoadFaction;

        };
      };
        ["Templates\NewTemplates\Vanilla\Vanilla_Civ.sqf", civilian]] call A3A_fnc_compatabilityLoadFaction;

    };
  };
};
