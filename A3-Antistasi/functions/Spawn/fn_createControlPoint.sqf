#define ROADBLOCK_LARGE 0
#define ROADBLOCK_SMALL 1

#define ROADBLOCK 10
#define MINEFIELD 11
#define WATCHPOST 12

params ["_marker", "_side"];

private _fileName = "createAIControlPoint";
private _markerPos = getMarkerPos _marker;

private _type = 0;
private _typeString = "";
if(_side != teamPlayer) then
{
    if(isOnRoad _markerPos) then
    {
        _type = ROADBLOCK;
        _typeString = "roadblock";
    }
    else
    {
        _type = MINEFIELD;
        _typeString = "minefield";
    };
}
else
{
    if(isOnRoad _markerPos) then
    {
        _type = ROADBLOCK;
        _typeString = "roadblock";
    }
    else
    {
        _type = WATCHPOST;
        _typeString = "watchpost";
    };
};

[2, format ["Spawning in %1 for side %2", _typeString, _side], _fileName, true] call A3A_fnc_log;
private _vehicles = [];
private _groups = [];
private _error = false;

switch (_type) do
{
    case (ROADBLOCK):
    {
        private _road = roadAt _markerPos;
        private _connectedRoads = roadsConnectedTo _road;
        if((count _connectedRoads) == 0) exitWith
        {
            [1, format ["Roadblock %1 is not placed right, replace it!", _marker], _fileName, true] call A3A_fnc_log;
            _error = true;
        };

        private _roadblockDir = [_road, _connectedRoads select 0] call BIS_fnc_DirTo;
        private _roadPos = getPos _road;

        private _staticType = "";
        private _staticCrew = "";
        private _armedVehicle = "";
        private _roadblockType = _marker getVariable ["roadblockType"];

        switch (_side) do
        {
            case (Occupants):
            {
                _staticType = NATOMG;
                _staticCrew = staticCrewOccupants;
            };
            case (Invaders):
            {
                _staticType = CSATMG;
                _staticCrew = staticCrewInvaders;
            };
        };

        if(_roadblockType == ROADBLOCK_LARGE) then
        {
            private _bunkerPos =
            [
                [[_roadPos, 7, _roadblockDir + 90] call BIS_Fnc_relPos, 0],
                [[_roadPos, 7, _roadblockDir + 270] call BIS_Fnc_relPos, 180]
            ];

            private _staticGroup = createGroup _side;
            _groups pushBack _staticGroup;

            {
                _x params ["_bunkerSpawnPos", "_bunkerDir"];
                private _bunker = "Land_BagBunker_01_Small_green_F" createVehicle _bunkerSpawnPos;
                _vehicles pushBack _bunker;

                _bunker setDir (_roadblockDir + _bunkerDir);
                _bunker setVectorUp (surfaceNormal _bunkerSpawnPos);

                private _pos = _bunker buildingPos 0;
                private _dir = (getDir _bunker) - 180;
                _pos = [_pos, 1.5, (_dir)] call BIS_fnc_relPos;
            } forEach _bunkerPos;
        };
    };
    case (MINEFIELD):
    {
        if([_marker] call A3A_fnc_isFrontline) then
        {
    		private _size = [_marker] call A3A_fnc_sizeMarker;
    		if ({if (_x inArea _marker) exitWith {1}} count allMines == 0) then
    		{
    			for "_i" from 1 to 60 do
    			{
    				_mine = createMine ["APERSMine", _markerPos, [], _size];
                    _vehicles pushBack _mine;
    				if (_side == Occupants) then
                    {
                        Occupants revealMine _mine;
                    }
                    else
                    {
                        Invaders revealMine _mine;
                    };
    			};
    		};
        };
    };
    case (WATCHPOST):
    {
        //code
        //Currently there are no buildings on FIA watchpost, if we want to add them, add them here
    };
};


[_marker, _marker, _vehicles, _groups] spawn A3A_fnc_cycleSpawn;
