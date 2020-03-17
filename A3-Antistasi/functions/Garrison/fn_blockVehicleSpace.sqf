params ["_marker", "_vehicle"];

private _index = -1;
if(_vehicle isKindOf "LandVehicle") then
{
    _index = 0;
}
else
{
    if(_vehicle isKindOf "Helicopter" && {(_vehicle != vehNATOUAVSmall) && (_vehicle != vehCSATUAVSmall)}) then
    {
        _index = 1;
    }
    else
    {
        if(_vehicle isKindOf "Plane" || {(_vehicle == vehNATOUAVSmall) || (_vehicle == vehCSATUAVSmall)}) then
        {
            _index = 2;
        };
    };
};

if(_index == -1) exitWith {false};

private _currentPlaces = spawner getVariable (format ["%1_current", _marker]);
private _availablePlaces = spawner getVariable (format ["%1_available", _marker]);

private _blocked = false;
if((_availablePlaces select _index) > (_currentPlaces select _index)) then
{
    _currentPlaces set [_index, (_currentPlaces select _index) + 1];
    _blocked = true;
};

_blocked;
