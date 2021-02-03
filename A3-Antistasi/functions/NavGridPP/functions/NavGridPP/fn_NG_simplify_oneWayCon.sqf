params [
    ["_navGrid",[],[ [] ]] //ARRAY<  Road, ARRAY<connectedRoad>>, ARRAY<distance>  >
];

private _roadIndexNS = [localNamespace,"NavGridPP","simplify_junc_roadIndex", nil, nil] call Col_fnc_nestLoc_set;
{
    _roadIndexNS setVariable [str (_x#0),_forEachIndex];
} forEach _navGrid; // _x is road struct <road,ARRAY<connections>,ARRAY<indices>>

private _const_emptyArray = [];
{
    private _myStruct = _x;
    private _myConnections = _myStruct#1;

    if !(_myConnections isEqualTo _const_emptyArray) then {
        private _uniqueRoads = [];
        {
            _uniqueRoads pushBackUnique _x
        } forEach _myConnections;

        if !(count _myConnections isEqualTo count _uniqueRoads) then {
            [1,"Road " + str (getPos (_myStruct#0)) + " has duplicated connections.","fn_NG_simplify_oneWayCon"] call A3A_fnc_log;
            ["fn_NG_simplify_oneWayCon Error","Please check RPT."] call A3A_fnc_customHint;
        };

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
[_roadIndexNS] call Col_fnc_nestLoc_rem;
_navGrid;
