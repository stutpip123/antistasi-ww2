params ["_marker"];

_marker = "marker_0";

//Calculated marker radius
private _markerSize = markerSize _marker;
private _radius = (_markerSize select 0) * (_markerSize select 0) + (_markerSize select 1) * (_markerSize select 1);
_radius = sqrt _radius;

private _pos = getMarkerPos _marker;

//Search for nearby buildings
_buildings = nearestObjects [_pos, ["House"], 500, true];

//Sort buildings for the ones that are in the marker array and can be destructed
_buildings = _buildings select
{
  (getPos _x) inArea _marker &&
  {(getText (configFile >> "CfgVehicles" >> (typeOf _x) >> "destrType")) != "DestructNo"}
};

private _buildingSize = [];
{
    private _building = _x;
    private _boundingBox = 0 boundingBox _building;
    private _min = _boundingBox select 0;
    private _max = _boundingBox select 1;
    private _result = _max vectorDiff _min;

    //Calculating the volume of the bounding box
    private _size = (_result select 0) * (_result select 1) * (_result select 2);

    private _buildMarker = createMarker [str (random 10000), getPos _x];
    _buildMarker setMarkerShape "ICON";
    _buildMarker setMarkerType "mil_dot";
    _buildMarker setMarkerText format ["Building: %1 || Size: %2", getText (configFile >> "CfgVehicles" >> (typeOf _x) >> "displayName"), _size];

    _buildingSize pushBack [typeOf _building, _size];
} forEach _buildings;

hint format ["Found %1 buildings!\nList is : %2", count _buildings, str _buildingSize];
