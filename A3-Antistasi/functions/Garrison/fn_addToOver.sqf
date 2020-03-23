params ["_marker", "_units"];

/*  Adds the units to the current garrison into the over units
*   Params:
*       _marker : STRING : The name of the marker where the units are added
*       _units : ARRAY of STRINGS : The classnames of the units which will be added
*
*   Returns:
*       Nothing
*/

private _fileName = "addToOver";

[3, format ["Adding %1 to %2 now", _units, _marker], _fileName] call A3A_fnc_log;

_fn_addToList =
{
    params ["_list", "_key", "_value"];
    private _index = _list findIf {(_x select 0) == _key};
    if(_index == -1) then
    {
        _list pushBack [_key, [_value]];
    }
    else
    {
        ((_list select _index) select 1) pushBack _value;
    };
};

private _overUnits = [_marker] call A3A_fnc_getOver;

private _vehicleIndex = -1;
private _crewIndex = -1;
private _cargoIndex = -1;

private _unitsToSendBack = [];

private _insertionIndeces = [];
//Checking the overUnits for first empty spaces
_vehicleIndex = _overUnits findIf {(_x select 0) == ""};
_crewIndex = _overUnits findIf {"" in (_x select 1)};
_cargoIndex = _overUnits findIf {"" in (_x select 2)};
private _overCount = count _overUnits;

{
    private _unitName = _x;
    if(_unitName isKindOf "Man") then
    {
        if(_unitName == NATOCrew || {_unitName == CSATCrew}) then
        {
            //Check if crew space available
            if(_crewIndex == -1) then
            {
                //No space available, add new line
                _overUnits pushBack ["", [_unitName, ""], [""]];
                _overCount = _overCount + 1;
                _crewIndex = _overCount - 1;
                [_insertionIndeces, _unitName, [true, _crewIndex, 1, 0]] call _fn_addToList;
                if(_vehicleIndex == -1) then {_vehicleIndex = _crewIndex;};
                if(_cargoIndex == -1) then {_cargoIndex = _crewIndex;};
            }
            else
            {
                //Space available, add unit here
                private _subIndex = ((_overUnits select _crewIndex) select 1) find "";
                ((_overUnits select _crewIndex) select 1) set [_subIndex, _unitName];
                [_insertionIndeces, _unitName, [true, _crewIndex, 1, _subIndex]] call _fn_addToList;
                if(((_overUnits select _crewIndex) select 0) == "") then
                {
                    ((_overUnits select _crewIndex) select 1) pushBack "";
                }
                else
                {
                    //Vehicle with limited capacity, check if full
                    if(!("" in ((_overUnits select _crewIndex) select 1))) then
                    {
                        _crewIndex = _overUnits findIf {"" in (_x select 1)};
                    };
                };
            };
        }
        else
        {
            if(_cargoIndex == -1) then
            {
                //No space available, add new line
                _overUnits pushBack ["", [""], [_unitName, ""]];
                _overCount = _overCount + 1;
                _cargoIndex = _overCount - 1;
                [_insertionIndeces, _unitName, [true, _cargoIndex, 2, 0]] call _fn_addToList;
                if(_vehicleIndex == -1) then {_vehicleIndex = _cargoIndex;};
                if(_crewIndex == -1) then {_crewIndex = _cargoIndex;};
            }
            else
            {
                [
                    4,
                    format ["Line is %1", (_overUnits select _cargoIndex)],
                    _fileName
                ] call A3A_fnc_log;
                //Space available, add unit here
                private _subIndex = ((_overUnits select _cargoIndex) select 2) find "";
                ((_overUnits select _cargoIndex) select 2) set [_subIndex, _unitName];
                [_insertionIndeces, _unitName, [true, _cargoIndex, 2, _subIndex]] call _fn_addToList;
                if(count ((_overUnits select _cargoIndex) select 2) < 8) then
                {
                    ((_overUnits select _cargoIndex) select 2) pushBack "";
                }
                else
                {
                    _cargoIndex = _overUnits findIf {"" in (_x select 2)};
                };
            };
        };
    }
    else
    {
        if([_marker, _unitName] call A3A_fnc_blockVehicleSpace) then
        {
            private _crewSeatCount = [_x, false] call BIS_fnc_crewCount;
            private _crewArray = [];
            if(_vehicleIndex == -1) then
            {
                for "_i" from 1 to _crewSeatCount do
                {
                    _crewArray pushBack "";
                };
                _overUnits pushBack [_x, _crewArray, [""]];
                [_insertionIndeces, _unitName, [true, _overCount, 0]] call _fn_addToList;
                _overCount = _overCount + 1;
                if(_cargoIndex == -1) then {_cargoIndex = _overCount - 1;};
                if(_crewIndex == -1) then {_crewIndex = _overCount - 1;};
            }
            else
            {
                (_overUnits select _vehicleIndex) set [0, _unitName];
                [_insertionIndeces, _unitName, [true, _vehicleIndex, 0]] call _fn_addToList;
                _crewArray = _overUnits select _vehicleIndex select 1;
                for "_i" from (count _crewArray) to _crewSeatCount do
                {
                    _crewArray pushBack "";
                };
                _vehicleIndex = _overUnits findIf {(_x select 0) == ""};
            };
        }
        else
        {
            //No space for this vehicle, send back
            _unitsToSendBack pushBack _x;
        };
    };
} forEach _units;

garrison setVariable [format ["%1_over", _marker], _overUnits, true];

if(_marker in airportsX) then
{
    private _points = 0;
    {
        if(_x isKindOf "Man") then
        {
            _points = _points + 1;
        }
        else
        {
            _points = _points + ([_x] call A3A_fnc_getVehicleCost);
        };
    } forEach _unitsToSendBack;
    private _current = garrison getVariable [format ["%1_recruit", _marker], 0];
    garrison setVariable [format ["%1_recruit", _marker], _points + _current, true];
}
else
{
    //TODO Send units back to nearest airport
    //Will be done correctly in the convoy update
    //For now units will be added to carrier
    private _carrierMarker = if ((sidesX getVariable _marker) == Occupants) then {"NATO_carrier"} else {"CSAT_carrier"};
    private _points = 0;
    {
        if(_x isKindOf "Man") then
        {
            _points = _points + 1;
        }
        else
        {
            _points = _points + ([_x] call A3A_fnc_getVehicleCost);
        };
    } forEach _unitsToSendBack;
    private _current = garrison getVariable [format ["%1_recruit", _carrierMarker], 0];
    garrison setVariable [format ["%1_recruit", _carrierMarker], _points + _current, true];
};

_insertionIndeces;
