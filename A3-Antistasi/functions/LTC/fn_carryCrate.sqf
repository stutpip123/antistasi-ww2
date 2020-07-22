params ["_crate", "_pickUp"];

if (_pickUp) then {
	_attachedObj = (attachedObjects player)select {!(_x isEqualTo objNull)};
	if !(count _attachedObj == 0) exitWith {systemChat "you are already carrying something."};
	_crate attachTo [player, [0, 1, 0], "Pelvis"];
	_crate setVariable ["pickedUp", player, true];
	player setVariable ["carryingCrate", true, true];
	player forceWalk true;
} else {
	_attached = (attachedObjects player)select {(typeOf _x) isEqualTo "Box_IND_Wps_F"};
	_crate = _attached#0;
	detach _crate;
	_crate setVariable ["pickedUp", nil, true];
	player setVariable ["carryingCrate", nil, true];
	_pos = getPos _crate;
	_crate setPos [_pos#0, _pos#1, 0];
	player forceWalk false;
};