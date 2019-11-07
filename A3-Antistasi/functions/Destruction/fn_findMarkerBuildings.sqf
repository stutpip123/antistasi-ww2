params ["_marker", "_radius"]

private _buildings = nearestTerrainObjects [getMArkerPos _marker, ["House"], _radius, false, false];
private _buildingObjects = [];
{
  private _building = _x;
  private _pos = getPosWorld _building;
  if (_pos inArea _marker) then
  {
    if(typeOf _building != "") then
    {
      _buildingObjects pushBack _building;
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

_buildingObjects;
