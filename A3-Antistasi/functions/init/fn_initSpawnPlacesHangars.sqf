params ["_buildings", "_marker", "_hangarMarker"];

/*  Searches for hangars in the buildingList and optional markers and returns their positions
*   Params:
*       _buildings : ARRAY of OBJECTS : The buildings found on the main marker
*       _marker : STRING : The name of the main marker
*       _hangarMarker : ARRAY of STRINGS : Names of the optional hangar markers
*
*   Returns:
*       _result : ARRAY : [_newBuildings, _hangars]
*       _hangars : ARRAY : The positions of the hangars and their rotation, format [[[pos, dir], false], ...]
*/

private _newBuildings = [];
private _hangars = [];

//Searching and saving the hangars on the main marker
{
    private _building = _x;
    private _pos = getPos _building;
    if((typeOf _building) in listHangars && {_pos inArea _marker}) then
    {
        private _dir = getDir _building;
        //Check if hangar is facing the wrong way
        if((typeOf _building) in listWrongDirHangars) then
        {
            _dir = _dir + 180;
        };
        _hangars pushBack [[_pos, _dir], false];
    }
    else
    {
        _newBuildings pushBack _building;
    };
} forEach _buildings;

//Searching and saving additional hangars on optional hangar marker
{
    private _subMarker = _x;
    private _markerSize = markerSize _subMarker;
    private _distance = sqrt ((_markerSize select 0) * (_markerSize select 0) + (_markerSize select 1) * (_markerSize select 1));
    private _subBuildings = nearestObjects [getMarkerPos _subMarker, listHangars, _distance, true];
    {
        private _pos = getPos _x;
        if(_pos inArea _subMarker) then
        {
            private _dir = getDir _x;
            //Check if hangar is facing the wrong way
            if((typeOf _x) in listWrongDirHangars) then
            {
                _dir = _dir + 180;
            };
            _hangars pushBack [[_pos, _dir], false];
        };
    } forEach _subBuildings;
} forEach _hangarMarker;

//Cleaning the area around the hangar
{
    private _pos = (_x select 0) select 0;
    {
        _x hideObjectGlobal true;
    } foreach (nearestTerrainObjects [_pos, ["Tree","Bush", "Hide", "Rock"], 15, true]);
} forEach _hangars;

private _result = [_newBuildings, _hangars];
_result;
