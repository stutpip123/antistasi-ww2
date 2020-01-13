params ["_line", "_marker", "_preference", ["_losses", [0,0,0]]];

//params ["_line", "_garrison", "_requested", "_preference", "_losses", "_currentPlaces", "_availablePlaces", "_locked"];

/*  Add a line to the garrison based on its ability to hold this specific line
*   Params:
*       _line : ARRAY : The line of units to add to the garrison
*       _marker : STRING : The name of the marker
*       _preference : ARRAY : The line of preferred units ["vehicle", -1 , "group"]
*       _losses : ARRAY of NUMBERS : Determines it the unit line should be reinforced
*
*   Returns:
*       Nothing
*/

private _currentPlaces = [spawner, format ["%1_current", _marker]] call A3A_fnc_getServerVariable;
private _availablePlaces = [spawner, format ["%1_available", _marker]] call A3A_fnc_getServerVariable;

private _garrison = [garrison, format ["%1_garrison", _marker]] call A3A_fnc_getServerVariable;
private _requested = [garrison, format ["%1_requested", _marker]] call A3A_fnc_getServerVariable;
private _locked = [garrison, format ["%1_locked", _marker]] call A3A_fnc_getServerVariable;

//Check if the line should be a reinforcements line
private _start = (_preference select 0) select [0,3];
private _index = ["LAN", "HEL", "AIR"] findIf {_x == _start};
private _isReinf = !(_index == -1 || {(_losses select _index) <= 0});

//Check if the line is placable at the given marker
private _canPlace = [_line, _start, _currentPlaces, _availablePlaces] call A3A_fnc_canPlaceLine;
//Look line for spawner if vehicle cannot be placed (means only cargo units spawn, neither crew nor vehicle)
_locked pushBack (!_canPlace);

//Creates arrays with "" to avoid resize operations
private _emptyCrew = [];
{
    _emptyCrew pushBack "";
} forEach (_line select 1);

private _emptyCargo = [];
{
    _emptyCargo pushBack "";
} forEach (_line select 2);

switch (true) do
{
    case (_canPlace && _isReinf):
    {
        //Vehicle can be placed, but is marked as reinforcement
        _losses set [_index, (_losses select _index) - 1];
        _garrison pushBack ["", _emptyCrew, _emptyCargo];
        _requested pushBack _line;
    };
    case (!_canPlace && _isReinf):
    {
        //Can't place the vehicle, therefor it shouldn't be reinforced
        _losses set [_index, (_losses select _index) - 1];
        //Emulate crew and vehicle is there, but as spawner does not spawn them we are good
        _garrison pushBack [_line select 0, _line select 1, _emptyCargo];
        _requested pushBack ["", _emptyCrew, _line select 2];
    };
    case (!_canPlace && !_isReinf);
    case (_canPlace && !_isReinf):
    {
        //Vehicle can/can't be placed and should be there
        _garrison pushBack _line;
        _requested pushBack ["", _emptyCrew, _emptyCargo];
    };
};
