params [
    ["_navGrid",[],[ [] ]]  // ARRAY<ARRAY<segmentStruct>>
];

private _navGridNS = [false] call A3A_fnc_createNamespace;
{
    _navGridNS setVariable [str (_x#0),_x];
} forEach _navGrid; // _x is road struct <road,ARRAY<connections>,ARRAY<indices>>


private _fnc_connectStructAndRoad = {
    params ["_myStruct","_otherRoad"];
    private _myRoad = _myStruct#0;
    private _distance = _myRoad distance2D _otherRoad;

    private _otherStruct = _navGridNS getVariable [str _otherRoad,nil];     // Original value is modified by reference

    _myStruct#1 pushBack _otherRoad;    // Original value is modified by reference
    _myStruct#2 pushBack _distance;

    _otherStruct#1 pushBack _myRoad;
    _otherStruct#2 pushBack _distance;
};

private _const_searchSteps = [10,20,30,40];
private _fnc_searchAzimuth = {
    params ["_road","_azimuth"];

    private _testRoad = objNull;
    private _finalRoad = objNull;
    private _mytPos = getPos _road;
    {
        _testRoad = roadAt (_mytPos getPos [_x,_azimuth]);
        if !(_testRoad isEqualTo _road || {isNil {_navGridNS getVariable [str _testRoad,nil]}}) exitWith {_finalRoad = _testRoad};
    } forEach _const_searchSteps;
    _finalRoad;
};

private _const_emptyArray = [];
private _isolatedStructs = _navGrid select {count (_x#1) < 2};
private _deadEndStructs = [];
{
    if (_x#1 isEqualTo _const_emptyArray) then {
        private _road = _x#0;
        private _roadInfo = getRoadInfo _road;
        private _azimuth = (_roadInfo#6) getDir (_roadInfo#7);

        private _missingRoad = [_road,_azimuth] call _fnc_searchAzimuth;
        if (!isNull _missingRoad) then {
            [_x,_missingRoad] call _fnc_connectStructAndRoad;
        };

        _azimuth = (_azimuth + 180) mod 360;
        _missingRoad = [_road,_azimuth] call _fnc_searchAzimuth;
        if (!isNull _missingRoad) then {
            [_x,_missingRoad] call _fnc_connectStructAndRoad;
        };
    } else {   // Push to dead ends if no-longer isolated
        _deadEndStructs pushBack _x;
    };
} forEach _isolatedStructs;

{
    if (count (_x#1) == 1) then {   // Skip if no-longer a dead end.
        private _road = _x#0;
        private _missingRoad = [_road,(_x#1#0) getDir (_road)] call _fnc_searchAzimuth;
        if (!isNull _missingRoad) then {
            [_x,_missingRoad] call _fnc_connectStructAndRoad;
        };
    };
} forEach _deadEndStructs;

private _navGridFixed = allVariables _navGridNS apply {_navGridNS getVariable [_x,nil]};
deleteLocation _navGridNS;
_navGridFixed;
