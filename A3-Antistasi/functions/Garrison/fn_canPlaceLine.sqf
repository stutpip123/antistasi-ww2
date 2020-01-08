params ["_line", "_currentPlaces", "_availablePlaces"];

//WARNING I hope that passed arrays are call by reference and not by value,
//if strange errors occurs the currentPlaces are not increased correctly

/*  Checks whether the marker can have the vehicle of the line
*
*   Params:
*       _line : ARRAY : The line which should be garrisoned
*       _currentPlaces : ARRAY of NUMBERS : The amount of places currently closed by other vehicles
*       _availablePlaces : ARRAY of NUMBERS : The amount of all places available for this marker
*
*   Returns:
*       _result : BOOLEAN : True if the marker can have it, false otherwise
*/

private _fileName = "canPlaceLine";
private _vehicle = _line select 0;
private _index = -1;

//Calculate place index -1: unknown, 0: car, 1: helicopter, 2: plane
if(_vehicle == "" || {_vehicle isKindOf "Car"}) then
{
    _index = 0;
}
else
{
    if(_vehicle isKindOf "Helicopter") then
    {
        _index = 1;
    }
    else
    {
        if(_vehicle isKindOf "Plane") then
        {
            _index = 2;
        };
    };
};

if(_index == -1) exitWith
{
    //Whatever vehicle was in there, it is fine
    true;
};

//Calculate result and increase _currentPlaces if needed
_result = (_currentPlaces select _index) < (_availablePlaces select _index);
if(_result) then
{
    //If not call by reference, return that array too
    _currentPlaces set [_index, (_currentPlaces select _index) + 1]
};

[
    3,
    format ["Result for index %1 is %2, array is %3", _index, _result, _currentPlaces],
    _fileName
] call A3A_fnc_log;

_result;
