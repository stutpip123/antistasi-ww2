params [
    ["_navGrid",[],[ [] ]] //ARRAY<  Road, ARRAY<connectedRoad>>, ARRAY<distance>  >
];
{
    private _myStruct = _x;
    private _myConnections = _myStruct#1;
    private _myDistances = _myStruct#2;

    if (count _myConnections > 1) then {
        private _uniqueRoads = [];
        {
            _uniqueRoads pushBackUnique _x
        } forEach _myConnections;

        if (count _myConnections isEqualTo count _uniqueRoads) exitWith {};

        _uniqueDistances = [];
        {
            _uniqueDistances pushBack (_myDistances #(_myConnections find _x) );
        } forEach _uniqueRoads;

        _myConnections resize 0;
        _myDistances resize 0;
        { _myConnections pushBack _x; } forEach _uniqueRoads;
        { _myDistances pushBack _x; } forEach _uniqueDistances;
    };
} forEach _navGrid;
_navGrid;
