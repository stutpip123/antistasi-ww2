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
while {isNil { garrison getVariable (format ["%1_preference", _type])}} do {sleep 1;};
private _preferred = garrison getVariable (format ["%1_preference", _type]);

{
    //Creates the data for the marker and saves it to be used later
    private _garrison = [];
    private _requested = [];
    private _locked = [];
    private _marker = _x;
    private _losses = +_lose;

    [3, format ["Creating %1 now", _marker], _fileName] call A3A_fnc_log;

    garrison setVariable [format ["%1_garrison", _marker], _garrison, true];
    garrison setVariable [format ["%1_requested", _marker], _requested, true];
    garrison setVariable [format ["%1_locked", _marker], _locked, true];

    while {isNil {sidesX getVariable _marker}} do {sleep 1;};
    private _side = sidesX getVariable _marker;
    for "_i" from 0 to ((count _preferred) - 1) do
    {
        //Creates a line of units
        private _line = [_preferred select _i, _side] call A3A_fnc_createGarrisonLine;
        [3, "Line prepared, setting it now!", _fileName] call A3A_fnc_log;
        //Adds the line to the garrison data
        [_line, _marker, _preferred select _i, _losses] call A3A_fnc_addGarrisonLine;
    };

    //Logs the data if the server is on debug level
    [3, format ["Garrison on %1 is now set", _marker], _fileName] call A3A_fnc_log;
    [_garrison, format ["%1_garrison", _marker]] call A3A_fnc_logArray;

    //Updates the marker status if it is able to send reinforcements or needs some
    [_marker] call A3A_fnc_updateReinfState;
} forEach _markerArray;
