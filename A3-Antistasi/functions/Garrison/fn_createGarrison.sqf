params ["_markerArray", "_type", ["_lose", [0, 0, 0]]];

/*  Creates the initial garrison for a set a marker of a specific type
*   Params:
*     _markerArray : ARRAY of MARKER : The set of marker
*     _type : STRING : The type of the marker, one of Airport, Outpost, City or Other
*     _losses : ARRAY of NUMBERS : The amount of lines that should be requested by the marker instead of already there [LAND, HELI, AIR] (default [0,0,0])
*
*   Returns:
*     Nothing
*/

private _fileName = "createGarrison";

//Gather the needed data
private _preferred = [garrison, format ["%1_preference", _type]] call A3A_fnc_getServerVariable;

private _currentPlaces = [spawner, format ["%1_current", _marker]] call A3A_fnc_getServerVariable;
private _availablePlaces = [spawner, format ["%1_available", _marker]] call A3A_fnc_getServerVariable;

{
    private _losses = +_lose;
    private _garrison = [];
    private _requested = [];
    private _marker = _x;
    private _side = [sidesX, _marker] call A3A_fnc_getServerVariable;

    for "_i" from 0 to ((count _preferred) - 1) do
    {
        private _line = [_preferred select _i, _side] call A3A_fnc_createGarrisonLine;

        private _start = ((_preferred select _i) select 0) select [0,3];
        private _index = ["LAN", "HEL", "AIR"] findIf {_x == _start};

        if(_index == -1 || {(_losses select _index) <= 0}) then
        {
            //TODO init arrays with specific size to avoid resize operations
            _garrison pushBack _line;
            _requested pushBack ["", [], []];
        }
        else
        {
            _losses set [_index, (_losses select _index) - 1];
            _garrison pushBack ["", [], []];
            _requested pushBack _line;
        };
    };

    garrison setVariable [format ["%1_garrison", _marker], _garrison, true];
    garrison setVariable [format ["%1_requested", _marker], _requested, true];

    [3, format ["Garrison on %1 is now set", _marker], _fileName] call A3A_fnc_log;
    [_garrison, format ["%1_garrison", _marker]] call A3A_fnc_logArray;

    //Updates the marker status if it is able to send reinforcements or needs some
    [_marker] call A3A_fnc_updateReinfState;
} forEach _markerArray;
