#define FACTORY_BUILDINGS []
#define STORAGE_BUILDINGS []

params ["_markerArray"];

{
  _marker = _x;
  _markerPos = getMarkerPos _marker;

  //Start with 40% given by the civi workes
  _points = 40;

  //Search all buildings on the marker
  _markerSize = getMarkerSize _marker;
  _radius = sqrt ((_markerSize select 0) * (_markerSize select 0) + (_markerSize select 1) * (_markerSize select 1));
  _buildings = nearestObjects [_markerPos, "House", _radius, true];

  _factoryBuildings = [];
  _storageBuildings = [];
  {
    _building = _x;
    if(getPos _building inArea _marker) then
    {
      _type = typeOf _building;
      if(_type in FACTORY_BUILDINGS) then
      {
        _factoryBuildings pushBack _building;
      };
      if(_type in STORAGE_BUILDINGS) then
      {
        _storageBuildings pushBack _building;
      };
    };
  } forEach _buildings;

  //Sort industrial buildings and select values

  //Sort large buildings to place stuff in

  //Use vehicle positions to park stuff there
} forEach _markerArray;
