params [
    ["_navGrid",[],[ [] ]] //ARRAY<  Road, ARRAY<connectedRoad>>, ARRAY<distance>  >
];

private _roadIndexNS = [localNamespace,"NavGridPP","simplify_junc_roadIndex", nil, nil] call Col_fnc_nestLoc_set;
{
    _roadIndexNS setVariable [str (_x#0),_forEachIndex];
} forEach _navGrid; // _x is road struct <road,ARRAY<connections>,ARRAY<indices>>

private _throwAndCrash = false;
private _const_emptyArray = [];
{
    private _myStruct = _x;
    private _myRoad = _myStruct#0;
    private _myConnections = _myStruct#1;

    if !(_myConnections isEqualTo _const_emptyArray) then {
        {
            private _otherStruct = _navGrid# (_roadIndexNS getVariable [str _x,-1]);
            if !(_myRoad in (_otherStruct#1)) then {
                _throwAndCrash = true;
                [1,"Road '"+str _x+"' " + str getPos _x + " has no return connection to '"+str _myRoad+"' " + str getPos _myRoad + ".","fn_NG_simplify_oneWayCon"] call A3A_fnc_log;
                ["fn_NG_simplify_oneWayCon Error","Please check RPT."] call A3A_fnc_customHint;
            };
        } forEach _myConnections;
    };
} forEach _navGrid;
[_roadIndexNS] call Col_fnc_nestLoc_rem;

if (_throwAndCrash) then {
    throw ["fn_NG_simplify_oneWayCon","Please check RPT."];
};

_navGrid;

