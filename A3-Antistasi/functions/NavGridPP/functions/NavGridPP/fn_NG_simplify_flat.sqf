params [
    ["_navGrid",[],[ [] ]],  //ARRAY<  Road, ARRAY<connectedRoad>>, ARRAY<distance>  >
    ["_degTolerance",35,[ 35 ]]  // if straight roads azimuth are within this tolerance, they are merged.
];
private _navGridSimple = +_navGrid;

copyToClipboard str _navGrid;

private _diag_step_sub = "";

private _fnc_diag_render = { // call _fnc_diag_render;
    [
        "Nav Grid++",
        "<t align='left'>" +
        "Simplifying navGrid<br/>"+
        "Simplifying Flat Segments<br/>"+
        _diag_step_sub+"<br/>"+
        "</t>"
    ] remoteExec ["A3A_fnc_customHint",0];
};

private _fnc_getStruct = {
    params ["_navGridSimple","_roadIndexNS","_roadName"];
    _navGridSimple #(_roadIndexNS getVariable [_roadName,-1]);
};
private _fnc_replaceRoadConnection = {
    params ["_roadStruct","_oldRoadConnection","_newRoadConnection","_newDistance"];
    private _connectionRoads = _roadStruct#1;
    private _conIndex = _connectionRoads find _oldRoadConnection;
    if (_conIndex == -1) exitWith {
        [4,"Road '"+str (_roadStruct#0)+"' " + str getPos (_roadStruct#0) + " was not connected to old road '"+str _oldRoadConnection+"' " + str getPos _oldRoadConnection + ".","fn_NG_simplify_flat"] call A3A_fnc_log;
        ["fn_NG_simplify_flat Error","Please check RPT."] call A3A_fnc_customHint;
    };
    _connectionRoads set [_conIndex,_newRoadConnection];
    (_roadStruct#2) set [_conIndex,_newDistance];
};
private _fnc_removeRoadConnection = {
    params ["_roadStruct","_oldRoadConnection"];
    private _connectionRoads = _roadStruct#1;
    private _conIndex = _connectionRoads find _oldRoadConnection;
    _connectionRoads deleteAt _conIndex;
    (_roadStruct#2) deleteAt _conIndex;
};
private _fnc_isRoadConnected = {    // Assumes both will have connection, no one-way.
    params ["_struct","_road"];

    _road in (_struct#1);
};

call _fnc_diag_render;

private _orphanedIndices = [];

private _roadIndexNS = [localNamespace,"NavGridPP","simplify_flat_roadIndex", nil, nil] call Col_fnc_nestLoc_set;
{
    _roadIndexNS setVariable [str (_x#0),_forEachIndex];
} forEach _navGridSimple; // _x is road struct <road,ARRAY<connections>,ARRAY<indices>>



private _fnc_canSimplify = {
    params ["_myRoad","_otherRoad"];
    private _myInfo = getRoadInfo _myRoad;
    private _otherInfo = getRoadInfo _otherRoad;

    if !(_myInfo#0 isEqualTo _otherInfo#0) exitWith {false;};

    private _myAzimuth = (_myInfo#6 getDir _myInfo#7) mod 180;
    private _otherAzimuth = (_otherInfo#6 getDir _otherInfo#7) mod 180;
    abs (_myAzimuth - _otherAzimuth) < _degTolerance;          // Edit the direction change here.
};

private _diag_totalSegments = count _navGridSimple;
{
    if (_forEachIndex mod 100 == 0) then {
        _diag_step_sub = "Completion &lt;" + ((100*_forEachIndex /_diag_totalSegments) toFixed 1) + "% &gt; Processing segment &lt;" + (str _forEachIndex) + " / " + (str _diag_totalSegments) + "&gt;";;
        call _fnc_diag_render;
    };

    private _currentStruct = _x;
    private _currentConnectionNames = _currentStruct#1;
    if ((count _currentConnectionNames) == 2) then {

        private _connectRoad0 = _currentConnectionNames#0;
        private _connectRoad1 = _currentConnectionNames#1;
        if !([_connectRoad0,_connectRoad1] call _fnc_canSimplify) exitWith {};  // Only merge same types of roads and similar azimuth, this will preserve road types and corners
        private _connectStruct0 = [_navGridSimple,_roadIndexNS,str _connectRoad0] call _fnc_getStruct;
        private _connectStruct1 = [_navGridSimple,_roadIndexNS,str _connectRoad1] call _fnc_getStruct;
        private _currentRoad = _currentStruct#0;

        if !([_connectStruct0,_connectRoad1] call _fnc_isRoadConnected) then {  // If our neighbours are not already connected:
            private _connectionDistances = _currentStruct#2;
            private _newDistance = _connectionDistances#0 + _connectionDistances#1;

            [_connectStruct0,_currentRoad,_connectRoad1,_newDistance] call _fnc_replaceRoadConnection;       // We connect our two neighbors together, replacing our own connection
            [_connectStruct1,_currentRoad,_connectRoad0,_newDistance] call _fnc_replaceRoadConnection;
        } else {
            [_connectStruct0,_currentRoad] call _fnc_removeRoadConnection;
            [_connectStruct1,_currentRoad] call _fnc_removeRoadConnection;
        };
        _orphanedIndices pushBack _forEachIndex;
    };
} forEach _navGridSimple;
[_roadIndexNS] call Col_fnc_nestLoc_rem;

_diag_step_sub = "Cleaning orphans...";
call _fnc_diag_render;
reverse _orphanedIndices;
[_navGridSimple,_orphanedIndices] call Col_fnc_array_remIndices;

_navGridSimple;

//private _navGridFixed = _navGrid apply {str (_x#0)} apply {_navGridNS getVariable [_x,nil]};