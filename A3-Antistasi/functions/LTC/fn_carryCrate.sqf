params ["_crate", "_pickUp"];

if (_pickUp) then {
	_attachedObj = (attachedObjects player)select {!(_x isEqualTo objNull)};
	if !(count _attachedObj == 0) exitWith {systemChat "you are already carrying something."};
	_crate attachTo [player, [0, 1.5, 0], "Pelvis"];
	_crate setVariable ["pickedUp", player, true];
	player setVariable ["carryingCrate", true, true];
	player forceWalk true;
	[player ,_crate] spawn { 
		params ["_player", "_crate"];
		waitUntil {(!alive _crate) or !(_player getVariable ["carryingCrate", false])};
		_player forceWalk false;
		_player setVariable ["carryingCrate", nil, true];
	};
} else {
	_attached = (attachedObjects player)select {(typeOf _x) isEqualTo "Box_IND_Wps_F"};
	_crate = _attached#0;
	private "_pos";
	if !(isNil "_crate") then {
		detach _crate;
		_crate setVariable ["pickedUp", nil, true];
		_crate setVelocity [0,0,0.3];
	};
	player setVariable ["carryingCrate", nil, true];
	player forceWalk false;
};