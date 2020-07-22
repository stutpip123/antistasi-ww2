params ["_container"];
scopeName "Main";

private "_unlocked";
if (LTCLootUnlocked) then {
	_unlocked = [];
} else {
	_unlocked = (unlockedHeadgear + unlockedVests + unlockedNVGs + unlockedOptics + unlockedItems + unlockedWeapons + unlockedBackpacks + unlockedMagazines);
};

//----------------------------//
//Loot Bodies
//----------------------------//
_lootBodies = {
	params ["_unit", "_container"];
	private _gear = [[],[],[],[]];//weapons, mags, items, backpacks
	
	//build list of all gear
	_weapons = [handgunWeapon _unit];
	_attachments = handgunItems _unit;

	_weapons = _weapons select {!(_x isEqualTo "")};
	{(_gear#0) pushBack (_x call BIS_fnc_baseWeapon)} forEach _weapons;
	_attachments = _attachments select {!(_x isEqualTo "")};
	(_gear#2) append _attachments;

	(_gear#2) append assignedItems _unit;
	removeAllAssignedItems _unit;

	(_gear#1) append (magazinesAmmoFull _unit);
	clearMagazineCargoGlobal _unit;

	(_gear#2) append (items _unit);
	clearItemCargoGlobal _unit;

	if !(vest _unit isEqualTo "") then {
		(_gear#2) pushBack (vest _unit);
		removeVest _unit;
	};

	if !(headgear _unit isEqualTo "") then {
		(_gear#2) pushBack (headgear _unit);
		removeHeadgear _unit;
	};

	if !(goggles _unit isEqualTo "") then {
		(_gear#2) pushBack (goggles _unit);
		removeGoggles _unit;
	};

	if !(backpack _unit isEqualTo "") then {
		(_gear#3) pushBack ((backpack _unit) call BIS_fnc_basicBackpack);
		removeBackpackGlobal _unit;
	};

	//to ensure proper cleanup
	removeAllWeapons _unit;
	removeAllItems _unit;

	//try to add items to container
	_remaining = _gear;
	{
		if ((_container canAdd _x) and !(_x in _unlocked)) then {
			_container addWeaponCargoGlobal [_x,1];
			_remaining set [0,(_remaining#0) - [_x]];
		};		
	} forEach (_gear#0);

	{
		_magType = _x#0;
		_ammoCount = _x#1;
		if ((_container canAdd _magType) and !(_magType in _unlocked)) then {
			_container addMagazineAmmoCargo [_magType, 1, _ammoCount];
			_remaining set [1,(_remaining#1) - [_x]];
		};			
	} forEach (_gear#1);

	{
		if ((_container canAdd _x) and !(_x in _unlocked)) then {
			_container addItemCargoGlobal [_x,1];
			_remaining set [2,(_remaining#2) - [_x]];
		};		
	} forEach (_gear#2);

	{
		if ((_container canAdd _x) and !(_x in _unlocked)) then {
			_container addBackpackCargoGlobal [_x,1];
			_remaining set [3,(_remaining#3) - [_x]];
		};		
	} forEach (_gear#3);

	//Deal with leftovers
	if (_remaining isEqualTo [[],[],[],[]]) exitWith {};
	_pos = getPos _unit;
	_container = "GroundWeaponHolder" createVehicle _pos;
	{
		_container addWeaponCargoGlobal [_x, 1];	
	} forEach (_remaining#0);

	{
		_container addMagazineAmmoCargo [(_x#0), 1, (_x#1)];
	} forEach (_remaining#1);

	{
		_container addItemCargoGlobal [_x, 1];
	} forEach (_remaining#2);

	{
		_container addBackpackCargoGlobal [_x, 1];
	} forEach (_remaining#3);
	_container setPos _pos;
};

_targets = nearestObjects [getpos _container, ["Man"], 10, true]; //2d because it dosnt pick up bodies when not on ground otherwise
_targets = _targets select {!alive _x};
{[_x, _container] call _lootBodies} forEach _targets;


//----------------------------//
//pickup weapons on the ground
//----------------------------//
_weaponHolders = nearestObjects [getpos _container, ["WeaponHolder","WeaponHolderSimulated"], 10, true];
_lootedAll = true;
{
	_pos = getPos _x;
	_remainder = [_x, _container] call A3A_fnc_lootFromContainer;
	if !(_remainder isEqualTo [[],[],[],[]]) then {
		{
			_array = _x;
			if ((_array#0) isEqualType "") then {
				if (_array findIf {!(_x in _unlocked)} != -1) then {_lootedAll = false};
			} else {
				if (_array findIf {!((_x#0) in _unlocked)} != -1) then {_lootedAll = false};
			};			
		} forEach _remainder;
		_container = "GroundWeaponHolder" createVehicle _pos;
		{
			_container addWeaponCargoGlobal [_x, 1];	
		} forEach (_remainder#0);

		{
			_container addMagazineAmmoCargo [(_x#0), 1, (_x#1)];
		} forEach (_remainder#1);

		{
			_container addItemCargoGlobal [_x, 1];
		} forEach (_remainder#2);

		{
			_container addBackpackCargoGlobal [_x, 1];
		} forEach (_remainder#3);
		_container setPos _pos;
	};
} forEach _weaponHolders;
if (_lootedAll) then {
	["Loot crate", "Nearby loot transfered to crate"] call A3A_fnc_customHint;
} else {
	["Loot crate", "some loot transfered to crate"] call A3A_fnc_customHint;
};