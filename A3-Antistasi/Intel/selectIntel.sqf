params ["_intelType", "_side"];

if(isNil "_intelType") exitWith {diag_log "SelectIntel: No type given!"};
if(isNil "_side") exitWith {diag_log "SelectIntel: No side given!"};

if(_intelType == "Small") then
{
  _intelContent = selectRandomWeighted ["Patrols", 0.4, "Reinforce", 0.4, "Cars", 0.2];
  switch (_intelContent) do
  {
    case ("Patrols"):
    {
        _maxCount = 3;
        if(_side == Occupants) then
        {

        }
        else
        {

        };
    };
    case ("Reinforce"):
    {
        if(_side == Occupants) then
        {

        }
        else
        {

        };
    };
    case ("Cars"):
    {
        if(_side == Occupants) then
        {

        }
        else
        {

        };
    };
  };
};
