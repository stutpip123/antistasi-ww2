params ["_marker", "_side"];

private _fileName = "initControlMarker";
private _markerPos = getMarkerPos _marker;

[2, format ["Creating control point %1 for side %2", _marker, _side], _fileName, true] call A3A_fnc_log;

if(isOnRoad _markerPos) then
{
    //Define roadblock type
    private _isLargeRoadblock = false;
    if(_side == teamPlayer || {_side == Occupants && {random 10 > tierWar}}) then
    {
        [2, format ["%1 is choosen to be a small roadblock", _marker], _fileName, true] call A3A_fnc_log;
        _isLargeRoadblock = false;
        spawner setVariable [format ["%1_roadblockType", _marker], 1, true];
    }
    else
    {
        [2, format ["%1 is choosen to be a large roadblock", _marker], _fileName, true] call A3A_fnc_log;
        _isLargeRoadblock = true;
        spawner setVariable [format ["%1_roadblockType", _marker], 0, true];
    };

    private _road = roadAt _markerPos;
    private _connectedRoads = roadsConnectedTo _road;

    if((count _connectedRoads) == 0) exitWith
    {
        [1, format ["Roadblock %1 is not placed right, replace it!", _marker], _fileName, true] call A3A_fnc_log;
        _error = true;
    };

    private _roadblockDir = [_road, _connectedRoads select 0] call BIS_fnc_DirTo;
    private _roadPos = getPos _road;

    //Define roadblock spawn positions
    if(_isLargeRoadblock) then
    {
        private _staticPos =
        [
            [[[_roadPos, 7, _roadblockDir + 90] call BIS_Fnc_relPos, _roadblockDir, "MG"], -1],
            [[[_roadPos, 7, _roadblockDir + 270] call BIS_Fnc_relPos, _roadblockDir + 180, "MG"], -1]
        ];
        garrison setVariable [format ["%1_statics", _marker], _staticPos, true];
    }
    else
    {
        private _vehicleSpawnPlace = [[_roadPos, _roadblockDir + 90], false];

        //Saving the spawn places
        spawner setVariable [format ["%1_spawns", _marker], [[_vehicleSpawnPlace], [], [], [], [], []], true];
        //Saving the amount of available places
        spawner setVariable [format ["%1_available", _marker], [1, 0, 0, 0, 0, 0], true];
        //Saving the currently stationed amount
        spawner setVariable [format ["%1_current", _marker], [1, 0, 0, 0, 0, 0], true];
    };

    if(_side != teamPlayer) then
    {
        private _line = [];
        private _parameter = [];
        if((_side == Invaders) || _isLargeRoadblock) then
        {
            _parameter = ["EMPTY", 0, "AT"];
        }
        else
        {
            _parameter = ["LAND_ROADBLOCK", 1, "AT"];
        };
        _line = [_parameter, _side] call A3A_fnc_createGarrisonLine;
        garrison setVariable [format ["%1_garrison", _marker], [_line], true];
        garrison setVariable [format ["%1_locked", _marker], [false], true];
    }
    else
    {
        private _garrison = [vehSDKLightArmed , [staticCrewTeamPlayer], []];
        {
            if (random 20 <= skillFIA) then
            {
                (_garrison select 2) pushBack (_x select 1);
            }
            else
            {
                (_garrison select 2) pushBack (_x select 0);
            };
		} forEach groupsSDKAT;
        garrison setVariable [format ["%1_garrison", _marker], [_garrison], true];
        garrison setVariable [format ["%1_locked", _marker], [false], true];
    };
}
else
{
    private _line = [];
    if(_side != teamPlayer) then
    {
        _line = [["EMPTY", 0, "SPECOPS"], _side] call A3A_fnc_createGarrisonLine;
    }
    else
    {
        _line = ["", [], []];
        {
            if (random 20 <= skillFIA) then
            {
                (_line select 2) pushBack (_x select 1)
            }
            else
            {
                (_line select 2) pushBack (_x select 0)
            };
        } forEach groupsSDKSniper;
    };
    garrison setVariable [format ["%1_garrison", _marker], [_line], true];
    garrison setVariable [format ["%1_locked", _marker], [true], true];
};
