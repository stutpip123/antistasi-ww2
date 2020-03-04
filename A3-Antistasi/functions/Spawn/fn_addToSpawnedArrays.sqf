params ["_marker", "_vehicles", "_groups"];

/*  Adds units to the "spawnedArray" of a marker, integrating it into its despawn progress
    They are not getting added to the data by this function!

    Execution on: HC or Server

    Scope: External

    Params:
        _marker: STRING : Name of the marker to which the units will get added
        _vehicles: OBJECT or ARRAY OF OBJECTS: The vehicle(s) which will be added
        _groups: GROUP or ARRAY OF GROUPS: The group(s) which will be added

    Returns:
        Nothing
*/

//These functions are waiting for the block to be lifted, no need to wait further
private _markerVehicles = [_marker, "Vehicles"] call A3A_fnc_getSpawnedArray;
private _markerGroups = [_marker, "Groups"] call A3A_fnc_getSpawnedArray;
//Block all other scripts from working on it for the moment
spawner setVariable [format ["%1_arraysChanging", _marker], true, true];

if(_vehicles isEqualType []) then
{
    _markerVehicles append _vehicles;
}
else
{
    _markerVehicles pushBack _vehicles;
};

if(_groups isEqualType []) then
{
    _markerGroups append _groups;
}
else
{
    _markerGroups pushBack _groups;
};

spawner setVariable [format ["%1_vehicles", _marker], _vehicles, true];
spawner setVariable [format ["%1_groups", _marker], _groups, true];
//Unblocking everything
spawner setVariable [format ["%1_arraysChanging", _marker], false, true];
