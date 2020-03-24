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
    params ["_isOver", "_row", ["_type", 0]];
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

private _markerIsSpawned = ((spawner getVariable _marker) != 2);
{
    _x params ["_objects", "_inserts"];
    if(_markerIsSpawned) then
    {
        if((_objects select 0) isKindOf "Man") then
        {
            //Sorting in units into groups
            for "_i" from 0 to ((count _objects) - 1) do
            {
                private _unit = _objects select _i;
                private _insert = _inserts select _i;
                private _unitIndex = 10 * (_insert select 1) + (_insert select 2);
                private _groupParam = _insert call _fn_parseIndex;
                private _groupIndex = [_markerGroups, _groupParam] call _fn_searchForGroupIndex;
                if(_groupIndex == -1) then
                {
                    //Create new group
                    private _newGroup = createGroup (side (group _unit));
                    [_unit] joinSilent _newGroup;
                    _markerGroups pushBack [_newGroup, _groupParam];
                    [_unit, _marker, _insert select 0, _unitIndex] call A3A_fnc_markerUnitInit;
                    [_unit, (_insert select 3) + 1] call A3A_fnc_unitBehaviourOnArrival;
                    [leader _newGroup, _marker, "SAFE", "SPAWNED", "ORIGINAL", "NOFOLLOW", "NOVEH2"] execVM "scripts\UPSMON.sqf";

                    //Search for assigned vehicle
                    _insert resize 2;
                    private _vehicleIndex = [_markerVehicles, _insert] call _fn_searchForGroupIndex;
                    if(_vehicleIndex != -1) then
                    {
                        _newGroup addVehicle (_markerVehicles select _vehicleIndex select 0);
                    };
                }
                else
                {
                    //Join existing group
                    private _group = (_markerGroups select _groupIndex) select 0;
                    //Not sure if this is zero based or one based for groups
                    _unit joinAsSilent [_group, (_insert select 3) + 1];
                    [_unit, _marker, _insert select 0, _unitIndex] call A3A_fnc_markerUnitInit;
                    [_unit, (_insert select 3) + 1] call A3A_fnc_unitBehaviourOnArrival;
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
                [_unit, _marker, _insert select 0, _insert select 1] call A3A_fnc_markerVehicleInit;
                _insert = _insert call _fn_parseIndex;
                _markerVehicles pushBack [_unit, _insert];

                //Assign vehicle to group
                _insert pushBack IS_CREW;
                private _crewIndex = [_markerGroups, _insert] call _fn_searchForGroupIndex;
                if(_crewIndex != -1) then
                {
                    ((_markerGroups select _crewIndex) select 0) addVehicle _unit;
                };
            };
        };
    }
    else
    {
        //Marker already despawned, despawn units too
        {
            deleteVehicle _x;
        } forEach _objects;
    };
} forEach _added;

spawner setVariable [format ["%1_vehicles", _marker], _markerVehicles, true];
spawner setVariable [format ["%1_groups", _marker], _markerGroups, true];
//Unblocking everything
spawner setVariable [format ["%1_arraysChanging", _marker], false, true];
