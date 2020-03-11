private ["_veh","_typeX"];

_veh = _this select 0;
if (isNil "_veh") exitWith {};
if ((_veh isKindOf "FlagCarrier") or (_veh isKindOf "Building") or (_veh isKindOf "ReammoBox_F")) exitWith {};
//if (_veh isKindOf "ReammoBox_F") exitWith {[_veh] call A3A_fnc_NATOcrate};

_typeX = typeOf _veh;

if ((_typeX in vehNormal) or (_typeX in vehAttack) or (_typeX in vehBoats)) then
{
	_veh call A3A_fnc_addActionBreachVehicle;

	_veh addEventHandler ["Killed",
		{
		private _veh = _this select 0;
		(typeOf _veh) call A3A_fnc_removeVehFromPool;
		_veh removeAllEventHandlers "HandleDamage";
		}];
	if !(_typeX in vehAttack) then
		{
		if (_veh isKindOf "Car") then
			{
			_veh addEventHandler ["HandleDamage",{if (((_this select 1) find "wheel" != -1) and ((_this select 4=="") or (side (_this select 3) != teamPlayer)) and (!isPlayer driver (_this select 0))) then {0} else {(_this select 2)}}];
			if ({"SmokeLauncher" in (_veh weaponsTurret _x)} count (allTurrets _veh) > 0) then
				{
				_veh setVariable ["within",true];
				_veh addEventHandler ["GetOut", {private ["_veh"]; _veh = _this select 0; if (side (_this select 2) != teamPlayer) then {if (_veh getVariable "within") then {_veh setVariable ["within",false]; [_veh] call A3A_fnc_smokeCoverAuto}}}];
				_veh addEventHandler ["GetIn", {private ["_veh"]; _veh = _this select 0; if (side (_this select 2) != teamPlayer) then {_veh setVariable ["within",true]}}];
				};
			};
		}
	else
		{
		if (_typeX in vehAPCs) then
			{
			_veh addEventHandler ["killed",
				{
				private ["_veh","_typeX"];
				_veh = _this select 0;
				_typeX = typeOf _veh;
				if (side (_this select 1) == teamPlayer) then
					{
					if (_typeX in vehNATOAPC) then {[-2,2,position (_veh)] remoteExec ["A3A_fnc_citySupportChange",2]};
					};
				}];
			_veh addEventHandler ["HandleDamage",{private ["_veh"]; _veh = _this select 0; if (!canFire _veh) then {[_veh] call A3A_fnc_smokeCoverAuto; _veh removeEventHandler ["HandleDamage",_thisEventHandler]};if (((_this select 1) find "wheel" != -1) and (_this select 4=="") and (!isPlayer driver (_veh))) then {0;} else {(_this select 2);}}];
			_veh setVariable ["within",true];
			_veh addEventHandler ["GetOut", {private ["_veh"];  _veh = _this select 0; if (side (_this select 2) != teamPlayer) then {if (_veh getVariable "within") then {_veh setVariable ["within",false];[_veh] call A3A_fnc_smokeCoverAuto}}}];
			_veh addEventHandler ["GetIn", {private ["_veh"];_veh = _this select 0; if (side (_this select 2) != teamPlayer) then {_veh setVariable ["within",true]}}];
			}
		else
			{
			if (_typeX in vehTanks) then
				{
				_veh addEventHandler ["killed",
					{
					private ["_veh","_typeX"];
					_veh = _this select 0;
					_typeX = typeOf _veh;
					if (side (_this select 1) == teamPlayer) then
						{
						if (_typeX == vehNATOTank) then {[-5,5,position (_veh)] remoteExec ["A3A_fnc_citySupportChange",2]};
						};
					}];
				_veh addEventHandler ["HandleDamage",{private ["_veh"]; _veh = _this select 0; if (!canFire _veh) then {[_veh] call A3A_fnc_smokeCoverAuto;  _veh removeEventHandler ["HandleDamage",_thisEventHandler]}}];
				}
			else
				{
				_veh addEventHandler ["HandleDamage",{if (((_this select 1) find "wheel" != -1) and ((_this select 4=="") or (side (_this select 3) != teamPlayer)) and (!isPlayer driver (_this select 0))) then {0} else {(_this select 2)}}];
				};
			};
		};
	}
else
	{
	if (_typeX in vehPlanes) then
		{
		_veh addEventHandler ["killed",
			{
			private ["_veh","_typeX"];
			_veh = _this select 0;
			(typeOf _veh) call A3A_fnc_removeVehFromPool;
			}];
		_veh addEventHandler ["GetIn",
			{
			_positionX = _this select 1;
			if (_positionX == "driver") then
				{
				_unit = _this select 2;
				if ((!isPlayer _unit) and (side group _unit == teamPlayer)) then
					{
					moveOut _unit;
					["General", "Only Humans can pilot an air vehicle"] call A3A_fnc_customHint;
					};
				};
			}];
		if (_veh isKindOf "Helicopter") then
			{
			if (_typeX in vehTransportAir) then
				{
				_veh setVariable ["within",true];
				_veh addEventHandler ["GetOut", {private ["_veh"];_veh = _this select 0; if ((isTouchingGround _veh) and (isEngineOn _veh)) then {if (side (_this select 2) != teamPlayer) then {if (_veh getVariable "within") then {_veh setVariable ["within",false]; [_veh] call A3A_fnc_smokeCoverAuto}}}}];
				_veh addEventHandler ["GetIn", {private ["_veh"];_veh = _this select 0; if (side (_this select 2) != teamPlayer) then {_veh setVariable ["within",true]}}];
				}
			else
				{
				_veh addEventHandler ["killed",
					{
					private ["_veh","_typeX"];
					_veh = _this select 0;
					_typeX = typeOf _veh;
					if (side (_this select 1) == teamPlayer) then
						{
						if (_typeX in vehNATOAttackHelis) then {[-5,5,position (_veh)] remoteExec ["A3A_fnc_citySupportChange",2]};
						};
					}];
				};
			};
		if (_veh isKindOf "Plane") then
			{
			_veh addEventHandler ["killed",
				{
				private ["_veh","_typeX"];
				_veh = _this select 0;
				_typeX = typeOf _veh;
				if (side (_this select 1) == teamPlayer) then
					{
					if ((_typeX == vehNATOPlane) or (_typeX == vehNATOPlaneAA)) then {[-8,8,position (_veh)] remoteExec ["A3A_fnc_citySupportChange",2]};
					};
				}];
			};
		}
	else
	{
		if ((_typeX in vehAA) or (_typeX in vehMRLS)) then
		{
			_veh addEventHandler ["killed",
			{
				private ["_veh","_typeX"];
				_veh = _this select 0;
				_typeX = typeOf _veh;
				if (side (_this select 1) == teamPlayer) then
				{
					if (_typeX == vehNATOAA) then {[-5,5,position (_veh)] remoteExec ["A3A_fnc_citySupportChange",2]};
				};
				_typeX call A3A_fnc_removeVehFromPool;
			}];
		};
	};
};

[_veh] spawn A3A_fnc_cleanserVeh;

_veh addEventHandler ["Killed",{[_this select 0] spawn A3A_fnc_postmortem}];

if (not(_veh in staticsToSave)) then
{
	if (((count crew _veh) > 0) && (!(_typeX in vehAA)) && (!(_typeX in vehMRLS) && !(_veh isKindOf "StaticWeapon"))) then
	{
		[_veh] spawn A3A_fnc_VEHdespawner;
	}
	else
	{
		_veh addEventHandler
        [
            "GetIn",
            {
                _unit = _this select 2;
                if ((side _unit == teamPlayer) or (isPlayer _unit)) then
                {
                    [_this select 0] spawn A3A_fnc_VEHdespawner;
                };
            }
        ];
	};
	if (_veh distance getMarkerPos respawnTeamPlayer <= 50) then
	{
		clearMagazineCargoGlobal _veh;
		clearWeaponCargoGlobal _veh;
		clearItemCargoGlobal _veh;
		clearBackpackCargoGlobal _veh;
	};
};
