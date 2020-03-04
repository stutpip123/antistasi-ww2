params ["_marker", "_type"];

private _fileName = "removeFromSpawnedArrays";
if (spawner getVariable [format ["%1_arraysChanging", _marker], false]) then
{
    waitUntil {sleep 0.25; !(spawner getVariable [format ["%1_arraysChanging", _marker], false])};
};
//Block all other scripts from working on it for the moment
spawner setVariable [format ["%1_arraysChanging", _marker], true, true];

if(_type isEqualType objNull) then
{
    private _array = [_marker, "Vehicles"] call A3A_fnc_getSpawnedArray;
    _array = _array - [_type];
    spawner setVariable [format ["%1_vehicles", _marker], _array, true];
}
else
{
    if(_type isEqualType grpNull) then
    {
        private _array = [_marker, "Groups"] call A3A_fnc_getSpawnedArray;
        _array = _array - [_type];
        spawner setVariable [format ["%1_groups", _marker], _array, true];
    }
    else
    {
        [
            1,
            format ["Wrong parameter given, was %1", _type],
            _fileName,
            true
        ] call A3A_fnc_log;
    };
};

spawner setVariable [format ["%1_arraysChanging", _marker], false, true];
