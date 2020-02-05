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
        //Use my system once the discussion is done
        /*
      _reinf = [];
      if(_side == Occupants) then
      {
        if(count reinfPatrolOcc > 3) then
        {
          _reinf = reinfPatrolOcc select [0,1,2];
        }
        else
        {
          _reinf = +reinfPatrolOcc;
        };
      }
      else
      {
        if(count reinfPatrolInv > 3) then
        {
          _reinf = reinfPatrolInv select [0,1,2];
        }
        else
        {
          _reinf = +reinfPatrolInv;
        };
      };
      if(count _reinf == 0) then
      {
        _text = format ["%1 is currently performing no reinforcement patrols!", _sideName];
      }
      else
      {
        _text = format ["%1 is currently performing reinforcement patrols to %2", _sideName, name (_reinf select 0)];
        for "_i" from 1 to ((count _reinf) - 1) do
        {
          _text = format ["%1 and %2", _text, name (_reinf select _i)];
        };
      };
      */
    };
    case ("Cars"):
    {
        _carArray = [];
        _availableCars = [];
        if(_side == Occupants) then {_availableCars = +vehNATOLight;} else {_availableCars = +vehCSATLight;};
        _count = 1 + random ((count _availableCars) - 1);
        for "_i" from 0 to _count do
        {
          _car = selectRandom _availableCars;
          _carArray pushBack _car;
          _availableCars - [_car];
        };
        {
            if([_x] call A3A_fnc_vehAvailable) then
            {
              _text = format ["%1 %2 can be used by %3 right now", _text, name _x, _sideName];
            }
            else
            {
              _text = format ["%1 %2 can be used by %3 in %4 minutes again", _text, name _x, _sideName, timer getVariable _x];
            };
        } forEach _carArray;
    };
  };
};
if(_intelType == "Medium") then
{
  _intelContent = selectRandomWeighted ["Tanks", 0.4, "Helicopter", 0.3, "Planes", 0.3];
  switch (_intelContent) do
  {
    case ("Tanks"):
    {
      _heavyArray = [];
      _availableHeavys = [];
      if(_side == Occupants) then {_availableHeavys = +vehNATOAttack;} else {_availableHeavys = +vehCSATAttack;};
      _count = 1 + random ((count _availableHeavys) - 1);
      for "_i" from 0 to _count do
      {
        _heavy = selectRandom _availableHeavys;
        _heavyArray pushBack _heavy;
        _availableHeavys - [_heavy];
      };
      {
          if([_x] call A3A_fnc_vehAvailable) then
          {
            _text = format ["%1 %2 can be used by %3 right now", _text, name _x, _sideName];
          }
          else
          {
            _text = format ["%1 %2 can be used by %3 in %4 minutes again", _text, name _x, _sideName, timer getVariable _x];
          };
      } forEach _heavyArray;
    };
    case ("Helicopter")
    {
      _heliArray = [];
      _availableHelis = [];
      if(_side == Occupants) then {_availableHelis = +vehNATOAir;} else {_availableHelis = +vehCSATAir;};
      _count = 1 + random ((count _availableHelis) - 1);
      for "_i" from 0 to _count do
      {
        _heli = selectRandom _availableHelis;
        _heliArray pushBack _heli;
        _availableHelis - [_heli];
      };
      {
          if([_x] call A3A_fnc_vehAvailable) then
          {
            _text = format ["%1 %2 can be used by %3 right now", _text, name _x, _sideName];
          }
          else
          {
            _text = format ["%1 %2 can be used by %3 in %4 minutes again", _text, name _x, _sideName, timer getVariable _x];
          };
      } forEach _heliArray;
    };
    case ("Planes")
    {
      _planeArray = [];
      _availablePlanes = [];
      if(_side == Occupants) then {_availablePlanes = +vehNATOAttack;} else {_availablePlanes = +vehCSATAttack;};
      _count = 1 + random ((count _availablePlanes) - 1);
      for "_i" from 0 to _count do
      {
        _plane = selectRandom _availablePlanes;
        _planeArray pushBack _plane;
        _availablePlanes - [_plane];
      };
      {
          if([_x] call A3A_fnc_vehAvailable) then
          {
            _text = format ["%1 %2 can be used by %3 right now", _text, name _x, _sideName];
          }
          else
          {
            _text = format ["%1 %2 can be used by %3 in %4 minutes again", _text, name _x, _sideName, timer getVariable _x];
          };
      } forEach _planeArray;
    };
  };
};
if(_intelType == "Big") then
{
  if(["AS"] call BIS_fnc_taskExists) then
  {
    _intelContent = selectRandomWeighted ["Traitor", 0.2, "WeaponTech", 0.3, "BlackTech", 0.3, "Attack", 0.2];
  }
  else
  {
    _intelContent = selectRandomWeighted ["WeaponTech", 0.4, "BlackTech", 0.4 , "Attack", 0.2];
  };
  switch (_intelContent) do
  {
    case ("Traitor"):
    {
      _text = "You found data on the family of a traitor, we don't think he will do any more trouble";
      traitorIntel = true; publicVariable "traitorIntel";
    };
    case ("WeaponTech"):
    {
      _counter = 0;
      _weapon = nil;
      while {_counter < 25} do
      {
        _weapon = if(_side == Occupants) then {selectRandom weaponsNato} else {selectRandom weaponsCSAT};
        if(!(_weapon in unlockedWeapons)) exitWith {};
        _counter++;
        _weapon = nil;
      };
      if(isNil "_weapon") then
      {
        _text = format ["You found weapon data, but %1 has no further weapons for you to unlock!", _sideName];
      }
      else
      {
        _text = format ["You found the data of the %1 from %2. You should be able to unlock the weapon with it!", name _weapon, _sideName];
        boxX addWeaponCargoGlobal [_weapon, unlockItem];
        _updated = [] call A3A_fnc_arsenalManage;
      	if (_updated != "") then
      	{
      		_updated = format ["<t size='0.5' color='#C1C0BB'>Arsenal Updated<br/><br/>%1</t>",_updated];
      		[petros,"income",_updated] remoteExec ["A3A_fnc_commsMP",[teamPlayer,civilian]];
      	};
      };
    };
    case ("BlackTech"):
    {
      _money = ((random 50) + 8 * tierWar) * 100;
      _text = format ["You found some confidential data, you sold it for %1 on the black market!", _money];
      [0,_money] remoteExec ["A3A_fnc_resourcesFIA",2];
    };
    case ("Attack"):
    {
      //This may take to long, not sure
      _possibleAttacks = [true] call A3A_fnc_attackAAF;
      if(count _possibleAttacks > 5) then
      {
        _possibleAttacks = _possibleAttacks select [0,1,2,3,4];
      };
      if(count _possibleAttacks == 0) then
      {
        _text = format ["%1 has no current targets to attack, everything is save for the moment!", _sideName];
      }
      else
      {
        _text = format ["%1 next possible targets for large attack are: %2", _sideName, name (_possibleAttacks select 0)];
        for "_i" from 1 to ((count _possibleAttacks) - 1) do
        {
          _text = format ["%1 and %2", _text, name (_possibleAttacks select _i)];
        };
      };
    };
  };
};
[_text] call A3A_fnc_showIntel;
