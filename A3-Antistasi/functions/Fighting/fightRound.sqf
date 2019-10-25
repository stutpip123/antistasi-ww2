//Gather all units which are currently in the fight
//Needed information [[SIDE, [UnitData]], [SIDE, [UnitData]]]
//UnitData = [[Comp1, pos], [Comp2, pos], [Comp3, pos]]
//CompX = [Unit1, Unit2, Vehicle1]
//UnitX/VehicleX = [type, health, attacks, weapons, actions, boni, mali]
//attacks = [[0, weapon], [3, weapon], [4, weapon]
//weapons = [weapon1, currentMag, ammo, ammoType]
//Ammotype = [name, airFrcition, damge, penetration, ...]

//Categorize the units
private _occupantsHaveAir = false;
private _occupantsHaveArmor = false;
private _occupantsHaveLand = false;
private _occuapntsHaveStatic = false;
private _occupantsHaveMan = false;
private _occupantsTypes = [_occupantsHaveAir, _occupantsHaveArmor, _occupantsHaveLand, _occuapntsHaveStatic, _occupantsHaveMan];

private _invadersHaveAir = false;
private _invadersHaveArmor = false;
private _invadersHaveLand = false;
private _invadersHaveStatic = false;
private _invadersHaveMan = false;
private _invadersTypes = [_invadersHaveAir, _invadersHaveArmor, _invadersHaveLand, _invadersHaveStatic, _invadersHaveMan];

private _rebelsHaveAir = false;
private _rebelsHaveArmor = false;
private _rebelsHaveLand = false;
private _rebelsHaveStatic = false;
private _rebelsHaveMan = false;
private _rebelsTypes = [_rebelsHaveAir, _rebelsHaveArmor, _rebelsHaveLand, _rebelsHaveStatic, _rebelsHaveMan];

//Gets the types of enemy the faction is fighting against
private _occupantsTargets = [_invadersTypes, _rebelsTypes] call A3A_fnc_getTargetTypes;
private _invadersTargets = [_occupantsTypes, _rebelsTypes] call A3A_fnc_getTargetTypes;
private _rebelsTargets = [_occupantsTypes, _invadersTypes] call A3A_fnc_getTargetTypes;

//Foreach units
//  Move squad/vehicle
//  Select action
//  Specify action
//  Select target (if needed)
//Execute round damage
//Create enviroment damage
//Save all data
