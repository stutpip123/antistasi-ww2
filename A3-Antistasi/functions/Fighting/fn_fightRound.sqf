params ["_fightNumber"];

private _fileName = "fn_fightRound";
_data = server getVariable _fightNumber;

if(simulationLevel == 0) then
{
    private _damageDealt = [[0,0,0], [0,0,0], [0,0,0]];
    private _isActive = [false, false, false];

    for "_i" from 0 to 2 do
    {
        private _side = _data select _i;
        for "_kind" from 0 to 2 do
        {
            private _units = _side select _kind;
            {
                if(!(_isActive select _i)) then
                {
                    _isActive set [_i, true];
                };
                private _damage = _x select 1;

                //Adding the damage
                _damageDealt set [_i, (_damageDealt select _i) vectorAdd _damage];
            } forEach _units;
        };
    };
    //[3, "Calculated the dealt damage for each faction", _fileName] call A3A_fnc_log;
    //[_damageDealt, "Dealt damage"] call A3A_fnc_logArray;

    //The amount of killed units per team
    private _killedUnits = [[], [], []];

    //Dealing damage
    for "_team" from 0 to 2 do
    {
        private _current = _team;
        private _enemyOne = (_team + 1) % 3;
        private _enemyTwo = (_team + 2) % 3;

        //[3, format ["Current is %1, enemies are %2 and %3", _current, _enemyOne, _enemyTwo], _fileName] call A3A_fnc_log;

        private _killCount = [0, 0, 0];
        //Check if current team is active
        if(_isActive select _current) then
        {
            private _damageEnemyOne = _damageDealt select _enemyOne;
            private _damageEnemyTwo = _damageDealt select _enemyTwo;

            if(_isActive select _enemyOne) then
            {
                if(_isActive select _enemyTwo) then
                {
                    //All active, using only half the damage
                    _killCount = (_damageEnemyOne vectorMultiply (1/2)) vectorAdd (_damageEnemyTwo vectorMultiply (1/2));
                }
                else
                {
                    //Only occupants active
                    _killCount = +(_damageEnemyOne);
                };
            }
            else
            {
                //Only invaders active
                _killCount = +(_damageEnemyTwo);
            };
        };
        //Round numbers (can't have 0.4 death units)
        _killCount set [0, round (_killCount select 0)];
        _killCount set [1, round (_killCount select 1)];
        _killCount set [2, round (_killCount select 2)];

        [3, format ["Killed units for %1 are %2", _current, str _killCount], _fileName] call A3A_fnc_log;

        //Save data
        _killedUnits set [_current, _killCount];
    };

    //Deleting units
    for "_team" from 0 to 2 do
    {
        private _killCount = _killedUnits select _team;
        private _allUnits = _data select _team;
        for "_kind" from 0 to 2 do
        {
            private _count = _killCount select _kind;
            private _units = _allUnits select _kind;
            if(_count >= count _units) then
            {
                _allUnits set [_kind, []];
            }
            else
            {
                for "_i" from 1 to _count do
                {
                    _units deleteAt 0;
                };
            };
        };
    };

    private _winner = [_data] call A3A_fnc_calculateWinner;

    if(_winner == -1) then
    {
        //Not sure if really needed
        server setVariable [_fightNumber, _data];

        [3, "Fight has not yet finished, readding the data to the fight loop!", _fileName] call A3A_fnc_log;
        private _allFights = server getVariable ["fightArray", []];
        _allFights pushBack [_fightNumber ,time + 15];
    }
    else
    {
        if(_winner == 3) then
        {
            [3, format ["%1 has no winner, all units are dead, war is cruel", _fightNumber], _fileName] call A3A_fnc_log;
        }
        else
        {
            [3, format ["Side %1 has won the fight, erasing data", _winner], _fileName] call A3A_fnc_log;
        };
        server setVariable [_fightNumber, nil];
    };
};
















/*

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
*/
