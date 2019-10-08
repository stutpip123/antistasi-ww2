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

  _factoryCount = count _factoryBuildings;
  _storageCount = count _storageBuildings;

  private _factor = 1;
  private _placementCount = 0;
  if(_factoryCount + _storageCount > 10) then
  {
    //Lots of spaces available, select more with lower values
    _placementCount = 6;
    _factor = 0.6;
  }
  else
  {
    //Few spaces available, select less with higher values
    _placementCount = 3;
    _factor = 1.1;
  };

  private _storagePlacements = random _placementCount;
  if(_storagePlacements > _storageCount) then
  {
    _storagePlacements = _storageCount;
  };
  _placementCount = _placementCount - _storagePlacements;

  for "_i" from 1 to _storagePlacements do
  {
    //Select building and get needed infos
    private _storage = _storageBuildings deleteAt (round (random (_storageCount - 1)));
    _storageCount = _storageCount - 1;
    private _storPos = getPos _storage;
    private _storDir = getDir _storage;

    //Select composition and build it
    private _comp = selectRandom destructCompositions;
    [_comp, _storPos, _storDir, _marker] spawn A3A_fnc_createDestructionComposition;
  };

  private _factoryPlacements = _placementCount;
  if(_factoryPlacements > _factoryCount) then
  {
    _factoryPlacements = _factoryCount;
  };
  _placementCount = _placementCount - _factoryPlacements;

  //Thats dumb, every buildings should add points, there is no way for players to tell
  //which of the buildings is the one with a EH
  for "_i" from 1 to _factoryPlacements do
  {
    //Select building and get needed infos
    private _factory = _factoryBuildings deleteAt (round (random (_factoryCount - 1)));
    _factoryCount = _factoryCount - 1;

    [_factory, _marker] call A3A_fnc_addBuildingEH;
  };

  //TODO save every object as it is and delete it once the factory despawns

} forEach _markerArray;
