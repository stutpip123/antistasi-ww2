params ["_vehicle"];

//If vehicle already has an airspace control script, exit here
if(_vehicle getVariable ["airspaceControl", -1] != -1) exitWith {};

private _random = round (random 1000);
_vehicle setVariable ["airspaceControl", _random, true];
