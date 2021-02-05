params [
    ["_navGrid_IN",[],[ [] ]] //ARRAY<  Road, ARRAY<connectedRoad>>, ARRAY<distance>  >
];
private _navGrid = +_navGrid_IN;

private _roadIndexNS = [localNamespace,"NavGridPP","simplify_junc_roadIndex", nil, nil] call Col_fnc_nestLoc_set;
{
    _roadIndexNS setVariable [str (_x#0),_forEachIndex];
} forEach _navGrid; // _x is road struct <road,ARRAY<connections>,ARRAY<indices>>

private _const_emptyArray = [];
{
    private _myStruct = _x;
    private _myRoad = _myStruct#0;
    private _myConnections = _myStruct#1;

    if !(_myConnections isEqualTo _const_emptyArray) then {
        {
            private _otherStruct = _navGrid#(_roadIndexNS getVariable [str _x,-1]);
            if !(_myRoad in (_otherStruct#1)) then {
                _otherStruct#1 pushBack _myRoad;
                _otherStruct#2 pushBack (_myRoad distance2D _x);
            };
        } forEach _myConnections;
    };
} forEach _navGrid;
[_roadIndexNS] call Col_fnc_nestLoc_rem;

_navGrid;
