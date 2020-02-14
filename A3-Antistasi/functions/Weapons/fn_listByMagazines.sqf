//Get the magazineWells and prepares the arrays
private _magWells = ("true" configClasses (configFile >> "CfgMagazineWells")) apply {configName _x};
[[],[],[],[]] params ["_westMagWells", "_eastMagWells", "_indMagWells", "_noneMagWells"];
diag_log format ["Found %1 magazine wells", count _magWells];

//Get the unit data and prepares the arrays
private _allUnits = "getText (_x >> 'vehicleClass') == 'Men'" configClasses (configFile >> "CfgVehicles");
[[],[],[]] params ["_westUnits", "_eastUnits", "_indUnits"];
{
    private _name = configName _x;
    private _side = getNumber (_x >> "side");
    switch (_side) do
    {
        case (0): {_eastUnits pushBack _name;};
        case (1): {_westUnits pushBack _name;};
        case (2): {_indUnits pushBack _name;};
    };
} forEach _allUnits;
diag_log format ["Found %1 unit classes, %2 east %3 west %4 ind", count _allUnits, count _eastUnits, count _westUnits, count _indUnits];


private _units = [_eastUnits, _westUnits, _indUnits];
private _sideWells = [_eastMagWells, _westMagWells, _indMagWells];
for "_i" from 0 to 2 do
{
    private _subArray = _units select _i;
    private _sideWell = _sideWells select _i;
    {
        private _unit = _x;
        private _weapons = getArray (configFile >> "CfgVehicles" >> _x >> "weapons");
        {
            private _weaponWells = [(configFile >> "CfgWeapons" >> _x), "magazineWell", []] call BIS_fnc_returnConfigEntry;
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

diag_log format ["Found %1 east wells, %2 west wells, %3 ind wells, %4 not used by a specific faction", count (_sideWells select 0), count (_sideWells select 1), count (_sideWells select 2), count _magWells];

{
    diag_log (str _x);
} forEach (_sideWells + [_magWells]);


[[],[],[],[]] params ["_eastWeapons", "_westWeapons", "_indWeapons", "_unusedWeapons"];

//Get all the base weapons
private _allWeapons = ("true" configClasses (configFile >> "CfgWeapons")) apply {configName _x};
diag_log format ["Found %1 entries on weapons", count _allWeapons];
_allWeapons = _allWeapons select
{
    (_x isKindOf ["Rifle_Base_F", configFile >> "CfgWeapons"] ||
    {_x isKindOf ["Pistol_Base_F", configFile >> "CfgWeapons"] ||
    {_x isKindOf ["Launcher_Base_F", configFile >> "CfgWeapons"]}}) &&
    {!(isClass (configFile >> "CfgWeapons" >> _x >> "LinkedItems"))}
};

//Getting out all the base classes, maybe there is a better way, but I don't know
_allWeapons = _allWeapons select
{
    getText(configFile >> "CfgWeapons" >> _x >> "displayName") != "Rifle" &&
    {getText(configFile >> "CfgWeapons" >> _x >> "displayName") != ""}
};
diag_log format ["Found %1 base weapons", count _allWeapons];

private _counter = 0;
private _weapons = [_eastWeapons, _westWeapons, _indWeapons, _unusedWeapons];
{
    _counter = _counter + 1;
    private _weapon = _x;
    diag_log format ["Checking weapon %2/%1 now", getText(configFile >> "CfgWeapons" >> _weapon >> "displayName"), _weapon];
    private _result = 3;
    private _weaponWells = [(configFile >> "CfgWeapons" >> _x), "magazineWell", []] call BIS_fnc_returnConfigEntry;
    {
        private _well = _x;
        private _inserted = 0;
        if(_well in _eastMagWells) then
        {
            _eastWeapons pushBackUnique _weapon;
            _inserted = _inserted + 1;
        };
        if(_well in _westMagWells) then
        {
            _westWeapons pushBackUnique _weapon;
            _inserted = _inserted + 1;
        };
        if(_well in _indMagWells) then
        {
            _indWeapons pushBackUnique _weapon;
            _inserted = _inserted + 1;
        };
        if(_inserted == 0) then
        {
            _unusedWeapons pushBackUnique _weapon;
        };
    } forEach _weaponWells;
} forEach _allWeapons;
diag_log format ["Checked %1 weapons, %2 east, %3 west, %4 ind and %5 unused", _counter, count _eastWeapons, count _westWeapons, count _indWeapons, count _unusedWeapons];

{
    private _names = _x apply {getText (configFile >> "CfgWeapons" >> _x >> "displayName")};
    private _counter = 0;
    diag_log "[";
    private _text = "";
    {
        if(_counter > 5) then
        {
            _counter = 0;
            diag_log _text;
            _text = "";
        }
        else
        {
            _text = format ["%1 %2,", _text, _x];
            _counter = _counter + 1;
        };
    } forEach _names;
    diag_log "]";
} forEach _weapons;
