/*
Author: Meerkat

This file handles the detection of mods.
Best practice is to detect the presence of a CfgPatches entry, but there are alternatives.
Arguments:


Return Value:


Scope: All
Environment:
Public:
Dependencies:

Example:

To add a new mod, give it a hadMod variable with the rest, then add an if (isClass) entry like the FFAA one. (You could even copy/paste the FFAA one and replace its calls with the ones you need.)
*/

//Var initialisation
private _filename = "detector.sqf";
hasRHS = false;
hasFFAA = false;
hasIFA = false;
has3CB = false;
hasIvory = false;
hasTCGM = false;
hasADV = false;
hasD3S = false;

//Actual Detection
//IFA Detection
//Deactivated for now, as IFA is having some IP problems (08.05.2020 european format)
if (isClass (configFile >> "CfgPatches" >> "LIB_Core")) then {
    //hasIFA = true;
    //[2, "IFA Detected", _fileName] call A3A_fnc_log;
    [1, "IFA detected, but it is no longer supported, please remove this mod", _fileName] call A3A_fnc_log;
    ["modUnautorized",false,1,false,false] call BIS_fnc_endMission;
};

//RHS Detection
if (isClass (configFile >> "CfgFactionClasses" >> "rhs_faction_vdv") && isClass (configFile >> "CfgFactionClasses" >> "rhs_faction_usarmy") && isClass (configFile >> "CfgFactionClasses" >> "rhsgref_faction_tla")) then {
  hasRHS = true;
  [2,"RHS Detected.",_fileName] call A3A_fnc_log;
};

//3CB Detection
if (hasRHS && (
  isClass (configfile >> "CfgPatches" >> "UK3CB_BAF_Weapons") &&
  isClass (configfile >> "CfgPatches" >> "UK3CB_BAF_Vehicles") &&
  isClass (configfile >> "CfgPatches" >> "UK3CB_BAF_Units_Common") &&
  isClass (configfile >> "CfgPatches" >> "UK3CB_BAF_Equipment") &&
  isClass (configfile >> "CfgPatches" >> "UK3CB_BAF_Factions")
) ) then {has3CB = true; [2,"3CB Detected.",_fileName] call A3A_fnc_log;

//FFAA Detection
if (isClass (configfile >> "CfgPatches" >> "ffaa_armas")) then {hasFFAA = true; [2,"FFAA Detected.",_fileName] call A3A_fnc_log;};

//Ivory Car Pack Detection
if (isClass (configfile >> "CfgPatches" >> "Ivory_Data")) then {hasIvory = true; [2,"Ivory Cars Detected.",_fileName] call A3A_fnc_log;};

//TCGM_BikeBackpack Detection
if (isClass (configfile >> "CfgPatches" >> "TCGM_BikeBackpack")) then {hasTCGM = true; diag_log format ["%1: [Antistasi] | INFO | initVar | TCGM_BikeBackpack Detected.",servertime];};
//ADV-CPR Pike Edition detection
if (hasACEMedical && isClass (configFile >> "CfgPatches" >> "adv_aceCPR")) then {hasADV = true; diag_log format ["%1: [Antistasi] | INFO | initVar | ADV-CPR Detected.",servertime];};


//D3S Car Pack Detection !!!--- Currently using vehicle classname check. Needs config viewer to work to find cfgPatches. ---!!!
if (isClass (configfile >> "CfgVehicles" >> "d3s_baumaschinen")) then {hasD3S = true; diag_log format ["%1: [Antistasi] | INFO | initVar | D3S Cars Detected.",servertime];};
