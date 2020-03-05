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
        private _roadblockType = "";

        switch (_side) do
        {
            case (Occupants):
            {
                _staticType = NATOMG;
                _staticCrew = staticCrewOccupants;
                _armedVehicle = if !(hasIFA) then {vehFIAArmedCar} else {vehFIACar};
                _roadblockType = if (random 10 < tierWar) then {ROADBLOCK_LARGE} else {ROADBLOCK_SMALL};
            };
            case (Invaders):
            {
                _staticType = CSATMG;
                _staticCrew = staticCrewInvaders;
                _armedVehicle = "";              //Not needed as they have no small roadblocks (We might want to think this over)
                _roadblockType = ROADBLOCK_LARGE;
            };
            case (teamPlayer):
            {
                _staticType = "";
                _staticCrew = staticCrewTeamPlayer;
                _armedVehicle = vehSDKLightArmed;
                _roadblockType = ROADBLOCK_SMALL;
            };
        };

        if(_roadblockType == ROADBLOCK_LARGE) then
        {
            /*
            private _bunkerPos =
            [
                [[_roadPos, 7, _roadblockDir + 90] call BIS_Fnc_relPos, 0],
                [[_roadPos, 7, _roadblockDir + 270] call BIS_Fnc_relPos, 180]
            ];
             = if (_side == Occupants) then {} else {};
             = if (_side == Occupants) then {} else {};
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

                private _static = _staticType createVehicle _pos;
                [_static] call A3A_fnc_AIVEHinit;
                _vehicles pushBack _static;
                _static setDir _dir;
                _static setVectorUp _pos;
                _static setPosATL _pos;

                private _crew = _staticGroup createUnit [_staticCrew, _bunkerSpawnPos, [], 5, "NONE"];
                _crew moveInGunner _static;
                [_crew] call A3A_fnc_NATOinit;
            } forEach _bunkerPos;
            */
        }
        else
        {

        };
    };
    case (MINEFIELD):
    {
        //code
    };
    case (WATCHPOST):
    {
        //code
    };
};


[_marker, _marker, _vehicles, _groups] spawn A3A_fnc_cycleSpawn;
