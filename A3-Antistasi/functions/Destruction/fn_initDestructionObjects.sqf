//Large building, will result in 75 - 150 points
private _factoryLarge =
[
  "Land_dp_bigTank_F", "Land_dp_mainFactory_F", "Land_Factory_Main_F", "Land_DPP_01_mainFactory_F",
  "Land_SCF_01_crystallizer_F", "Land_SCF_01_generalBuilding_F", "Land_SCF_01_storageBin_big_F"
];

//Medium building, will result in 40 - 90 points
private _factoryMedium =
[
  "Land_dp_smallFactory_F", "Land_DPP_01_mainFactory_F", "Land_SCF_01_boilerBuilding_F",
  "Land_SCF_01_clarifier_F", "Land_SCF_01_storageBin_medium_F", "Land_SCF_01_warehouse_F"
];

//Small buildings, will result in 15 - 50 points
private _factorySmall =
[
  "Land_cmp_Tower_F", "Land_dp_smallTank_F", "Land_dp_transformer_F", "Land_DPP_01_transformer_F",
  "Land_SCF_01_crystallizerTowers_F", "Land_SCF_01_storageBin_small_F"
];

//These buildings have space to place objects in them
private _storageTypes =
[
  "Land_i_Shed_Ind_F", "Land_Shed_Small_F", "Land_Shed_Big_F", "Land_SM_01_shed_F",
  "Land_SM_01_shed_unfinished_F", "Land_SM_01_shelter_narrow_F", "Land_SM_01_shelter_wide_F"
];

//These buildings will instantly destroy a marker
private _specialTypes =
[
  "Land_spp_Tower_F"      //The large solar tower
];

params ["_markerArray"];
{
  _marker = _x;
  _markerPos = getMarkerPos _marker;

  //Start with 40% given by the civi workes
  _points = 40;

  //Search all buildings on the marker
  _markerSize = getMarkerSize _marker;
  _radius = sqrt ((_markerSize select 0) * (_markerSize select 0) + (_markerSize select 1) * (_markerSize select 1));
  _buildings = nearestObjects [_markerPos, (_factoryLarge + _factoryMedium + _factorySmall + _storageTypes + _specialTypes), _radius, true];

  _factoryBuildingsSmall = [];
  _factoryBuildingsMedium = [];
  _factoryBuildingsLarge = [];
  _factoryBuildingsSpecial = [];
  _storageBuildings = [];

  //Sort building types
  {
    _building = _x;
    if((getPos _building) inArea _marker) then
    {
      _type = typeOf _building;
      if(_type in _storageTypes) then
      {
        _storageBuildings pushBack _building;
      }
      else
      {
        if(_type in _specialTypes) then
        {
          _factoryBuildingsSpecial pushBack _building;
        }
        else
        {
          if(_type in _factoryLarge) then
          {
            _factoryBuildingsLarge pushBack _building;
          }
          else
          {
            if(_type in _factoryMedium) then
            {
              _factoryBuildingsMedium pushBack _building;
            }
            else
            {
              _factoryBuildingsSmall pushBack _building;
            };
          };
        };
      };
    };
  } forEach _buildings;

  //Points [Large, Medium, Small, Special]
  private _points = [150, 90, 50, 200];

  //Reduce points if too many special buildings
  if(count _factoryBuildingsSpecial > 1) then
  {
    _points set [0, (_points select 0) * 0.8];
    _points set [1, (_points select 1) * 0.7];
    _points set [2, (_points select 2) * 0.7];
  };

  //Reducing points if too many large buildings
  if(count _factoryBuildingsLarge > 3) then
  {
    _points set [0, (_points select 0) * 0.6];
    _points set [1, (_points select 1) * 0.75];
    _points set [2, (_points select 2) * 0.75];
  };

  //Reducing points if too many medium buildings
  if(count _factoryBuildingsMedium > 4) then
  {
    _points set [1, (_points select 1) * 0.6];
    _points set [2, (_points select 2) * 0.7];
  };

  //Reducing points if too many small buidings
  if(count _factoryBuildingsSmall > 6) then
  {
    _points set [2, (_points select 2) * 0.5];
  };

  _points set [0, (_points select 0) max 75];
  _points set [1, (_points select 1) max 40];
  _points set [2, (_points select 2) max 15];

  diag_log format ["Found %1 S, %2 L, %3 M, %4 S, points are %5", count _factoryBuildingsSpecial, count _factoryBuildingsLarge, count _factoryBuildingsMedium, count _factoryBuildingsSmall, str _points];

  private _counter = 0;
  {
    _array = _x;
    {
        _building = _x;
        _building setVariable ["destructPoints", (_points select _counter)];
        [_building] call A3A_fnc_addBuildingEH;
    } forEach _array;
    _counter = _counter + 1;
  } forEach [_factoryBuildingsLarge, _factoryBuildingsMedium, _factoryBuildingsSmall, _factoryBuildingsSpecial];

  //Place objects, but max 3
  _storageCount = count _storageBuildings min 3;

  //Place the objects
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
} forEach _markerArray;
