#define SPAWNED         0
#define ON_STANDBY      1
#define DESPAWNED       2

if (!isServer and hasInterface) exitWith{};

private ["_markerX","_vehiclesX","_groups","_soldiers","_positionX","_staticsX","_garrison"];

_markerX = _this select 0;

_vehiclesX = [];
_groups = [];
_soldiers = [];
_civs = [];
_positionX = getMarkerPos (_markerX);

if (_markerX != "Synd_HQ") then
{
	if (!(_markerX in citiesX)) then
	{
		private _veh = createVehicle [SDKFlag, _positionX, [],0, "NONE"];
		if (hasIFA) then {_veh setFlagTexture SDKFlagTexture};
		_veh allowDamage false;
		_vehiclesX pushBack _veh;
		[_veh,"SDKFlag"] remoteExec ["A3A_fnc_flagaction",0,_veh];

		if (_markerX in seaports) then
		{
			[_veh,"seaport"] remoteExec ["A3A_fnc_flagaction",[teamPlayer,civilian],_veh];
		};
	};
	if ((_markerX in resourcesX) or (_markerX in factories)) then
	{
		if (not(_markerX in destroyedSites)) then
		{
			if ((daytime > 8) and (daytime < 18)) then
			{
				private _groupCiv = createGroup civilian;
				_groups pushBack _groupCiv;
				for "_i" from 1 to 4 do
				{
					if (spawner getVariable _markerX != 2) then
					{
						private _civ = _groupCiv createUnit ["C_man_w_worker_F", _positionX, [],0, "NONE"];
						_nul = [_civ] spawn A3A_fnc_CIVinit;
						_civs pushBack _civ;
						_civ setVariable ["markerX",_markerX,true];
						sleep 0.5;
						_civ addEventHandler ["Killed",
						{
							if (({alive _x} count units group (_this select 0)) == 0) then
							{
								private _markerX = (_this select 0) getVariable "markerX";
								private _nameX = [_markerX] call A3A_fnc_localizar;
								destroyedSites pushBackUnique _markerX;
								publicVariable "destroyedSites";
								["TaskFailed", ["", format ["%1 Destroyed",_nameX]]] remoteExec ["BIS_fnc_showNotification",[teamPlayer,civilian]];
							};
						}];
					};
				};
				//_nul = [_markerX,_civs] spawn destroyCheck;
				_nul = [leader _groupCiv, _markerX, "SAFE", "SPAWNED","NOFOLLOW", "NOSHARE","DORELAX","NOVEH2"] execVM "scripts\UPSMON.sqf";//TODO need delete UPSMON link
			};
		};
	};
};

private _size = [_markerX] call A3A_fnc_sizeMarker;
_staticsX = staticsToSave select {_x distance2D _positionX < _size};

_garrison = [];
_garrison = _garrison + (garrison getVariable [_markerX,[]]);
_groupX = createGroup teamPlayer;
_groupEst = createGroup teamPlayer;
_groupMortar = createGroup teamPlayer;
{
    _index = _garrison findIf {_x in SDKMil};
    if (_index == -1) exitWith {};
    if (typeOf _x == SDKMortar) then
	{
        _unit = _groupMortar createUnit [(_garrison select _index), _positionX, [], 0, "NONE"];
        _unit moveInGunner _x;
        [_x] execVM "scripts\UPSMON\MON_artillery_add.sqf";//TODO need delete UPSMON link
	}
    else
	{
        _unit = _groupEst createUnit [(_garrison select _index), _positionX, [], 0, "NONE"];
        _unit moveInGunner _x;
	};
    [_unit,_markerX] call A3A_fnc_FIAinitBases;
    _soldiers pushBack _unit;
    _garrison deleteAT _index;
} forEach _staticsX;

// Don't create these unless required
private _groupStatics = grpNull;
private _groupMortars = grpNull;

// Create the purchased mortars
if (staticCrewTeamPlayer in _garrison) then
{
	_groupMortars = createGroup teamPlayer;
	{
		private _unit = _groupMortars createUnit [staticCrewTeamPlayer, _positionX, [], 0, "NONE"];
		private _pos = [_positionX] call A3A_fnc_mortarPos;
		private _veh = SDKMortar createVehicle _pos;
		_vehiclesX pushBack _veh;
		_nul=[_veh] execVM "scripts\UPSMON\MON_artillery_add.sqf";//TODO need delete UPSMON link
		_unit assignAsGunner _veh;
		_unit moveInGunner _veh;
		[_veh] call A3A_fnc_AIVEHinit;
		_soldiers pushBack _unit;
	} forEach (_garrison select {_x == staticCrewTeamPlayer});
	_garrison = _garrison - [staticCrewTeamPlayer];
};

// Move riflemen into saved static weapons in area
{
	private _index = _garrison findIf {_x in SDKMil};
	if (_index == -1) exitWith {};
	private _unit = objNull;
	if (typeOf _x == SDKMortar) then
	{
		if (isNull _groupMortars) then { _groupMortars = createGroup teamPlayer };
		_unit = _groupMortars createUnit [(_garrison select _index), _positionX, [], 0, "NONE"];
		_unit moveInGunner _x;
		_nul=[_x] execVM "scripts\UPSMON\MON_artillery_add.sqf";//TODO need delete UPSMON link
	}
	else
	{
		if (isNull _groupStatics) then { _groupStatics = createGroup teamPlayer };
		_unit = _groupStatics createUnit [(_garrison select _index), _positionX, [], 0, "NONE"];
		_unit moveInGunner _x;
	};
	[_unit,_markerX] call A3A_fnc_FIAinitBases;
	_soldiers pushBack _unit;
	_garrison deleteAT _index;
} forEach _staticsX;


// Make 8-man groups out of the remainder of the garrison
_garrison = _garrison call A3A_fnc_garrisonReorg;

private _totalUnits = count _garrison;
private _countUnits = 0;
private _countGroup = 8;
private _groupX = grpNull;

while {(spawner getVariable _markerX != 2) and (_countUnits < _totalUnits)} do
{
	if (_countGroup == 8) then
	{
		_groupX = createGroup teamPlayer;
		_groups pushBack _groupX;
		_countGroup = 0;
	};
	private _typeX = _garrison select _countUnits;
	private _unit = _groupX createUnit [_typeX, _positionX, [], 0, "NONE"];
	if (_typeX in SDKSL) then {_groupX selectLeader _unit};
	[_unit,_markerX] call A3A_fnc_FIAinitBases;
	_soldiers pushBack _unit;
	_countUnits = _countUnits + 1;
	_countGroup = _countGroup + 1;
	sleep 0.5;
};

for "_i" from 0 to (count _groups) - 1 do
{
	_groupX = _groups select _i;
	if (_i == 0) then
	{
		_nul = [leader _groupX, _markerX, "SAFE","SPAWNED","RANDOMUP","NOVEH2","NOFOLLOW"] execVM "scripts\UPSMON.sqf";//TODO need delete UPSMON link
	}
	else
	{
		_nul = [leader _groupX, _markerX, "SAFE","SPAWNED","RANDOM","NOVEH2","NOFOLLOW"] execVM "scripts\UPSMON.sqf";//TODO need delete UPSMON link
	};
};

//Units fully spawned in, awaiting despawn
waitUntil
{
    sleep 10;
    private _spawners = allUnits select {_x getVariable ["spawner", false]};
    private _blufor = [];
    private _redfor = [];
    private _greenfor = [];
    {
        switch (side (group _x)) do
        {
            case (Occupants):
            {
                _blufor pushBack _x;
            };
            case (Invaders):
            {
                _redfor pushBack _x;
            };
            case (teamPlayer):
            {
                _greenfor pushBack _x;
            };
        };
    } forEach _spawners;
    private _needsSpawn = [_markerX, _blufor, _redfor, _greenfor, true] call A3A_fnc_needsSpawn;
    private _markerState = spawner getVariable _markerX;
    if(_markerState != _needsSpawn) then
    {
        if((_markerState == SPAWNED) && (_needsSpawn == ON_STANDBY)) then
        {
            //Enemy to far away, disable AI for now
            {
                {
                    _x enableSimulationGlobal false;
                } forEach (units _x);
            } forEach _groups;
        };
        if((_markerState == ON_STANDBY) && (_needsSpawn == SPAWNED)) then
        {
            //Enemy is closing in activate AI for now
            {
                {
                    _x enableSimulationGlobal true;
                } forEach (units _x);
            } forEach _groups;
        };
        spawner setVariable [_markerX, _needsSpawn, true];
    };

    (_needsSpawn == DESPAWNED)
};


{ if (alive _x) then { deleteVehicle _x }; } forEach _soldiers;
{deleteVehicle _x} forEach _civs;

{deleteGroup _x} forEach _groups;
deleteGroup _groupStatics;
deleteGroup _groupMortars;

{if (!(_x in staticsToSave)) then {deleteVehicle _x}} forEach _vehiclesX;
