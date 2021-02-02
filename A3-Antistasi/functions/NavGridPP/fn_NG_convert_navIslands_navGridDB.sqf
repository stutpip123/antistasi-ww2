params [
    ["_navIslands_IN",[],[ [] ]]
];
private _navIslands = +_navIslands_IN;

/* navIslands
[
    [ // each island
        [road, [connectedRoads],[connectedDistances]],
        ...
    ]
    ...
]

roadTypeEnum
0: TRAIL
1: ROAD
2: MAIN ROAD

navGridDB
[
    [pos3D, island number, isJunction, [connectedRoadIndex, roadTypeEnum, distance]]
    ...
]
*/

{
    private _islandID = _forEachIndex;
    {
        _x pushBack _islandID;
    } forEach _x;   // forEach island, inner _x will be a road struct
} forEach _navIslands;

private _navGrid = [_navIslands] call A3A_fnc_NG_mergeIslands;
private _roadIndexNS = [false] call A3A_fnc_createNamespace;
{
    _roadIndexNS setVariable [str (_x#0),_forEachIndex];
} forEach _navGrid; // [road, [connectedRoad], [connectedDistances], islandID]

private _const_roadTypeEnum = ["TRACK","ROAD","MAIN ROAD"]; // Case sensitive
{
    private _struct = _x;
    private _connected = _struct#1;

    {
        private _connection = _x;
        _connected set [_forEachIndex, [
            _roadIndexNS getVariable [str _x, -1],
            _const_roadTypeEnum find (getRoadInfo _x #0),
            _struct#2#_forEachIndex
        ]];
    } forEach _connected;
} forEach _navGrid; // [road, [[connectedRoadIndex,typeEnum,connectedDistance]], [connectedDistances], islandID]
deleteLocation _roadIndexNS;

private _const_pos2DSelect = [0,2];
private _const_posOffsetMatrix = [];    // Okay, not really constant, but you get the deal
for "_axis_x" from -3 to 3 step 2 do {  // will skip zero and other useless numbers
    for "_axis_y" from -3 to 3 step 2 do {
        _const_posOffsetMatrix pushBack [_axis_x,_axis_y];
    };
};
_fnc_tryGetPos = { // This feature will unused for the time being,
    params ["_road"];

    private _pos = getPos _road;
    if (isNull roadAt _pos) then {
        _pos = _pos select _const_pos2DSelect;
    };
    if (isNull roadAt _pos) then {    // Now we go all out and try a bunch of values from an offset matrix.
        {
            private _newPos = _pos vectorAdd _x select _const_pos2DSelect;  // vectorAdd puts the z back
            if (roadAt _newPos isEqualTo _road) exitWith { _pos = _newPos };   // isEqual check in case a different road was found.
        } forEach _const_posOffsetMatrix;
    };
    if (isNull roadAt _pos) then {
        [1,"Could not round-trip road position at " + str _pos + ".","fn_NG_convert_navIslands_navGrid"] call A3A_fnc_log;
        ["convert_navIslands_navGrid Error","Please check RPT."] call A3A_fnc_customHint;
    };
    _pos;
};

private _navGridDB = _navGrid apply {[
    getPos (_x#0) select _const_pos2DSelect,
    _x#3,
    count (_x#1) > 2,
    _x#1
]};

_navGridDB;
