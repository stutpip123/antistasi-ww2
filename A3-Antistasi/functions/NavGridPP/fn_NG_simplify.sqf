params [
    ["_navGrids",[],[ [] ]] //<ARRAY< island ARRAY<Road,connections ARRAY<Road>>  >>
];

private _navGridsSimple = +_navGrids;

{
    private _navGridSimple = _x;

    private _currentRoadIndex = -1;
    while {_currentRoadIndex < count _navGridSimple} do {
        _currentRoadIndex = _currentRoadIndex + 1;
        private _currentRoadStruct = _navGridSimple # _currentRoadIndex;
        private _currentRoad = _currentRoadStruct#0;
        private _currentRoadConnections = _currentRoadStruct#1;
        if (count _currentRoadConnections == 2) then {

        } else {

        }
    };

} forEach _navGridsSimple;

