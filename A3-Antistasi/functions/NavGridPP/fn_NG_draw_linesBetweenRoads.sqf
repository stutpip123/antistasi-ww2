params [
    ["_navGrids",[],[ [] ]] //<ARRAY< island ARRAY<Road,connections ARRAY<Road>>  >>
];

private _diag_step_main = "";
private _diag_step_sub = "";


private _fnc_diag_render = { // call _fnc_diag_render;
    [
        "Nav Grid++",
        "<t align='left'>" +
        "Drawing lines between roads<br/>"+
        _diag_step_main+"<br/>"+
        _diag_step_sub+"<br/>"+
        "</t>"
    ] remoteExec ["A3A_fnc_customHint",0];
};

_diag_step_main = "Deleting Old Markers";
call _fnc_diag_render;
private _markers = [localNamespace,"A3A_NGPP","draw","LinesBetweenRoads",[]] call Col_fnc_nestLoc_get;
{
    deleteMarker _x;
} forEach _markers;
_markers resize 0;  // Preserves reference
private _roadColourClassification = [["MAIN ROAD", "ROAD", "TRACK"],["ColorGreen","ColorYellow","ColorOrange"]];

{

    _diag_step_main = "Drawing Lines on island &lt;" + str _forEachIndex + " / " + str count _navGrids + "&gt;";
    call _fnc_diag_render;
    private _diag_sub_counter = -1;
    private _segments = _x;
    _diag_totalSegments = count _segments;

    private _roadsAndConnections = [false] call A3A_fnc_createNamespace;
    {
        _diag_sub_counter = _diag_sub_counter +1;
        if (_diag_sub_counter mod 100 == 0) then {
            _diag_step_sub = "Completion &lt;" + ((100*_forEachIndex /_diag_totalSegments) toFixed 1) + "% &gt; Processing segment &lt;" + (str _forEachIndex) + " / " + (str _diag_totalSegments) + "&gt;";
            call _fnc_diag_render;
        };

        private _myRoad = _x#0;
        private _myName = str _myRoad;
        {
            private _otherRoad = _x;
            private _otherName = str _otherRoad;
            private _myConnections = _roadsAndConnections getVariable [_myName,[]];
            if !(_otherName in _myConnections) then {
                _myConnections pushBack _otherName;
                _roadsAndConnections setVariable [_myName,_myConnections];

                private _otherConnections = _roadsAndConnections getVariable [_otherName,[]];
                _otherConnections pushBack _myName;
                _roadsAndConnections setVariable [_myName,_otherConnections];
                private _realDistance = (str (_myRoad#2 #_forEachIndex)) + "m";

                _markers pushBack ([_myRoad,_myName,_otherRoad,_otherName,_roadColourClassification,_realDistance] call A3A_fnc_NG_draw_lineBetweenTwoRoads);
            };

        } forEach (_x#1); // connections ARRAY<Road>  // _x is Road
    } forEach _segments;   // island ARRAY<Road,connections ARRAY<Road>>  // _x is <Road,connections ARRAY<Road>>
    deleteLocation _roadsAndConnections;
} forEach _navGrids; //<ARRAY< island ARRAY<Road,connections ARRAY<Road>>  >>// _x is <island ARRAY<Road,connections ARRAY<Road>>>

[localNamespace,"A3A_NGPP","draw","LinesBetweenRoads",_markers] call Col_fnc_nestLoc_set;