params ["_buildings", "_marker", "_heliMarker"];

/*  Searches for helipads in the buildingList and optional markers and returns their positions
*   Params:
*       _buildings : ARRAY of OBJECTS : The buildings found on the main marker
*       _marker : STRING : The name of the main marker
*       _heliMarker : ARRAY of STRINGS : Names of the optional heli markers
*
*   Returns:
*       _result : ARRAY : [_newBuildings, _helipads]
*       _helipads : ARRAY : The positions of the helipads and their rotation, format [[[pos, dir], false], ...]
*/

private _fileName = "initSpawnPlacesHelipads";
private _newBuildings = [];
private _helipads = [];

//Searches the buildings on the main marker for helipads
{
    private _building = _x;
    private _pos = getPos _building;
    if(_building isKindOf "Helipad_Base_F" && {_pos inArea _marker}) then
    {
        _helipads pushBack [[_pos, getDir _building], false];
    }
    else
    {
        _newBuildings pushBack _building;
    };
} forEach _buildings;

//Searches the helipad markers of the marker for helipads
{
    private _subMarker = _x;
    private _markerSize = markerSize _subMarker;
    private _distance = sqrt ((_markerSize select 0) * (_markerSize select 0) + (_markerSize select 1) * (_markerSize select 1));
    private _subBuildings = nearestObjects [getMarkerPos _subMarker, ["Helipad_Base_F"], _distance, true];
    {
        private _pos = getPos _x;
        if(_pos inArea _subMarker) then
        {
            _helipads pushBack [[_pos, getDir _x], false];
        };
    } forEach _subBuildings;
} forEach _heliMarker;

//Cleaning the area around the helipad
{
    private _pos = (_x select 0) select 0;
    {
        _x hideObjectGlobal true;
    } foreach (nearestTerrainObjects [_pos, ["Tree","Bush", "Hide", "Rock"], 5, true]);
} forEach _helipads;

private _result = [_newBuildings, _helipads];
_result;
