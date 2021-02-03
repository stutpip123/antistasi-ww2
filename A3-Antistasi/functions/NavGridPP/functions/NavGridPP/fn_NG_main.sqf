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

private _progress = [0,count _allRoadObjects];
private _render_script_applyDistances = [_progress] spawn {
    params ["_progress"];
    while {true} do {
        [
            "Nav Grid++",
            "<t align='left'>" +
            "Applying distances<br/>"+
            "Completion &lt;" + ((100*(_progress#0) /(_progress#1)) toFixed 1) + "% &gt; Processing segment &lt;" + (str (_progress#0)) + " / " + (str (_progress#1)) + "&gt;"+"<br/>"+
            "</t>"
        ] remoteExec ["A3A_fnc_customHint",0];
        uiSleep 0.2;
    };
};
private _navGrid = _allRoadObjects apply {
    _progress set [0,_progress#0 +1];
    private _road = _x;
    private _connected = roadsConnectedTo [_x,true] select {getRoadInfo _x #0 in _const_allowedRoadTypes};
    [_road,_connected,_connected apply {_X distance2D _road}];
};
if !(scriptDone _render_script_applyDistances) then {
    terminate _render_script_applyDistances;
};

_diag_step_main = "Fixing";
_diag_step_sub = "missingRoadCheck";
call _fnc_diag_render;
[4,"A3A_fnc_NG_missingRoadCheck","fn_NG_main"] call A3A_fnc_log;
_navGrid = [_navGrid] call A3A_fnc_NG_missingRoadCheck;

_diag_step_main = "Simplification";
_diag_step_sub = "simplify_flat";
call _fnc_diag_render;
[4,"A3A_fnc_NG_simplify_flat","fn_NG_main"] call A3A_fnc_log;
_navGrid = [_navGrid,_degTolerance] call A3A_fnc_NG_simplify_flat;    // Gives less markers for junc to work on. (junc is far more expensive)

_diag_step_sub = "simplify_junc";
call _fnc_diag_render;
[4,"A3A_fnc_NG_simplify_junc","fn_NG_main"] call A3A_fnc_log;
_navGrid = [_navGrid,_maxDistance] call A3A_fnc_NG_simplify_junc;

_diag_step_sub = "Simplifing Connection Duplicates";
call _fnc_diag_render;
[4,"A3A_fnc_NG_simplify_conDupe","fn_NG_main"] call A3A_fnc_log;
_navGrid = [_navGrid] call A3A_fnc_NG_simplify_conDupe;

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
_diag_step_sub = "navGridDB to navIsland";
call _fnc_diag_render;
[4,"A3A_fnc_NG_convert_navGridDB_navIslands","fn_NG_main"] call A3A_fnc_log;
_navIslands = [_navGridDB] call A3A_fnc_NG_convert_navGridDB_navIslands;

_diag_step_main = "Drawing Markers";
_diag_step_sub = "Drawing LinesBetweenRoads";
call _fnc_diag_render;
[4,"A3A_fnc_NG_draw_linesBetweenRoads","fn_NG_main"] call A3A_fnc_log;
[_navIslands,true,true] call A3A_fnc_NG_draw_linesBetweenRoads;
_diag_step_main = "Drawing Markers";
_diag_step_sub = "Drawing DotsOnRoads";
call _fnc_diag_render;
[4,"A3A_fnc_NG_draw_dotOnRoads","fn_NG_main"] call A3A_fnc_log;
//[_navIslands] call A3A_fnc_NG_draw_dotOnRoads;

[4,"Col_fnc_nestLoc_rem","fn_NG_main"] call A3A_fnc_log;
[localNamespace getVariable ["NavGridPP", localNamespace]] call Col_fnc_nestLoc_rem;

_diag_step_main = "Done";
_diag_step_sub = "navGridDB copied to clipboard!";
call _fnc_diag_render;
copyToClipboard str _navGridDB;
