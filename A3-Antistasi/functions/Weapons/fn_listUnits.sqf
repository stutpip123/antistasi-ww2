private _allUnits = "getText (_x >> 'vehicleClass') == 'Men'" configClasses (configFile >> "CfgVehicles");

private _blueUnits = [];
private _redUnits = [];
private _greenUnits = [];

{
    private _name = configName _x;
    private _side = getNumber (configFile >> "CfgVehicles" >> _name >> "side");
    switch (_side) do
    {
        case (0):
        {
            _redUnits pushBack _name;
        };
        case (1):
        {
            _blueUnits pushBack _name;
        };
        case (2):
        {
            _greenUnits pushBack _name;
        };
    };
} forEach _allUnits;

private _allWeapons = [];
{
    _allWeapons pushBack (configName _x);
} forEach ("([_x, 'baseWeapon', ''] call BIS_fnc_returnConfigEntry) == (configName _x)" configClasses (configFile >> "CfgWeapons"));
hint format ["Found %1 base weapons", count _allWeapons];

private _blueWeapons = [];
private _redWeapons = [];
private _greenWeapons = [];
private _otherWeapons = [];

{
    private _unit = _x;
    private _weapons = getArray (configFile >> "CfgVehicles" >> _x >> "weapons");
    {
        private _base = [configFile >> "CfgWeapons" >> _x, 'baseWeapon', ''] call BIS_fnc_returnConfigEntry;
        if(_base != "") then
        {
            diag_log format ["%1 uses %2", _unit, _base];
            _blueWeapons pushBack _base;
            if(_base in _allWeapons) then
            {
                _allWeapons = _allWeapons - [_base];
            };
        };
    } forEach _weapons;
} forEach _blueUnits;

diag_log str _blueWeapons;

{
    private _unit = _x;
    private _weapons = getArray (configFile >> "CfgVehicles" >> _x >> "weapons");
    {
        private _base = [configFile >> "CfgWeapons" >> _x, 'baseWeapon', ''] call BIS_fnc_returnConfigEntry;
        if(_base != "") then
        {
            diag_log format ["%1 uses %2", _unit, _base];
            _redWeapons pushBack _base;
            if(_base in _allWeapons) then
            {
                _allWeapons = _allWeapons - [_base];
            };
        };
    } forEach _weapons;
} forEach _redUnits;

diag_log str _redWeapons;

{
    private _unit = _x;
    private _weapons = getArray (configFile >> "CfgVehicles" >> _x >> "weapons");
    {
        private _base = [configFile >> "CfgWeapons" >> _x, 'baseWeapon', ''] call BIS_fnc_returnConfigEntry;
        if(_base != "") then
        {
            diag_log format ["%1 uses %2", _unit, _base];
            _greenWeapons pushBack _base;
            if(_base in _allWeapons) then
            {
                _allWeapons = _allWeapons - [_base];
            };
        };
    } forEach _weapons;
} forEach _greenUnits;

diag_log str _greenWeapons;

diag_log str _allWeapons;
