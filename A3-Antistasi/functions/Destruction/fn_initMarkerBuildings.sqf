params ["_marker"];

//Make sure it is running in unscheduled environment
//Why?
if(!canSuspend) exitWith
{
    [_marker] spawn A3A_fnc_initMarkerBuildings;
};

//Calculated marker pos and radius
private _markerSize = markerSize _marker;
private _radius = (_markerSize select 0) * (_markerSize select 0) + (_markerSize select 1) * (_markerSize select 1);
_radius = sqrt _radius;
private _pos = getMarkerPos _marker;

//Get the buildings and automatically replace bad buildings
private _buildings = [_marker, _radius] call A3A_fnc_findMarkerBuildings;
private _storages = _buildings select 1;
_buildings = _buildings select 0;

//Calculate the size of each building and calculates sum of all buildings
private _sizeSum = 0;
private _buildingSize = [];
{
    //Get bounding box mins and maxs
    private _building = _x;
    private _boundingBox = 0 boundingBox _building;
    private _min = _boundingBox select 0;
    private _max = _boundingBox select 1;

    //Calculating the volume of the bounding box
    private _result = _max vectorDiff _min;
    private _size = abs ((_result select 0) * (_result select 1) * (_result select 2));
    _size = round _size;
    _sizeSum = _sizeSum + _size;

    //Set size and building hash for further use
    _buildingSize pushBack [_building, _size];
} forEach _buildings;

private _buildingCount = count _buildings;
private _buildingPoints = 0;
if(_buildingCount <= 5) then
{
    //x = 1 => 70
    //x = 5 => 100
    _buildingPoints = 1.25 * (_buildingCount * _buildingCount) + 68.75;
}
else
{
    //x = 5 => 100
    //x = 25 => 1000
    //x = 100 => 1350
    _buildingPoints = -0.0007 * (_buildingCount * _buildingCount) + 14.814 * _buildingCount - 25.945;
};

//Distribute points to buildings based on max points and size
private _markerBuildings = [];
{
    private _building = _x select 0;
    private _size = _x select 1;

    //Calculate the points for the building
    //Calculation is based on the building size to sizeSum and a fixed parted being a building of all building
    //The size part however is weighted different
    private _points = round ((((2 * (_size / _sizeSum)) + (1 / _buildingCount))/2) * _buildingPoints);
    _building setVariable ["destructPoints", _points];
    _building setVariable ["destructMarker", _marker];
    [_building] call A3A_fnc_addBuildingEH;
    _markerBuildings pushBack _building;

    private _buildMarker = createMarker [str (random 10000), getPos _building];
    _buildMarker setMarkerShape "ICON";
    _buildMarker setMarkerType "mil_dot";
    if(_building in _storages) then
    {
        _buildMarker setMarkerColor "ColorRed";
    };
    _buildMarker setMarkerText format ["Building: %1 || Points: %2", getText (configFile >> "CfgVehicles" >> (typeOf _building) >> "displayName"), _points];
} forEach _buildingSize;

//server getVariable [format ["%1_buildings", _marker], _markerBuildings];

hint format ["%3\nFound %1 buildings!\nPoints distributed: %2", _buildingCount, _buildingPoints, _marker];
