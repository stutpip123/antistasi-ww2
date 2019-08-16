params ["_hasIntel", "_intelType","_isTrap", "_intel", "_caller", "_searchAction"];

if(_intelType == "Small") then
{
  //Search squad leader for intel
  _timeForSearch = 10 + random 15;

  _caller setVariable ["searchTime",time + _timeForSearch];
  _caller setVariable ["animsDone",false];
  _caller setVariable ["success",false];
  _caller setVariable ["cancelSearch",false];

  _caller playMoveNow selectRandom medicAnims;

  _actionX = _caller addAction ["Cancel Search", {(_this select 1) setVariable ["cancelSearch",true]},nil,6,true,true,"","(isPlayer _this)"];

  _caller addEventHandler ["AnimDone",
	{
  	private _caller = _this select 0;
  	if (([_caller] call A3A_fnc_canFight) and {(time <= (_caller getVariable ["searchTime",time])) and {!(_caller getVariable ["cancelSearch",false]) and {(_caller == vehicle _caller)}}}) then
		{
  		_caller playMoveNow selectRandom medicAnims;
		}
  	else
		{
  		_caller removeEventHandler ["AnimDone",_thisEventHandler];
  		_caller setVariable ["animsDone",true];
  		if (([_caller] call A3A_fnc_canFight) and {!(_caller getVariable ["cancelSearch",false]) and {(_caller == vehicle _caller)}}) then
			{
				_caller setVariable ["success",true];
			};
		};
  }];

  waitUntil {sleep 0.5; _caller getVariable ["animsDone", false]};

  _caller setVariable ["searchTime",nil];
  _caller setVariable ["animsDone",nil];

  _caller removeAction _actionX;

  if(_caller getVariable ["cancelSearch", false]) then
  {
    hint "Search cancelled";
    _caller setVariable ["cancelSearch", nil];
  };

  if(_caller getVariable ["success", false]) then
  {
    _caller setVariable ["success", nil];
    _intel removeAction _searchAction;
    if(_hasIntel) then
    {
      hint "Search completed, intel found!";
      //Show intel content
    }
    else
    {
      hint "Search completed, but you found nothing!";
    };
  };
};
if(_intelType == "Medium") then
{
  //Take intel from desk
  deleteVehicle _intel;
  hint "Intel found";
  //Show intel content
};
if(_intelType == "Big") then
{
  //Hack laptop to get intel
  _pointsPerSecond = 25;
  if(tierWar > 4) then
  {
    _pointsPerSecond -= (tierWar * 2);
  }
  else
  {
    if(tierWar > 2) then {_pointsPerSecond -= tierWar};
  };
  _neededPoints = 1000 + random 1000;
  //Min war tier (40 sec - 80 sec) with UAV Hacker (20 sec - 40 sec)
  //Max war tier (200 sec - 400 sec) with UAV Hacker (100 sec - 200 sec)

  _pointSum = 0;

  {
    _friendX = _x;
    if (captive _friendX) then
    {
      [_friendX,false] remoteExec ["setCaptive",0,_friendX];
      _friendX setCaptive false;
    };
  } forEach [200, 0, _intel, teamPlayer] call A3A_fnc_distanceUnits;

  _spawnDistance = distanceSPWN;
  if(_isTrap) then
  {
    //Spawn in mortars, kill da fools, muhahaha :D
    _base = nil;
    {
      _marker = _x;
      if(_marker distance2D _intel > _spawnDistance && {_marker distance2D _intel < 3 * _spawnDistance && {spawner getVariable _marker == 2}}) exitWith
      {
        _base = _marker;
      };
    } forEach (airportsX + outposts);

    _groupX = createGroup _sideX;
  	_typeUnit = if (_sideX==Occupants) then {staticCrewOccupants} else {staticCrewInvaders};
  	_typeVehX = if (_sideX == Occupants) then {NATOMortar} else {CSATMortar};
    _mortarMag = getArray (configFile >> "CfgVehicles" >> _typeVehX >> "Turrets" >> "MainTurret" >> "magazines");
  	_pos = [_positionX] call A3A_fnc_mortarPos;
  	_veh = _typeVehX createVehicle _pos;
  	_unit = _groupX createUnit [_typeUnit, _positionX, [], 0, "NONE"];
  	_unit moveInGunner _veh;
    [] spawn
    {
      sleep 1;

    };


  };

  _intel setVariable ["ActionNeeded", false];
  _errorText = "";
  _errorChance = 0;

  _enemyCounter = 0;

  while {_pointSum <= _neededPoints} do
  {
    sleep 1;
    _errorChance += 6;
    _playerList = [20, 0, _intel, teamPlayer] call A3A_fnc_distanceUnits;

    if({[_x] call A3A_fnc_canFight} count _playerList == 0) exitWith
    {
      _pointSum = 0;
      {[petros,"hint","No one in range of the intel, reseting download!"] remoteExec ["A3A_fnc_commsMP",_x]} forEach ([50,0,_intel,teamPlayer] call A3A_fnc_distanceUnits);
    };
    _actionNeed = _intel getVariable ["ActionNeeded", false];

    if(!_actionNeed) then
    {
      if(random 1000 < _errorChance) then
      {
        //"Something went wrong, oopsie", generating error message to force player to move to the intel laptop
        _actionNeed = true;
        _intel setVariable ["ActionNeeded", true];
        _error = selectRandomWeighted ["Err_Sml_01", 0.25, "Err_Sml_02", 0.2, "Err_Sml_03", 0.15, "Err_Med_01", 0.15, "Err_Med_02", 0.15, "Err_Lar_01", 0.1];
        _actionText = "";
        _penalty = 0;
        switch (_error) do
        {
          case ("Err_Sml_01"):
          {
            _errorText = "Data Fragment Error. File {002451%12-215502%} has to be confirmed manually!";
            _actionText = "Confirm file";
            _penalty = 150 + random 100;
          };
          case ("Err_Sml_02"):
          {
            _errorText = "404 Error on server. URL incorrect. Skip URL?";
            _actionText = "Skip URL";
            _penalty = 150 + random 50;
          };
          case ("Err_Sml_03"):
          {
            _errorText = "Windows needs an update. Update now and lose all data?";
            _actionText = "Stop windows update";
            _penalty = 200 + random 150;
          };
          case ("Err_Med_01"):
          {
            _errorText = "Download port closed on server. Manually reroute required!";
            _actionText = "Reroute download";
            _penalty = 250 + random 150;
          };
          case ("Err_Med_02"):
          {
            _errorText = "Error in NetworkAdapter. Hardware not responding. Restart now?";
            _actionText = "Restart NetworkAdapter";
            _penalty = 350 + random 100;
          };
          case ("Err_Lar_01"):
          {
            _errorText = "Critical Error in network infrastructur. Server returned ErrorCode: CRITICAL_PROCESS_DIED";
            _actionText = "Restart server process";
            _penalty = 600 + random 250;
          };
        };
        _intel addAction [_actionText, {(_this select 0) setVariable ["ActionNeeded", false]; (_this select 0) removeAction (_this select 2);},nil,4,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])",4];
        _pointSum -= _penalty;
        if(_pointSum < 0) then {_pointSum = 0};
        _errorChance = 0;
      };
    };

    //Sending in enemy troups to secure the terminal
    if(_enemyCounter > 10) then
    {
      {
        _x doMove (getPos _intel);
      } forEach ([300, 0, _intel, Invaders] call A3A_fnc_distanceUnits);
      {
        _x doMove (getPos _intel);
      } forEach ([300, 0, _intel, Occupants] call A3A_fnc_distanceUnits);
      _enemyCounter = 0;
    }
    else
    {
      _enemyCounter++;
    };

    if(_actionNeed) then
    {
      {[petros,"intelError", _errorText] remoteExec ["A3A_fnc_commsMP",_x]} forEach _playerList;
    }
    else
    {
      _UAVHacker = (_playerList findIf {_x getUnitTrait "UAVHacker"} != -1);
      if(_UAVHacker) then {_pointSum += _pointsPerSecond * 2;} else {_pointSum += _pointsPerSecond;};
      {
        [petros,"hint", format ["Download at %1 %!", str (_pointSum/_neededPoints)]] remoteExec ["A3A_fnc_commsMP",_x]
      } forEach _playerList;
    };
  };

  _intel setVariable ["ActionNeeded", nil];

  if(_pointSum > _neededPoints) then
  {
    if(_hasIntel) then
    {
      {
        [petros,"hint","You managed to download the intel!"] remoteExec ["A3A_fnc_commsMP",_x]
      } forEach ([20,0,_intel,teamPlayer] call A3A_fnc_distanceUnits);
      {
        if (_x distance2D _intel < 20) then {[10,_x] call A3A_fnc_playerScoreAdd}
      } forEach (allPlayers - (entities "HeadlessClient_F"));
      [5, theBoss] call A3A_fnc_playerScoreAdd;
      _intel removeAction _searchAction;
      //Show intel content
    }
    else
    {
      {
        [petros,"hint","The Data says: Die rebel scum!"] remoteExec ["A3A_fnc_commsMP",_x]
      } forEach ([20,0,_intel,teamPlayer] call A3A_fnc_distanceUnits);
    };
  };
};
