params [
    ["_navGrids",[],[ [] ]] //<ARRAY< island ARRAY<Road,connections ARRAY<Road>>  >>
];
private _markers = [localNamespace,"A3A_NGPP","draw","LinesBetweenRoads",[]] call Col_fnc_nestLoc_get;
{
    deleteMarker _x;
} forEach _markers;
_markers resize 0;  // Preserves reference
private _roadColourClassification = [["MAIN ROAD", "ROAD", "TRACK"],["ColorGreen","ColorYellow","ColorOrange"]];

{
    private _roadsAndConnections = [false] call A3A_fnc_createNamespace;
    {
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

                _markers pushBack ([_myRoad,_myName,_otherRoad,_otherName,_roadColourClassification] call A3A_fnc_NG_draw_lineBetweenTwoRoads);
            };

        } forEach (_x#1); // connections ARRAY<Road>  // _x is Road
    } forEach _x;   // island ARRAY<Road,connections ARRAY<Road>>  // _x is <Road,connections ARRAY<Road>>
    deleteLocation _roadsAndConnections;
} forEach _navGrids; //<ARRAY< island ARRAY<Road,connections ARRAY<Road>>  >>// _x is <island ARRAY<Road,connections ARRAY<Road>>>

[localNamespace,"A3A_NGPP","draw","LinesBetweenRoads",_markers] call Col_fnc_nestLoc_set;