params ["_marker", "_side"];

private _fileName = "initControlMarker";
private _markerPos = getMarkerPos _marker;

if(isOnRoad _markerPos) then
{
    //Define roadblock type
    private _isLargeRoadblock = false;
    if(_side == Occupants && {random 10 > tierWar}) then
    {
        //Debug same values for debug
        _isLargeRoadblock = true;
        spawner setVariable [format ["%1_roadblockType", _marker], 0, true];
    }
    else
    {
        _isLargeRoadblock = true;
        spawner setVariable [format ["%1_roadblockType", _marker], 0, true];
    };

    //Define roadblock spawn positions
    if(_isLargeRoadblock) then
    {
        //Define static positions and types
        private _road = roadAt _markerPos;
        private _connectedRoads = roadsConnectedTo _road;

        if((count _connectedRoads) == 0) exitWith
        {
            [1, format ["Roadblock %1 is not placed right, replace it!", _marker], _fileName, true] call A3A_fnc_log;
            _error = true;
        };

        private _roadblockDir = [_road, _connectedRoads select 0] call BIS_fnc_DirTo;
        private _roadPos = getPos _road;

        private _staticPos =
        [
            [[[_roadPos, 7, _roadblockDir + 90] call BIS_Fnc_relPos, _roadblockDir, "MG"], -1],
            [[[_roadPos, 7, _roadblockDir + 270] call BIS_Fnc_relPos, _roadblockDir + 180, "MG"], -1]
        ];

        garrison setVariable [format ["%1_statics", _marker], _staticPos, true];
    }
    else
    {

    };

    private _line = [];
    private _parameter = [];
    if((_side == Invaders) || _isLargeRoadblock) then
    {
        _parameter = ["EMPTY", 0, "AT"];
    }
    else
    {
        _parameter = ["LIGHT_ARMED", 1, "AT"];
    };
    _line = [_parameter, _side] call A3A_fnc_createGarrisonLine;
    garrison setVariable [format ["%1_garrison", _marker], [_line], true];
    garrison setVariable [format ["%1_locked", _marker], [false], true];
}
else
{

};
