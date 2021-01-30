params [
    ["_navGridFlat",[],[ [] ]]  // ARRAY<aStruct>
];

private _navIslands = [];    // Array<island>

private _currentNames = [];    // Array<struct>
private _nextNames = [];    // Array<struct>

private _unprocessed = _navGridFlat apply {str (_x#0)};    // Array<road>
private _unprocessedNS = [false] call A3A_fnc_createNamespace;
{
    _unprocessedNS setVariable [_x,true];
} forEach _unprocessed;

private _structNS = [false] call A3A_fnc_createNamespace;
{
    _structNS setVariable [str (_x#0),_x];
} forEach _navGridFlat;

private _fnc_nameToStruct = {
    params ["_name"];
    _structNS getVariable [_name,[]];
};

private _fnc_markProcessed = {
    params ["_name"];
    _unprocessedNS setVariable [_name,false];
    _unprocessed deleteAt (_unprocessed find _name);
};

private _fnc_expandCurrent = {
    params ["_name"];
    private _struct = [_name] call _fnc_nameToStruct;
    _currentNavGrid pushBack _struct;
    private _connectedNames = (_struct#1) apply {str _x};
    _connectedNames = _connectedNames select {_unprocessedNS getVariable [_x, false]};
    { [_x] call _fnc_markProcessed } forEach _connectedNames;
    _nextNames append _connectedNames;
};

while {count _unprocessed != 0} do {
    private _currentNavGrid = [];    // Array<struct>
    private _newName =_unprocessed deleteAt 0;
    [_newName] call _fnc_markProcessed;
    _nextNames pushBack _newName;

    while {count _nextNames != 0} do {
        _currentNames = _nextNames;
        _nextNames = [];

        {
            [_x] call _fnc_expandCurrent
        } forEach _currentNames;
    };
    _navIslands pushBack _currentNavGrid;
};
deleteLocation _structNS;

_navIslands;
