params [
    ["_navGrid",[],[ [] ]] //ARRAY<  Road, ARRAY<connectedRoad>>, ARRAY<distance>  >
];

private _roadIndexNS = [localNamespace,"NavGridPP","simplify_junc_roadIndex", nil, nil] call Col_fnc_nestLoc_set;
{
    _roadIndexNS setVariable [str (_x#0),_forEachIndex];
} forEach _navGrid; // _x is road struct <road,ARRAY<connections>,ARRAY<indices>>

private _fnc_CheckReturnConnection = {  // If otherRoad is connected to myRoad
    params ["_myRoad","_otherRoad"];
    private _otherstruct = _navGrid# (_roadIndexNS getVariable [str _otherRoad,-1]);
    _myRoad in (_otherstruct#1);
};

private _const_emptyArray = [];
{
    private _myStruct = _x;
    private _myRoad = _myStruct#0;
    private _myConnections = _myStruct#1;

    if !(_myConnections isEqualTo _const_emptyArray) then {
        {
            if !([_myRoad,_x] call _fnc_CheckReturnConnection) then {
                [1,"Road " + str getPos _x + " has no return connection to " + str getPos _myRoad + ".","fn_NG_simplify_oneWayCon"] call A3A_fnc_log;
                ["fn_NG_simplify_oneWayCon Error","Please check RPT."] call A3A_fnc_customHint;
            };
        } forEach _myConnections;
    };
} forEach _navGrid;
[_roadIndexNS] call Col_fnc_nestLoc_rem;
_navGrid;
