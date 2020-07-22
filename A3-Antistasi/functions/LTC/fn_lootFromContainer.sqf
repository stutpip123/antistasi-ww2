params ["_target", "_overideTo"];
_vehicle = (_target nearEntities [["Car", "Motorcycle", "Tank"], 10])#0;
if (!isNil "_overideTo") then {_vehicle = _overideTo};
if (isNil "_vehicle") exitWith {["Loot crate", "No vehicles close enough"] call A3A_fnc_customHint};

_MainContainer = _target;
private "_unlocked";
if (LTCLootUnlocked) then {
	_unlocked = [];
} else {
	_unlocked = (unlockedHeadgear + unlockedVests + unlockedNVGs + unlockedOptics + unlockedItems + unlockedWeapons + unlockedBackpacks + unlockedMagazines);
};

_LootContainer = {
	params ["_target"];
	//get cargo
	_cargo = [];
	//weapons
	_cargo pushBack weaponsItemsCargo _target;
	clearWeaponCargoGlobal _target;

	//mags
	_cargo pushBack magazinesAmmoCargo _target;
	clearMagazineCargoGlobal _target;

	//items
	_cargo pushBack itemCargo _target;
	clearItemCargoGlobal _target;

	//backpacks
	_backpacks = [];
	{_backpacks pushBack (_x call BIS_fnc_basicBackpack)} forEach (backpackCargo _target);
	_cargo pushBack _backpacks;
	clearBackpackCargoGlobal _target;

	//add to vehicle
	_remaining = [];
	_weapons = [];
	{
		_baseWeapon = (_x#0) call BIS_fnc_baseWeapon;
		_weapons pushBack _baseWeapon;
		_attachments = _x select {(_x isEqualType "") and !(_x isEqualTo "")};
		_attachments deleteAt (_attachments find (_x#0));//remove weapon from list
		(_cargo#2) append _attachments;
		_mags = _x select {(_x isEqualType []) and !(_x isEqualTo [])};
		(_cargo#1) append _mags;

		if ((_vehicle canAdd _baseWeapon) and !(_baseWeapon in _unlocked)) then {
			_vehicle addWeaponCargoGlobal [_baseWeapon, 1];
			_weapons deleteAt (_weapons find _baseWeapon);
		};		
	} forEach (_cargo#0);
	_remaining pushBack _weapons;

	_mags = _cargo#1;
	{
		_magType = _x#0;
		_ammoCount = _x#1;
		if ((_vehicle canAdd _magType) and !(_magType in _unlocked)) then {
			_vehicle addMagazineAmmoCargo [_magType, 1, _ammoCount];
			_mags = _mags - [_x];
		};		
	} forEach (_cargo#1);
	_remaining pushBack _mags;

	_items = _cargo#2;
	{
		if ((_vehicle canAdd _x) and !(_x in _unlocked)) then {
			_vehicle addItemCargoGlobal [_x, 1];
			_items = _items - [_x];
		};		
	} forEach (_cargo#2);
	_remaining pushBack _items;

	_backpacks = _cargo#3;
	{
		if ((_vehicle canAdd _x) and !(_x in _unlocked)) then {
			_vehicle addBackpackCargoGlobal [_x, 1];
			_backpacks = _backpacks - [_x];
		};		
	} forEach (_cargo#3);
	_remaining pushBack _backpacks;

	//put remainder back
	if ((_remaining isEqualTo [[],[],[],[]]) and (isNil "_overideTo")) exitWith {_remaining};

	{
		_MainContainer addWeaponCargoGlobal [_x, 1];	
	} forEach (_remaining#0);

	{
		_MainContainer addMagazineAmmoCargo [(_x#0), 1, (_x#1)];
	} forEach (_remaining#1);

	{
		_MainContainer addItemCargoGlobal [_x, 1];
	} forEach (_remaining#2);

	{
		_MainContainer addBackpackCargoGlobal [_x, 1];
	} forEach (_remaining#3);
	_remaining;
};

_subContainers = everyContainer _target;
if !(_subContainers isEqualTo []) then {
	{
		_subContainer = _x#1;
		_remaining = [_subContainer] call _LootContainer;
	} forEach _subContainers;
};
_remaining = [_target] call _LootContainer;
if (isNil "_overideTo") then {
	_lootedAll = true;
	{
		_array = _x;
		if ((_array#0) isEqualType "") then {
			if (_array findIf {!(_x in _unlocked)} != -1) then {_lootedAll = false};
		} else {
			if (_array findIf {!((_x#0) in _unlocked)} != -1) then {_lootedAll = false};
		};
	} forEach _remaining;
	if (
			!(_remaining isEqualTo [[],[],[],[]])
			and !_lootedAll
		) then {
		["Loot crate", format ["some loot transfered to %1, remainder still in crate", [configFile >> "CfgVehicles" >> typeOf _vehicle] call BIS_fnc_displayName]] call A3A_fnc_customHint;
	} else {
		["Loot crate", format ["Loot transfered to %1", [configFile >> "CfgVehicles" >> typeOf _vehicle] call BIS_fnc_displayName]] call A3A_fnc_customHint;
	};
};
_remaining;
