/*  Sorting the weapons into the given arrays
*   Params:
*       Nothing
*
*   Returns:
*       Nothing
*/
private _fileName = "sortWeaponsByWells";
[[],[],[],[]] params ["_invaderWeapons", "_occupantsWeapons", "_rebelWeapons", "_unusedWeapons"];

private _allWeapons = [];
switch (true) do
{
    case (false):
    {
        //RHS case
    };
    case (false):
    {
        //IFA case
    };
    default
    {
        //Vanilla case
        [3, "Vanilla case detected!", _fileName] call A3A_fnc_log;
        //Get all the base weapons
        _allWeapons = ("true" configClasses (configFile >> "CfgWeapons")) apply {configName _x};
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

        //TODO DLC check currently missing
    };
};

[3, format ["Found %1 base weapons", count _allWeapons], _fileName] call A3A_fnc_log;

[
    missionNamespace getVariable "Invaders_wells",
    missionNamespace getVariable "Occupants_wells",
    missionNamespace getVariable "Rebels_wells"
] params ["_invaderWells", "_occupantsWells", "_rebelWells"];
private _mags = missionNamespace getVariable "weaponMags";

{
    private _weapon = _x;
    private _sortedIn = false;
    [3, format ["Checking weapon %1 now", getText(configFile >> "CfgWeapons" >> _weapon >> "displayName")], _fileName] call A3A_fnc_log;
    private _weaponWells = [(configFile >> "CfgWeapons" >> _x), "magazineWell", []] call BIS_fnc_returnConfigEntry;
    private _magazines = getArray (configFile >> "CfgWeapons" >> _x >> "magazines");
    {
        private _mag = _x;
        private _magIndex = _mags findIf {_mag in (_x select 1)};
        if(_magIndex != -1) then
        {
            _weaponWells pushBackUnique ((_mags select _magIndex) select 0);
        }
        else
        {
            _weaponWells pushBackUnique _mag;
        };
    } forEach _magazines;
    [3, format ["%1 mag wells are: %2", _weapon, _weaponWells], _fileName] call A3A_fnc_log;
    {
        private _well = _x;
        if(_well in _invaderWells) then
        {
            _invaderWeapons pushBackUnique _weapon;
            _sortedIn = true;
            //diag_log format ["%1 sorted into east", _weapon];
        };
        if(_well in _occupantsWells) then
        {
            _occupantsWeapons pushBackUnique _weapon;
            _sortedIn = true;
            //diag_log format ["%1 sorted into west", _weapon];
        };
        if(_well in _rebelWells) then
        {
            _rebelWeapons pushBackUnique _weapon;
            _sortedIn = true;
            //diag_log format ["%1 sorted into ind", _weapon];
        };
    } forEach _weaponWells;
    if !(_sortedIn) then
    {
        _unusedWeapons pushBack _weapon
    }
} forEach _allWeapons;
[3, format ["Checked all weapons, %2 east, %3 west, %4 ind and %5 unused", count _invaderWeapons, count _occupantsWeapons, count _rebelWeapons, count _unusedWeapons], _fileName] call A3A_fnc_log;

private _weapons = [_invaderWeapons, _occupantsWeapons, _rebelWeapons, _unusedWeapons];

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
