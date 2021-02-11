/*
Maintainer: Caleb Serafin



    HEY YOU, LOOK HERE!   HEY, DU SIEHST HIER AUS!   ЭЙ, ВЫ СМОТРИТЕ ЗДЕСЬ!   嘿，你在这里看！
    STEP  0:    Run arma.
    STEP  1:    Make empty mp-mission with just one player.
    STEP  2:    Save and close editor.
    STEP  3:    Copy Everything in upper NavGridPP folder (includes: /Collections/; /function/; /description.ext; /functions.hpp)
    STEP  4:    Paste into the folder of the mp mission you created. Usually in `C:\Users\User\Documents\Arma 3 - Other Profiles\YOUR_USER_NAME\mpmissions\MISSION_NAME.MAP\`
    STEP  5:    Start host LAN multiplayer.
    STEP  6:    Run and join mission.
    STEP  7:    Press `Esc` on your keyboard to open debug console.
    STEP  8:    Paste `[35,15] spawn A3A_fnc_NG_main` into big large debug window.
    STEP  9:    Click the button `Local Exec`.
    STEP 10:    Wait for hint to say `Done`&`navGridDB copied to clipboard!`
    STEP 11:    Open a new file.
    STEP 12:    Paste into the new file.
    STEP 13:    Save (Please ask the A3-Antistasi Development Team for this step).



    Technical Specifications:
    Main process that organises the creation of the navGrid.
    Calls many NavGridPP functions independently.
    Output navGRid string includes creation time and config;
    NavGridDB is copied to clipboard.

Arguments:
    <SCALAR> Max drift the simplified line segment can stray from the road in metres. (Default = XX)
    <SCALAR> Junctions are only merged if within this distance.

Return Value:
    <ANY> Undefined

Scope: Client, Global Arguments
Environment: Unscheduled
Public: Yes

Example:
    [35,15] spawn A3A_fnc_NG_main;
*/

params [
    ["_flatMaxDrift",40,[ 0 ]],
    ["_juncMergeDistance",15,[ 0 ]]
];

if (!canSuspend) exitWith {
    throw ["NotScheduledEnvironment","Please execute NG_main in a scheduled environment as it is a long process: `[35,15] spawn A3A_fnc_NG_main;`."];
};

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


private _roadPosNS = [localNamespace,"NavGridPP","main_roadPos", nil, nil] call Col_fnc_nestLoc_set;
private _const_select2 = [0,2];
{
    private _posStr = str (getPos (_x#0) select _const_select2);
    if (_roadPosNS getVariable [_posStr, false]) then {
        [1,"Multiple roads at " + _posStr + ".","fn_NG_main"] call A3A_fnc_log;
    } else {
        _roadPosNS setVariable [_posStr, true];
    };
} forEach _navGrid;
[_roadPosNS] call Col_fnc_nestLoc_rem;

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
    _navGrid = [_navGrid,_flatMaxDrift] call A3A_fnc_NG_simplify_flat;    // Gives less markers for junc to work on. (junc is far more expensive)

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
    _navGrid = [_navGrid,_juncMergeDistance] call A3A_fnc_NG_simplify_junc;

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
    _navIslands = [_navGrid] call A3A_fnc_NG_convert_navGrid_navIslands;

    _diag_step_sub = "navIsland to navGridDB";
    call _fnc_diag_render;
    [4,"A3A_fnc_NG_convert_navIslands_navGridDB","fn_NG_main"] call A3A_fnc_log;
    private _navGridDB = [_navIslands] call A3A_fnc_NG_convert_navIslands_navGridDB; // (systemTimeUTC call A3A_fnc_systemTime_format_G)
    private _navGridDB_formatted = ("/*{""systemTimeUCT_G"":"""+(systemTimeUTC call A3A_fnc_systemTime_format_G)+""",""worldName"":"""+worldName+""",""NavGridPP_Config"":{""_flatMaxDrift"":"+str _flatMaxDrift+",""_juncMergeDistance"":"+str _juncMergeDistance+"}}*/
") + ([_navGridDB] call A3A_fnc_NG_format_navGridDB);

    copyToClipboard str _navGridDB_formatted;
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
    [_navIslands,true,false] call A3A_fnc_NG_draw_linesBetweenRoads;

    _diag_step_main = "Drawing Markers";
    _diag_step_sub = "Drawing DotsOnRoads";
    call _fnc_diag_render;
    [4,"A3A_fnc_NG_draw_dotOnRoads","fn_NG_main"] call A3A_fnc_log;
    [_navIslands] call A3A_fnc_NG_draw_dotOnRoads;

    [4,"Col_fnc_nestLoc_rem","fn_NG_main"] call A3A_fnc_log;
    [localNamespace getVariable ["NavGridPP", localNamespace]] call Col_fnc_nestLoc_rem;

    private _roadPosNS = [localNamespace,"NavGridPP","main_roadPos", nil, nil] call Col_fnc_nestLoc_set;
    private _const_select2 = [0,2];
    {
        private _posStr = str (getPos (_x#0) select _const_select2);
        if (_roadPosNS getVariable [_posStr, false]) then {
            [1,"Multiple roads at " + _posStr + ".","fn_NG_main"] call A3A_fnc_log;
        } else {
            _roadPosNS setVariable [_posStr, true];
        };
    } forEach _navGrid;
    [_roadPosNS] call Col_fnc_nestLoc_rem;

    _diag_step_main = "Done";
    _diag_step_sub = "navGridDB copied to clipboard!";
    call _fnc_diag_render;
    copyToClipboard _navGridDB_formatted; // In case user cleared their clipboard
    uiSleep 1;
    call _fnc_diag_render;
} catch {
    ["NavGrid Error",str _exception] call A3A_fnc_customHint;
}
