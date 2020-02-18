/*  Creates a list of mag wells used by the factions
*   Params:
*       Nothing
*
*   Returns:
*       Nothing
*/
private _fileName = "createMagWellData";

private _sides = [resistance, east, west];
private _invaderNumber = [east, west, resistance] find (_sides select 0);
private _occupantsNumber = [east, west, resistance] find (_sides select 1);
private _rebelNumber = [east, west, resistance] find (_sides select 2);

//Get the magazineWells and prepares the arrays
private _magWells = ("true" configClasses (configFile >> "CfgMagazineWells")) apply {configName _x};
[[],[],[],[]] params ["_westMagWells", "_eastMagWells", "_indMagWells", "_noneMagWells"];
[3, format ["Found %1 mag wells in the config", count _magWells], _fileName] call A3A_fnc_log;

//Get the unit data and prepares the arrays
//private _allUnits = "getText (_x >> 'vehicleClass') == 'Men'" configClasses (configFile >> "CfgVehicles");
private _allUnits =
"((configName _x) isKindOf 'Man') &&
 {getText (_x >> 'vehicleClass') != 'MenStory' &&
 {!((getText (_x >> 'faction')) in ['BLU_G_F', 'OPF_G_F', 'IND_G_F'])}}" configClasses (configFile >> "CfgVehicles");
[[],[],[]] params ["_westUnits", "_eastUnits", "_indUnits"];
{
    private _name = configName _x;
    private _side = getNumber (_x >> "side");
    switch (_side) do
    {
        case (_invaderNumber): {_eastUnits pushBack _name;};
        case (_occupantsNumber): {_westUnits pushBack _name;};
        case (_rebelNumber): {_indUnits pushBack _name;};
    };
} forEach _allUnits;
[3, format ["Found %1 unit classes, %2 east %3 west %4 ind", count _allUnits, count _eastUnits, count _westUnits, count _indUnits], _fileName] call A3A_fnc_log;

//Save the mags for later use
private _mags = [];
{
    _mags pushBack [_x, (getArray(configfile >> "CfgMagazineWells" >> _x >> "BI_Magazines") + getArray(configfile >> "CfgMagazineWells" >> _x >> "BI_Enoch_Magazines"))];
} forEach _magWells;
missionNamespace setVariable ["weaponMags", _mags];
[3, "Mags saved to server for later use", _fileName] call A3A_fnc_log;

//Sorting mags from units now
private _units = [_eastUnits, _westUnits, _indUnits];
private _sideWells = [_eastMagWells, _westMagWells, _indMagWells];
for "_i" from 0 to 2 do
{
    private _subArray = _units select _i;
    private _sideWell = _sideWells select _i;
    {
        private _unit = _x;
        //[3, format ["Checking %1 now", _unit], _fileName] call A3A_fnc_log;
        private _weapons = getArray (configFile >> "CfgVehicles" >> _x >> "weapons");
        _weapons = _weapons - ["Throw", "Put"];
        {
            private _weapon = _x;
            private _magazines = getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines");
            private _weaponWells = [(configFile >> "CfgWeapons" >> _weapon), "magazineWell", []] call BIS_fnc_returnConfigEntry;
            {
                private _mag = _x;
                private _magIndex = _mags findIf {_mag in (_x select 1)};
                if(_magIndex != -1) then
                {
                    _weaponWells pushBackUnique ((_mags select _magIndex) select 0);
                }
                else
                {
                    //[2, format ["%1 of %2 does not have a related mag well, adding mag as magWell!", _mag, _weapon], _fileName] call A3A_fnc_log;
                    _weaponWells pushBackUnique _mag;
                };
            } forEach _magazines;
            //[3, format ["%1 mag wells are: %2", _weapon, _weaponWells], _fileName] call A3A_fnc_log;
            {
                _sideWell pushBackUnique _x;
                if(_x in _magWells) then
                {
                    _magWells = _magWells - [_x];
                };
            } forEach _weaponWells;
        } forEach _weapons;
    } forEach _subArray;
};

_noneMagWells = _magWells;

diag_log format ["Found %1 Invader wells, %2 Occupant wells, %3 Rebel wells, %4 not used by a specific faction", count (_sideWells select 0), count (_sideWells select 1), count (_sideWells select 2), count _magWells];

{
    private _name = ["Invader", "Occupants", "Rebel", "Unused"] select _forEachIndex;
    [3, format ["%1 well: %2", _name, _x], _fileName] call A3A_fnc_log;
} forEach (_sideWells + [_magWells]);
