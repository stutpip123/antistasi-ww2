


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
    diag_log format ["%1 mag wells are: %2", _weapon, _weaponWells];
    {
        private _well = _x;
        private _inserted = 0;
        if(_well in _eastMagWells) then
        {
            _eastWeapons pushBackUnique _weapon;
            diag_log format ["%1 sorted into east", _weapon];
            _inserted = _inserted + 1;
        };
        if(_well in _westMagWells) then
        {
            _westWeapons pushBackUnique _weapon;
            diag_log format ["%1 sorted into west", _weapon];
            _inserted = _inserted + 1;
        };
        if(_well in _indMagWells) then
        {
            _indWeapons pushBackUnique _weapon;
            diag_log format ["%1 sorted into ind", _weapon];
            _inserted = _inserted + 1;
        };
        if(_inserted == 0) then
        {
            _unusedWeapons pushBackUnique _weapon;
            diag_log format ["%1 sorted into unused", _weapon];
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
