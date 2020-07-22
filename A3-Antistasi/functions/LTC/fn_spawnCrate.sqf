params ["_unit"];
_money = player getVariable "moneyX";
if (_money < 10) exitWith {["Loot crate", "You cant afford a loot crate"] call A3A_fnc_customHint};
player setVariable ["moneyX", _money -10, true];
[] spawn A3A_fnc_statistics;
["Loot crate", "Loot crate bought"] call A3A_fnc_customHint;
//spawn crate
private _crate = "Box_IND_Wps_F" createVehicle getPos _unit;
_crate allowDamage false;
clearMagazineCargoGlobal _crate;
clearWeaponCargoGlobal _crate;
clearItemCargoGlobal _crate;
clearBackpackCargoGlobal _crate;