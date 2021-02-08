// Hope you like pointers and references, they are used widely in the following code to improve performance
// [35,15] spawn A3A_fnc_NG_main;

params [
    ["_degTolerance",35,[ 35 ]],  // if straight roads azimuth are within this tolerance, they are merged.
    ["_maxDistance",15,[ 15 ]] // Junctions are only merged if within this distance.
];

private _diag_step_main = "";
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
        _diag_step_sub+"<br/>"+
        "</t>"
    ] remoteExec ["A3A_fnc_customHint",0];
};

_diag_step_main = "Extracting roads";
call _fnc_diag_render;

private _halfWorldSize = worldSize/2;
private _worldCentre = [_halfWorldSize,_halfWorldSize];
private _worldMaxRadius = sqrt(0.5 * (worldSize^2));

private _const_allowedRoadTypes = ["ROAD", "MAIN ROAD", "TRACK"];
private _allRoadObjects = nearestTerrainObjects [_worldCentre, _const_allowedRoadTypes, _worldMaxRadius, false, true];

private _diag_step_sub = "Applying connections<br/>No progress report available, due to being too relatively expensive.";
call _fnc_diag_render;
private _navGrid = _allRoadObjects apply {[
    _x,
    roadsConnectedTo [_x,true] select {getRoadInfo _x #0 in _const_allowedRoadTypes}
]};

{
    if (isNil {_x#1}) then {
        [1,"Could not find connections for road '"+str (_x#0)+"' " + str getPos (_x#0) + ".","fn_NG_main"] call A3A_fnc_log;
    };
} forEach _navGrid;

private _diag_step_sub = "Applying distances<br/>No progress report available, due to being too relatively expensive.";
call _fnc_diag_render;
{
    private _road = _x#0;
    _x pushBack ((_x#1) apply {_x distance2D _road});
} forEach _navGrid;


try {
    _diag_step_main = "Fixing";
    _diag_step_sub = "One ways";
    call _fnc_diag_render;
    [4,"A3A_fnc_NG_fix_oneWays","fn_NG_main"] call A3A_fnc_log;
    _navGrid = [_navGrid] call A3A_fnc_NG_fix_oneWays;
//*
    _diag_step_sub = "Simplifying Connection Duplicates";
    call _fnc_diag_render;
    [4,"A3A_fnc_NG_simplify_conDupe","fn_NG_main"] call A3A_fnc_log;
    _navGrid = [_navGrid] call A3A_fnc_NG_simplify_conDupe;         // Some maps have duplicates even before simplification
//*/

    _diag_step_main = "Fixing";
    _diag_step_sub = "Dead Ends";
    call _fnc_diag_render;
    [4,"A3A_fnc_NG_fix_deadEnds","fn_NG_main"] call A3A_fnc_log;
    _navGrid = [_navGrid] call A3A_fnc_NG_fix_deadEnds;

    _diag_step_main = "Simplification";
    _diag_step_sub = "simplify_flat";
    call _fnc_diag_render;
    [4,"A3A_fnc_NG_simplify_flat","fn_NG_main"] call A3A_fnc_log;
    [4,"A3A_fnc_NG_simplify_flat on "+str count _navGrid+" road segments.","fn_NG_main"] call A3A_fnc_log;
    _navGrid = [_navGrid,_degTolerance] call A3A_fnc_NG_simplify_flat;    // Gives less markers for junc to work on. (junc is far more expensive)

//*
    _diag_step_sub = "Simplifying Connection Duplicates";
    call _fnc_diag_render;
    [4,"A3A_fnc_NG_simplify_conDupe","fn_NG_main"] call A3A_fnc_log;
    _navGrid = [_navGrid] call A3A_fnc_NG_simplify_conDupe;         // Some maps have duplicates even before simplification
//*/
//*
    _diag_step_main = "Fixing";
    _diag_step_sub = "One ways";
    call _fnc_diag_render;
    [4,"A3A_fnc_NG_fix_oneWays","fn_NG_main"] call A3A_fnc_log;
    _navGrid = [_navGrid] call A3A_fnc_NG_fix_oneWays;
//*/
/*
    _diag_step_main = "Check";
    _diag_step_sub = "One way check";
    call _fnc_diag_render;
    [4,"A3A_fnc_NG_check_oneWays","fn_NG_main"] call A3A_fnc_log;
    _navGrid = [_navGrid] call A3A_fnc_NG_check_oneWays;
//*/
/*
    _diag_step_main = "Check";
    _diag_step_sub = "Connected Roads Existence";
    call _fnc_diag_render;
    [4,"A3A_fnc_NG_check_conExists","fn_NG_main"] call A3A_fnc_log;
    _navGrid = [_navGrid] call A3A_fnc_NG_check_conExists;
//*/
    _diag_step_sub = "simplify_junc";
    call _fnc_diag_render;
    [4,"A3A_fnc_NG_simplify_junc","fn_NG_main"] call A3A_fnc_log;
    _navGrid = [_navGrid,_maxDistance] call A3A_fnc_NG_simplify_junc;

    _diag_step_sub = "Simplifing Connection Duplicates";
    call _fnc_diag_render;
    [4,"A3A_fnc_NG_simplify_conDupe","fn_NG_main"] call A3A_fnc_log;
    _navGrid = [_navGrid] call A3A_fnc_NG_simplify_conDupe;         // Junc may cause duplicates

    _diag_step_sub = "simplify_flat";
    call _fnc_diag_render;
    [4,"A3A_fnc_NG_simplify_flat","fn_NG_main"] call A3A_fnc_log;
    _navGrid = [_navGrid,15] call A3A_fnc_NG_simplify_flat;    // Clean up after junc, much smaller tolerance

    _diag_step_main = "Conversion Island";
    _diag_step_sub = "Separating Island";
    call _fnc_diag_render;
    [4,"A3A_fnc_NG_separateIslands","fn_NG_main"] call A3A_fnc_log;
    _navIslands = [_navGrid] call A3A_fnc_NG_separateIslands;

    _diag_step_sub = "navIsland to navGridDB";
    call _fnc_diag_render;
    [4,"A3A_fnc_NG_convert_navIslands_navGridDB","fn_NG_main"] call A3A_fnc_log;
    private _navGridDB = [_navIslands] call A3A_fnc_NG_convert_navIslands_navGridDB;
    copyToClipboard str _navGridDB;
//*
    _diag_step_sub = "navGridDB to navIsland";  // Serves as a self check
    call _fnc_diag_render;
    [4,"A3A_fnc_NG_convert_navGridDB_navIslands","fn_NG_main"] call A3A_fnc_log;
    _navIslands = [_navGridDB] call A3A_fnc_NG_convert_navGridDB_navIslands;
//*/
    _diag_step_main = "Drawing Markers";
    _diag_step_sub = "Drawing LinesBetweenRoads";
    call _fnc_diag_render;
    [4,"A3A_fnc_NG_draw_linesBetweenRoads","fn_NG_main"] call A3A_fnc_log;
    [_navIslands,true,true] call A3A_fnc_NG_draw_linesBetweenRoads;

    _diag_step_main = "Drawing Markers";
    _diag_step_sub = "Drawing DotsOnRoads";
    call _fnc_diag_render;
    [4,"A3A_fnc_NG_draw_dotOnRoads","fn_NG_main"] call A3A_fnc_log;
    [_navIslands] call A3A_fnc_NG_draw_dotOnRoads;

    [4,"Col_fnc_nestLoc_rem","fn_NG_main"] call A3A_fnc_log;
    [localNamespace getVariable ["NavGridPP", localNamespace]] call Col_fnc_nestLoc_rem;

    _diag_step_main = "Done";
    _diag_step_sub = "navGridDB copied to clipboard!";
    call _fnc_diag_render;
    copyToClipboard str _navGridDB; // In case user cleared their clipboard
    uiSleep 1;
    call _fnc_diag_render;
} catch {
    ["NavGrid Error",str _exception] call A3A_fnc_customHint;
}
