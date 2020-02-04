params ["_line", "_prefShort", "_currentPlaces", "_availablePlaces"];

/*  Checks whether the marker can have the vehicle of the line
*
*   Params:
*       _line : ARRAY : The line which should be garrisoned
*       _prefShort : STRING : The preference of the line, shortened to three letters
*       _currentPlaces : ARRAY of NUMBERS : The amount of places currently closed by other vehicles
*       _availablePlaces : ARRAY of NUMBERS : The amount of all places available for this marker
*
*   Returns:
*       _result : BOOLEAN : True if the marker can have it, false otherwise
*/

private _fileName = "canPlaceVehicleAtMarker";
private _vehicle = _line select 0;
private _index = -1;

//Calculate place index -1: unknown, 0: car, 1: helicopter, 2: plane
switch (_prefShort) do
{
    case ("LAN"):
    {
        _index = 0;
    };
    case ("HEL"):
    {
        _index = 1;
    };
    case ("AIR"):
    {
        _index = 2;
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
    _currentPlaces set [_index, (_currentPlaces select _index) + 1]
};

_result;
