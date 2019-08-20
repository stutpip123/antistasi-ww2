params ["_intelType", "_side"];

if(isNil "_intelType") exitWith {diag_log "SelectIntel: No type given!"};
if(isNil "_side") exitWith {diag_log "SelectIntel: No side given!"};

_text = "";
_sideName = "";
if(_side == Occupants) then {_sideName = nameOccupants} else {_sideName = nameInvaders};

if(_intelType == "Small") then
{
  _intelContent = selectRandomWeighted ["Patrols", 0.4, "Reinforce", 0.4, "Cars", 0.2];
  switch (_intelContent) do
  {
    case ("Patrols"):
    {
      //This is not 100% correct as the patrols of Inv and Occ are both saved here...
      _patrols = smallCAmrk select {(sidesX getVariable _x) != _side};
      if(count _patrols > 3) then
      {
        _patrols = _patrols select [0,1,2];
      };
      if(count _patrols == 0) then
      {
        _text = format ["%1 is not performing any patrols right now!", _sideName];
      }
      else
      {
        _text = format ["%1 is currently performing patrols to %2",_sideName, markerText (_patrols select 0)];
        for "_i" from 1 to (_patrols - 1) do
        {
          _text = format ["%1 and %2", _text, markerText (_patrols select _i)];
        };
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
[_text] call A3A_fnc_showIntel;
