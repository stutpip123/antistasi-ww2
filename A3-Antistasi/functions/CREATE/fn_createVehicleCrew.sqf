/*
    File: fn_createVehicleCrew.sqf
    Author: Spoffy
    Date: 2021-02-13
    Last Update: 2021-02-13
    Public: No
    
    Description:
		Creates a crew for the given vehicle.
    
    Parameter(s):
		_group - Existing group to add units to, or side to create group on [GROUP/SIDE]
		_vehicle - Vehicle to create crew for [OBJECT]
		_unitType - Type of unit to create [STRING]
    
    Returns:
		_group - Group with crew members [GROUP]
    
    Example(s):
		[west, _myVehicle, NATOCrew] call A3A_fnc_createVehicleCrew;
*/

params ["_group", "_vehicle", "_unitType"];

private _newGroup = false;
if (_group isEqualType sideUnknown) then {
	_group = createGroup _group;
	_newGroup = true;
};

private _type = typeOf _vehicle;
private _config = configFile >> "CfgVehicles" >> _type;
if (getNumber (_config >> "hasDriver") > 0) then {
	private _driver = [_group, _unitType, getPos _vehicle, [], 10] call A3A_fnc_createUnit;
	_driver assignAsDriver _vehicle;
	_driver moveInDriver _vehicle;
};

private _fnc_addCrewToTurrets = {
	params ["_config", ["_path", []]];
	private _turrets = "getNumber (_x >> 'hasGunner') > 0 && getNumber (_x >> 'dontCreateAI') == 0" configClasses (_config >> "Turrets");
	{
		private _turretConfig = _x;
		private _turretPath = _path + [_forEachIndex];
		private _gunner = [_group, _unitType, getPos _vehicle, [], 10] call A3A_fnc_createUnit;
		_gunner assignAsTurret [_vehicle, _turretPath];
		_gunner moveInTurret [_vehicle, _turretPath];
		//Handle nested turrets
		[_turretConfig, _turretPath] call _fnc_addCrewToTurrets;
	} forEach _turrets;
};

[_config] call _fnc_addCrewToTurrets;

if (_newGroup) then {
	_group selectLeader (commander _vehicle);
};

_group addVehicle _vehicle;

_group