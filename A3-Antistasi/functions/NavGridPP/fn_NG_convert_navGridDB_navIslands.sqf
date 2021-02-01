params [
    ["_navGridDB_IN",[],[ [] ]]
];
private _navGridDB = +_navGridDB_IN;

/*
roadTypeEnum
0: TRAIL
1: ROAD
2: MAIN ROAD

navGridDB
[
    [pos3D, islandID, isJunction, [connectedRoadIndex, roadTypeEnum, distance]]
    ...
]


navIslands
[
    [ // each island
        [road, [connectedRoads],[connectedDistances]],
        ...
    ]
    ...
]
*/

{
    _x set [0, roadAt (_x#0)]
} forEach _navGridDB;
// [road, islandID, isJunction, [connectedRoadIndex, roadTypeEnum, distance]]

private _failedRoadList = [];
{
    if (isNull (_x#0)) then {
        _failedRoadList pushBack _navGridDB_IN #_forEachIndex #0;
    };
} forEach _navGridDB;
if !(_failedRoadList isEqualTo []) exitWith {
    ["ERROR: COULD NOT FIND ROAD AT",str _failedRoadList] call A3A_fnc_customHint;
    copyToClipboard str _failedRoadList;
    {
        private _name = "NGPP_error_" + str _x;
        createMarkerLocal [_name,_x];
        _name setMarkerTypeLocal "mil_dot";
        _name setMarkerSizeLocal [1, 1];
        _name setMarkerColor "ColorRed";
    } forEach _failedRoadList;
    [];
};


{
    private _connections = _x#3;
    {
        _x set [0, (_navGridDB #(_x#0) )#0 ];
    } forEach _connections;
} forEach _navGridDB;
// [road, islandID, isJunction, [connectedRoad, roadTypeEnum, distance]]

  // This process is done in case the ID's jump numbers
private _islandIDs = [];
{
    _islandIDs pushBackUnique (_x#1);
} forEach _navGridDB;
_islandIDs sort true;

_navGridDBIslands = _islandIDs apply {[]};
{
    _navGridDBIslands#(_x#1) pushBack _x;
} forEach _navGridDB;
// [road, islandID, isJunction, [connectedRoad, roadTypeEnum, distance]]

private _navIslands = _navGridDBIslands apply {_x apply {[
    _x#0,
    (_x#3) apply {_x#0},
    (_x#3) apply {_x#2}
]}};
_navIslands;
