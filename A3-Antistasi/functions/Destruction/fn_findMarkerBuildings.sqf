params ["_marker", "_radius"];

private _buildings = nearestTerrainObjects [getMArkerPos _marker, ["House"], _radius, false, false];

//These buildings have space to place objects in them
private _storageTypes =
[
  "Land_i_Shed_Ind_F", "Land_Shed_Small_F", "Land_Shed_Big_F", "Land_SM_01_shed_F",
  "Land_SM_01_shed_unfinished_F", "Land_SM_01_shelter_narrow_F", "Land_SM_01_shelter_wide_F"
];

private _buildingObjects = [];
private _storageBuildings = [];
{
  private _building = _x;
  private _pos = getPosWorld _building;
  if (_pos inArea _marker) then
  {
    if(typeOf _building != "") then
    {
      if((getText (configFile >> "CfgVehicles" >> (typeOf _building) >> "destrType")) != "DestructNo") then
      {
        _buildingObjects pushBack _building;
        if((typeOf _building) in _storageTypes) then
        {
          _storageBuildings pushBack _building;
        };
      };
    }
    else
    {
      private _dir = getDir _building;
      private _modelInfo = (getModelInfo _building) select 0;
      hideObjectGlobal _building;
      private _replacementType = "";
      switch (_modelInfo) do
      {
        //Transformer box
        case ("dp_transformer_f.p3d"):
        {
          _replacementType = "Land_dp_Transformer_F";
        };
        //Solar panel (16)
        case ("spp_panel_f.p3d"):
        {
          _replacementType = "Land_spp_Panel_F";
        };
        //Unknown case
        default
        {
          diag_log format ["Found terrain object without type, but unknown model %1", _modelInfo];
        };
      };
      if(_replacementType != "") then
      {
        private _replacement = createVehicle [_replacementType, _pos, [], 0, "CAN_COLLIDE"];
        _replacement setDir _dir;
        _replacement setPosWorld _pos;
        _buildingObjects pushBack _replacement;
      };
    };
  };
} forEach _buildings;

private _result = [_buildingObjects, _storageBuildings];
_result;
