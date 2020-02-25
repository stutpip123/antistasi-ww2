params ["_marker"];

private _fileName = "createCity";
private _side = sidesX getVariable [_marker, sideUnknown];
private _markerPos = getMarkerPos _marker;

private _allVehicles = [];
private _allGroups = [];

[2, format ["Starting creation of city %1 for side %2", _marker, _side], _fileName, true] call A3A_fnc_log;

if(_marker in destroyedSites) then
{
    //Spawn a few corpses in the destroyed buildings
    private _deadGroup = createGroup civilian;
    _allGroups pushBack _deadGroup;
    private _ruins =_markerPos nearObjects ["Ruins", 100];
    {
        if(random 10 <= 1) then
        {
            private _unitType = format ["C_man_polo_%1_F", round ((random 5) + 1)];
            private _unit = _deadGroup createUnit [_unitType, getPos _x, [], 5, "NONE"];
            _unit setDamage 1;
            _allVehicles pushBack _unit;
        };
    } forEach _ruin;
    //Maybe place some destroyed cars as simple objects for the immersion
}
else
{
    //Spawn people and vehicles and so on
    private _cityData = server getVariable _marker;
    _cityData params ["_numCiv", "_numVeh", "_prestigeOPFOR", "_prestigeBLUFOR"];

    private _roads = roadsX getVariable [_marker, []];
    if (count _roads == 0) then
    {
    	[1, format ["Roads not found for marker %1", _marker], _fileName, true] call A3A_fnc_log;
    };

    private _numVeh = round (_numVeh * (civPerc/200) * civTraffic);
    if (_numVeh < 1) then {_numVeh = 1};

    //Not sure if this is how percentages work, but fine
    _numCiv = round (_numCiv * (civPerc/250));
    if ((daytime < 8) or (daytime > 21)) then
    {
        _numCiv = round (_numCiv/4);
        _numVeh = round (_numVeh * 1.5)
    };
    if (_numCiv < 1) then {_numCiv = 1};

    _numVeh = _numVeh min ((count _roads) - 1);
    _roads = _roads call BIS_fnc_arrayShuffle;

    //Spawning in cars
    for "_counter" from 0 to _numVeh do
    {
        private _pos1 = _roads select _counter;
    	private _road = roadAt _pos1;
    	if (!isNull _road) then
    	{
    		if (count (nearestObjects [_pos1, ["Car", "Truck"], 5]) == 0) then
    		{
    			private _connectedRoads = roadsConnectedto (_road);
    			private _pos2 = getPos (_connectedRoads select 0);
    			private _vehDir = [_pos1,_pos2] call BIS_fnc_DirTo;
    			private _vehPos = [_pos1, 3, _vehDir + 90] call BIS_Fnc_relPos;
    			private _typeVeh = selectRandom arrayCivVeh;
    			private _veh = _typeVeh createVehicle _vehPos;
    			_veh setDir _vehDir;
    			_allVehicles pushBack _veh;
    			[_veh] spawn A3A_fnc_civVEHinit;
                _veh addEventHandler
                [
                    "GetIn",
                    {
                        private _vehicle = _this select 0;
                        private _unit = _this select 2;
                        if(side (group _unit) == teamPlayer) then
                        {
                            _vehicle setVariable ["Stolen", true, true];
                        };
                    }
                ];
    		};
    	};
    	sleep 0.5;
    };

    //Spawning in boats
    private _seaMarker = if !(hasIFA) then {seaSpawn select {getMarkerPos _x inArea _marker}} else {[]};
    if (count _seaMarker > 0) then
    {
    	for "_i" from 0 to (round (random 3)) do
    	{
    		private _typeVeh = selectRandom civBoats;
            private _boat = [_typeVeh, getMarkerPos (selectRandom _seaMarker), 25] call A3A_fnc_safeVehicleSpawn;
    		_allVehicles pushBack _boat;
    		[_boat] spawn A3A_fnc_civVEHinit;
            _boat addEventHandler
            [
                "GetIn",
                {
                    private _vehicle = _this select 0;
                    private _unit = _this select 2;
                    if(side (group _unit) == teamPlayer) then
                    {
                        _vehicle setVariable ["Stolen", true, true];
                    };
                }
            ];
    		sleep 0.5;
    	};
    };

    if (random 100 < ((prestigeNATO) + (prestigeCSAT))) then
    {
    	private _pos = [];
        private _journalistGroup =createGroup civilian;
    	while {true} do
    	{
    		_pos = [_positionX, round (random 50), random 360] call BIS_Fnc_relPos;
    		if (!surfaceIsWater _pos) exitWith {};
    	};
    	_allGroups pushBack _journalistGroup;
    	private _civ = _journalistGroup createUnit ["C_journalist_F", _pos, [], 10, "NONE"];
    	[_civ] spawn A3A_fnc_CIVinit;
    	[_civ, _marker, "SAFE", "SPAWNED","NOFOLLOW", "NOVEH2","NOSHARE","DoRelax"] execVM "scripts\UPSMON.sqf";//TODO need delete UPSMON link
    };
};

[_marker, _marker, _allVehicles, _allGroups] call A3A_fnc_cycleSpawn;
[2, format ["Successfully spawned in city %1", _marker], _fileName, true] call A3A_fnc_log;
