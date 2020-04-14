params ["_marker", "_object"];

/*  Removes a spawned unit from the spawnedArray, after it is stolen or send somewhere else
    This does not remove the unit from the garrison data!

    Execution on: Server or HC

    Scope: Internal

    Params:
        _marker: STRING : The marker on which the units should be removed
        _object: OBJECT or GROUP: The object which should be removed

    Returns:
        Nothing
*/

private _fileName = "removeFromSpawnedArrays";

if(_object isEqualType objNull) then
{
    private _array = [_marker, "Vehicles"] call A3A_fnc_getSpawnedArray;
    spawner setVariable [format ["%1_arraysChanging", _marker], true, true];
    private _index = _array findIf {(_x select 0) == _object};
    if (_index != -1) then
    {
        _array deleteAt _index;
    };
    spawner setVariable [format ["%1_vehicles", _marker], _array, true];
}
else
{
    if(_object isEqualType grpNull) then
    {
        private _array = [_marker, "Groups"] call A3A_fnc_getSpawnedArray;
        spawner setVariable [format ["%1_arraysChanging", _marker], true, true];
        private _index = _array findIf {(_x select 0) == _object};
        if (_index != -1) then
        {
            _array deleteAt _index;
        };
        spawner setVariable [format ["%1_groups", _marker], _array, true];
    }
    else
    {
        [
            1,
            format ["Wrong parameter given, was %1", _object],
            _fileName,
            true
        ] call A3A_fnc_log;
    };
};

spawner setVariable [format ["%1_arraysChanging", _marker], false, true];
