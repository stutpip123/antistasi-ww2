params ["_marker", "_type"];

/*  Gets one of the both spawned arrays of a marker, waits for write operations to be finished

    Execution on: HC or Server

    Scope: Internal

    Params:
        _marker: STRING : The name of the marker, which arrays should be pulled
        _type: STRING : The type of array, either Groups or Vehicles

    Returns:
        _result: ARRAY : The content of the selected spawned array
*/

private _fileName = "getSpawnedArray";

if(!(_type in ["Groups", "Vehicles"])) then
{
    [
        1,
        format ["Type not accepted, was %1", _type],
        _fileName,
        true
    ] call A3A_fnc_log;
};

//Wait till write operations are done
if (spawner getVariable [format ["%1_arraysChanging", _marker], false]) then
{
    waitUntil {sleep 0.25; !(spawner getVariable [format ["%1_arraysChanging", _marker], false])};
};

private _result = [];
if(_type == "Groups") then
{
    _result = spawner getVariable [format ["%1_groups", _marker], []];
}
else
{
    _result = spawner getVariable [format ["%1_vehicles", _marker], []];
};

_result;
