params [
    ["_navGrids",[],[ [] ]] //<ARRAY< island ARRAY<Road,connections ARRAY<Road>>,connection indices ARRAY<scalar>  >>
];
private _simpleNavGrids = +_navGrids;

private _diag_step_main = "[]";
private _diag_step_sub = "";

private _diag_islandCounter = -1;

private _fnc_diag_render = { // call _fnc_diag_render;
    [
        "Nav Grid++",
        "<t align='left'>" +
        "Simplifying segments<br/>"+
        _diag_step_main+"<br/>"+
        "Completed Islands: <br/>"+
        _diag_step_sub+"<br/>"+
        "</t>"
    ] remoteExec ["A3A_fnc_customHint",0];
};

private _fnc_getStruct = {
    params ["_registerNS","_roadName"];
    _registerNS getVariable [_roadName,[]];
};
private _fnc_replaceRoadConnection = {
    params ["_roadStruct","_oldRoadConnection","_newRoadConnection"];
    private _connectionRoads = _roadStruct#1;
    private _conIndex = _connectionRoads find _oldRoadConnection;
    _connectionRoads set [_conIndex,_newRoadConnection];
};
private _fnc_isRoadConnected = {    // Assumes both will have connection, no one-way.
    params ["_struct","_road"];

    _road in (_struct#1);
};

{
    _diag_islandCounter = _diag_islandCounter +1;
    _diag_step_main = "Processing Island &lt;" + str _diag_islandCounter + " / " + str (count _simpleNavGrids -1) + "&gt;";
    call _fnc_diag_render;

    _currentNavGrid = _x;
    _diag_totalSegments = count _currentNavGrid;
    private _orphanedIndices = [];

    private _registerNS = [false] call A3A_fnc_createNamespace;
    {
        _registerNS setVariable [str (_x#0),_x];
    } forEach _currentNavGrid; // _x is road struct <road,ARRAY<connections>,ARRAY<indices>>

    private _diag_sub_counter = -1;
    {
        _diag_sub_counter = _diag_sub_counter +1;
        if (_diag_sub_counter mod 100 == 0) then {
            _diag_step_sub = "Completion &lt;" + ((100*_forEachIndex /_diag_totalSegments) toFixed 1) + "% &gt; Processing segment &lt;" + (str _forEachIndex) + " / " + (str _diag_totalSegments) + "&gt;";;
            call _fnc_diag_render;
        };

        private _currentStruct = _x;
        private _currentConnectionNames = _currentStruct#1;   // Only unexplored connections.
        if ((count _currentConnectionNames) == 2) then {

            private _connectRoad0 = _currentConnectionNames#0;
            private _connectRoad1 = _currentConnectionNames#1;
            private _connectStruct0 = [_registerNS,str _connectRoad0] call _fnc_getStruct;
            private _connectStruct1 = [_registerNS,str _connectRoad1] call _fnc_getStruct;
            private _currentRoad = _currentStruct#0;

            if !([_connectStruct0,_connectRoad1] call _fnc_isRoadConnected) then {  // If our neighbours are not already connected:
                [_connectStruct0,_currentRoad,_connectRoad1] call _fnc_replaceRoadConnection;       // We connect our two neighbors together, replacing our own connection
                [_connectStruct1,_currentRoad,_connectRoad0] call _fnc_replaceRoadConnection;
            };
            _orphanedIndices pushBack _forEachIndex;
        };
    } forEach _currentNavGrid;
    deleteLocation _registerNS;

    _diag_step_sub = "Cleaning orphans...";
    call _fnc_diag_render;
    [_currentNavGrid,_orphanedIndices] call remIndices;


} forEach _simpleNavGrids;

_simpleNavGrids;
