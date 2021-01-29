// Hope you like pointers and references, they are used widely in the following code to improve performance
// [] spawn A3A_fnc_NG_start;

params [
    ["_useHCs",false,[false]]
];

private _diag_step_main = "[]";
private _diag_step_sub = "";
private _diag_step_sub_progress = []; // <Array<island,totalIslandSegments>>

private _diag_totalSegments = -1;
private _diag_islandCounter = -1;
private _diag_segmentCounter = 0;

private _fnc_diag_render = { // call _fnc_diag_render;
    [
        "Nav Grid++",
        "<t align='left'>" +
        _diag_step_main+"<br/>"+
        "Completed Islands: <br/>"+
        ((_diag_step_sub_progress apply {"  " + (str (_x#0)) + " : " + (str (_x#1))}) joinString "<br/>") +"<br/>"+
        _diag_step_sub+"<br/>"+
        "</t>"
    ] remoteExec ["A3A_fnc_customHint",0];
};



private _registerNS = [localNamespace,"A3A_NGPP","Register", nil, nil] call Col_fnc_nestLoc_set;
private _unprocessedNS = [localNamespace,"A3A_NGPP","Unprocessed", nil, nil] call Col_fnc_nestLoc_set;

private _allRoadSegments = [_registerNS] call A3A_fnc_NG_registerAllRoads;
if (count _allRoadSegments == 0) exitWith {};

_diag_step_main = "Setting unprocessed segments.";
call _fnc_diag_render;
private _unprocessed = _allRoadSegments apply {str _x};
{ _unprocessedNS setVariable [_x,true]; } forEach _unprocessed;
_diag_totalSegments = count _unprocessed;

private _allowedRoadTypes = ["ROAD", "MAIN ROAD", "TRACK"];

private _fnc_tryDequeueUnprocessed = {
    if ((count _unprocessed) == 0) then {
        objNull;    //return
    } else {
        private _newSegment = _unprocessed deleteAt 0;
        _registerNS getVariable [_newSegment,objNull]; //return
    };
};

private _fnc_removeFromUnprocessed = {  // Pass in string, not array // str _currentSegment call _fnc_removeFromUnprocessed;
    _unprocessedNS setVariable [_this,false];
    _unprocessed deleteAt (_unprocessed find _this);
};


private _navigationGrids = [];      //<ARRAY< island ARRAY<Road,connections ARRAY<Road>>  >>
[localNamespace,"A3A_NGPP","NavigationGrids",_navigationGrids] call Col_fnc_nestLoc_set;


private _currentNavigationGrid = [];  // ARRAY<Road,connections ARRAY<Road>,connections Indices ARRAY<scalar>>
//private _currentNavigationStruct = []; // <Road,connections ARRAY<Road>>  // Implied when following is used  `_currentNavigationGrid pushBack [_currentSegment,_currentNavigationConnections];`
// private _currentNavigationConnections = []; // <ARRAY<Road>>


private _currentSegment = objNull;
private _lastUnexploredJunctions = [];      // segment itself is explored, but it is connected to segments that are not explored.

private _currentConnections = [];
private _currentConnectionsCount = 0;


_diag_step_main = "Starting main loop";
call _fnc_diag_render;
while {true} do {   // is broken out after _fnc_tryDequeueUnprocessed
    _diag_islandCounter = _diag_islandCounter +1;
    private _diag_islandSegmentCounter = 0;

    _currentNavigationGrid = [];

    _currentSegment = call _fnc_tryDequeueUnprocessed;
    if (isNull _currentSegment) exitWith {};

    private _islandRoadIndices = [false] call A3A_fnc_createNamespace;
    while {!(isNil {_currentSegment} || {isNull _currentSegment})} do {
        _diag_segmentCounter = _diag_segmentCounter + 1;
        _diag_islandSegmentCounter = _diag_islandSegmentCounter + 1;

        if (_diag_segmentCounter mod 100 == 0) then {
            _diag_step_sub = "Total Completion &lt;" + ((100 * _diag_segmentCounter / _diag_totalSegments) toFixed 1) + "%&gt; (Segment &lt;" + str _diag_segmentCounter + " / " + str _diag_totalSegments + "&gt;).";
            call _fnc_diag_render;
        };

        str _currentSegment call _fnc_removeFromUnprocessed;

        _currentConnections = roadsConnectedTo [_currentSegment,true] select {getRoadInfo _x #0 in _allowedRoadTypes};
        _currentNavigationGrid pushBack [_currentSegment,_currentConnections];

        //["NGPP Sub2","segment &lt;" + str _currentSegment + "&gt;allConnections &lt;" + str count _currentConnections + "&gt; isunprocessed &lt;" + str (_currentConnections apply {_unprocessedNS getVariable [str _x, false]}) + "&gt;"] remoteExec ["A3A_fnc_customHint",0];
        _currentConnections = _currentConnections select {_unprocessedNS getVariable [str _x, false]};   // Only unexplored connections.
        _currentConnectionsCount = count _currentConnections;

        switch (_currentConnectionsCount) do {
            case (0): { _currentSegment = _lastUnexploredJunctions deleteAt 0};   // Put missing road finding code here.
            case (1): {
                _currentSegment = _currentConnections#0;
            };
            default {
                _lastUnexploredJunctions pushBack _currentSegment;
                _currentSegment = _currentConnections#0;
            };
        };
    };

    // Indexing all the connections
    private _count_currentNavigationGrid = count _currentNavigationGrid;
    _currentNavigationGridNS = [false] call A3A_fnc_createNamespace;
    _diag_step_sub = "Loading island segments ...;).";
    call _fnc_diag_render;
    { _currentNavigationGridNS setVariable [str (_x#0),_forEachIndex]; } forEach _currentNavigationGrid;
    {
        if (_diag_segmentCounter mod 100 == 0) then {
            _diag_step_sub = "Indexing island segments &lt;" + ((100 * _forEachIndex / _count_currentNavigationGrid) toFixed 1) + "%&gt; (Segment &lt;" + str _forEachIndex + " / " + str _count_currentNavigationGrid + "&gt;).";
            call _fnc_diag_render;
        };
        _x pushBack ((_x#1) apply {_currentNavigationGridNS getVariable [str _x,-1]}); // indicies for ach connection
    } forEach _currentNavigationGrid;
    deleteLocation _currentNavigationGridNS;


    // Adding to all islands navigation grids array.
    _navigationGrids pushBack _currentNavigationGrid;
    if ((count _diag_step_sub_progress) > 9) then {
        _diag_step_sub_progress resize 8;
        _diag_step_sub_progress pushBack ["...","..."];
    };
    _diag_step_sub_progress pushBack [_diag_islandCounter,_diag_islandSegmentCounter];
    call _fnc_diag_render;
};

private _navGridsSimple = [_navigationGrids,_diag_step_sub_progress] call A3A_fnc_NG_simplify;
[localNamespace,"A3A_NGPP","NavigationGridsSimple",_navGridsSimple] call Col_fnc_nestLoc_set;

_diag_step_main = "Drawing Markers";
_diag_step_sub = "Drawing DotsOnRoads";
call _fnc_diag_render;
[_navGridsSimple] call A3A_fnc_NG_draw_dotOnRoads;
_diag_step_sub = "Drawing LinesBetweenRoads";
call _fnc_diag_render;
[_navGridsSimple] call A3A_fnc_NG_draw_linesBetweenRoads;

_diag_step_main = "Done";
_diag_step_sub = "Done";
call _fnc_diag_render;