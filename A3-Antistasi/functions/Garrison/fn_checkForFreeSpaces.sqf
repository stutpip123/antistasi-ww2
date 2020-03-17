params ["_marker"];

private _hasFreeSpace = [false, false];

private _currentPlaces = spawner getVariable (format ["%1_current", _marker]);
private _availablePlaces = spawner getVariable (format ["%1_available", _marker]);

if((_availablePlaces select 0) > (_currentPlaces select 0)) then
{
    _hasFreeSpace set [0, true];
};

if((_availablePlaces select 1) > (_currentPlaces select 1)) then
{
    _hasFreeSpace set [1, true];
};

_hasFreeSpace;
