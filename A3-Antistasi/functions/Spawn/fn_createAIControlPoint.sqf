params ["_marker", "_side"];

private _fileName = "createAIControlPoint";
private _markerPos = getMarkerPos _marker;
private _isRoadblock = if(isOnRoad _markerPos) then {true} else {false};

private _type = if(_isRoadblock) then {"Roadblock"} else {"Minefield"};
[2, format ["Spawning in %1 for side %2", _type, _side], _fileName] call A3A_fnc_log;

private _error = false;

private _vehicles = [];
private _groups = [];

if(_isRoadblock) then
{
    private _road = roadAt _markerPos;
    private _connectedRoads = roadsConnectedTo _road;

    if((count _connectedRoads) == 0) exitWith
    {
        [1, format ["Roadblock %1 is not placed right, replace it!", _marker], _fileName] call A3A_fnc_log;
        _error = true;
    };

    private _roadblockDir = [_road, _connectedRoads select 0] call BIS_fnc_DirTo;

    private _roadPos = getPos _road;
    private _bunkerPos =
    [
        [[_roadPos, 7, _roadblockDir + 90] call BIS_Fnc_relPos, 0],
        [[_roadPos, 7, _roadblockDir + 270] call BIS_Fnc_relPos, 180]
    ];
    private _staticType = if (_side == Occupants) then {NATOMG} else {CSATMG};
    private _staticCrew = if (_sideX == Occupants) then {staticCrewOccupants} else {staticCrewInvaders};
    private _staticGroup = createGroup _side;
    _groups pushBack _staticGroup;

    {
        _x params ["_bunkerSpawnPos", "_bunkerDir"];
        private _bunker = "Land_BagBunker_01_Small_green_F" createVehicle _bunkerSpawnPos;
        _vehicles pushBack _bunker;
        _bunker setDir (_roadblockDir + _bunkerDir);

        private _pos = _building buildingPos 0;
        private _dir = (getDir _building) - 180;
        _pos = [_pos, 1.5, (_dir)] call BIS_fnc_relPos;

        private _static = _staticType createVehicle _pos;
        [_static] call A3A_fnc_AIVEHinit;
        _vehicles pushBack _static;
        _static setDir _dir;
        _static setPosATL _pos;

        private _crew = _staticGroup createUnit [_staticCrew, _bunkerSpawnPos, [], 5, "NONE"];
        _crew moveInGunner _static;
        [_crew] call A3A_fnc_NATOinit;
    } forEach _bunkerPos;
}
else
{

};
