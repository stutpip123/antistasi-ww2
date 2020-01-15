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
    private _losses = +_lose;
    private _garrison = [];
    private _requested = [];
    private _locked = [];
    private _marker = _x;
    private _side = [sidesX, _marker] call A3A_fnc_getServerVariable;
    while {isNil {spawner getVariable (format ["%1_current", _marker])}} do {sleep 1;};
    private _currentPlaces = spawner getVariable (format ["%1_current", _marker]);
    while {isNil {garrison getVariable (format ["%1_available", _marker])}} do {sleep 1;};
    private _availablePlaces = spawner getVariable (format ["%1_available", _marker]);

    for "_i" from 0 to ((count _preferred) - 1) do
    {
        private _line = [_preferred select _i, _side] call A3A_fnc_createGarrisonLine;

        //Check if the line should be a reinforcements line
        private _start = ((_preferred select _i) select 0) select [0,3];
        private _index = ["LAN", "HEL", "AIR"] findIf {_x == _start};
        private _isReinf = !(_index == -1 || {(_losses select _index) <= 0});

        //Check if the line is placable at the given marker
        private _canPlace = [_line, _start, _currentPlaces, _availablePlaces] call A3A_fnc_canPlaceLine;
        //Look line for spawner if vehicle cannot be placed (means only cargo units spawn, neither crew nor vehicle)
        _locked pushBack (!_canPlace);

        switch (true) do
        {
            case (_canPlace && _isReinf):
            {
                //Vehicle can be placed, but is marked as reinforcement
                _losses set [_index, (_losses select _index) - 1];
                _garrison pushBack ["", [], []];
                _requested pushBack _line;
            };
            case (!_canPlace && _isReinf):
            {
                //Can't place the vehicle, therefor it shouldn't be reinforced
                _losses set [_index, (_losses select _index) - 1];
                //Emulate crew and vehicle is there, but as spawner does not spawn them we are good
                _garrison pushBack [_line select 0, _line select 1, []];
                _requested pushBack ["", [], _line select 2];
            };
            default
            {
                //Vehicle can/can't be placed and should be there
                _garrison pushBack _line;
                _requested pushBack ["", [], []];
            };
        };
    };

    //Saves the data
    garrison setVariable [format ["%1_garrison", _marker], _garrison, true];
    garrison setVariable [format ["%1_requested", _marker], _requested, true];
    garrison setVariable [format ["%1_locked", _marker], _locked, true];

    //Logs the data if the server is on debug level
    [3, format ["Garrison on %1 is now set", _marker], _fileName] call A3A_fnc_log;
    [_garrison, format ["%1_garrison", _marker]] call A3A_fnc_logArray;

    //Updates the marker status if it is able to send reinforcements or needs some
    [_marker] call A3A_fnc_updateReinfState;
} forEach _markerArray;
