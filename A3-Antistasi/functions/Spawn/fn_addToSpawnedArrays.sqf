#define GARRISON    10
#define OVER        11
#define STATIC      12
#define MORTAR      13
#define PATROL      14
#define OTHER       15

#define IS_CREW     false
#define IS_CARGO    true

params ["_marker", "_added"];

/*  Adds units to the "spawnedArray" of a marker, integrating it into its despawn progress
    They are not getting added to the data by this function!
    Execution on: HC or Server

    Scope: Internal

    Params:
        _marker: STRING : Name of the marker to which the units will get added
        _added: ARRAy : The groups or vehicles that will be added

    Returns:
        Nothing
*/

_fn_parseIndex =
{
    params ["_isOver", "_row", "_type"];
    private _params = [];
    if(_isOver) then
    {
        _params pushBack OVER;
    }
    else
    {
        _params pushBack GARRISON;
    };
    _params pushBack _row;
    if(_type == 1) then
    {
        _params pushBack IS_CREW;
    };
    if(_type == 2) then
    {
        _params pushBack IS_CARGO;
    };
    _params;
};

_fn_searchForGroupIndex =
{
    params ["_array", "_params"];
    private _index = _array findIf {(_x select 1) isEqualTo _params};
    _index;
};


//These functions are waiting for the block to be lifted, no need to wait further
private _markerVehicles = [_marker, "Vehicles"] call A3A_fnc_getSpawnedArray;
private _markerGroups = [_marker, "Groups"] call A3A_fnc_getSpawnedArray;
//Block all other scripts from working on it for the moment
spawner setVariable [format ["%1_arraysChanging", _marker], true, true];

{
    _x params ["_objects", "_inserts"];
    if((_objects select 0) isKindOf "Man") then
    {
        //Sorting in units into groups
        for "_i" from 0 to ((count _objects) - 1) do
        {
            private _unit = _objects select _i;
            private _insert = _inserts select _i;
            private _groupParam = _insert call _fn_parseIndex;
            private _groupIndex = [_markerGroups, _groupParam] call _fn_searchForGroupIndex;
            if(_groupIndex == -1) then
            {
                //Create new group
                private _newGroup = createGroup (side (group _unit));
                [_unit] joinSilent _newGroup;
                _markerGroups pushBack [_newGroup, _groupParam];
                //TODO add a check for a vehicle if the group needs to be assinged to it
                //TODO init the new group and unit
            }
            else
            {
                private _group = (_markerGroups select _groupIndex) select 0;
                [_unit] joinSilent _group;
                //TODO add a real insertion into the right place in the group
                //TODO init the unit
            };
        };
    }
    else
    {
        //Sorting in vehicles
        for "_i" from 0 to ((count _objects) - 1) do
        {
            private _unit = _objects select _i;
            private _insert = _inserts select _i;
            _insert = _insert call _fn_parseIndex;
            _markerVehicles pushBack [_unit, _insert];
            //TODO init vehicle
        };
    };
} forEach _added;

spawner setVariable [format ["%1_vehicles", _marker], _markerVehicles, true];
spawner setVariable [format ["%1_groups", _marker], _markerGroups, true];
//Unblocking everything
spawner setVariable [format ["%1_arraysChanging", _marker], false, true];
