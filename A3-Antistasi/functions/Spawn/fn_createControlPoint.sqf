#define ROADBLOCK_LARGE 0
#define ROADBLOCK_SMALL 1

#define ROADBLOCK 10
#define MINEFIELD 11
#define WATCHPOST 12

params ["_marker", "_side"];

private _fileName = "createControlPoint";
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

private _garrison = [_marker] call A3A_fnc_getGarrison;
if(_garrison isEqualTo [] && (_side != teamPlayer)) then
{
    [2, format ["Control %1 has no data set yet, creating now", _marker], _fileName, true] call A3A_fnc_log;
    [_marker, _side] call A3A_fnc_initControlMarker;
};
private _vehicles = [];
private _groups = [];

switch (_type) do
{
    case (ROADBLOCK):
    {
        private _roadblockType = spawner getVariable [format ["%1_roadblockType", _marker], ROADBLOCK_SMALL];
        if(_roadblockType == ROADBLOCK_LARGE) then
        {
            private _spawnPos = garrison getVariable [format ["%1_statics", _marker], []];
            {
                private _params = _x select 0;
                _params params ["_bunkerSpawnPos", "_bunkerDir"];
                //_bunkerSpawnPos = [_bunkerSpawnPos, 1, _bunkerDir] call BIS_fnc_relPos;
                _bunkerDir = _bunkerDir - 180;
                private _bunker = "Land_BagBunker_01_Small_green_F" createVehicle _bunkerSpawnPos;
                _vehicles pushBack [_bunker, [15, -1]];

                _bunker setDir _bunkerDir;
                _bunker setVectorUp (surfaceNormal _bunkerSpawnPos);
                _bunker setPos _bunkerSpawnPos;
            } forEach _spawnPos;
        };
    };
    case (MINEFIELD):
    {
        if([_marker] call A3A_fnc_isFrontline) then
        {
    		private _size = [_marker] call A3A_fnc_sizeMarker;
    		if ({if (_x inArea _marker) exitWith {1}} count allMines == 0) then
    		{
                //Mines are not saved as vehicles and will not despawn on capturing the marker or getting too far away
                //Cause that it not how minefields works
    			for "_i" from 1 to 60 do
    			{
    				_mine = createMine ["APERSMine", _markerPos, [], _size];
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
