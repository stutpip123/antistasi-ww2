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

private _overUnits = [_marker] call A3A_fnc_getOver;

private _vehicleIndex = -1;
private _crewIndex = -1;
private _cargoIndex = -1;

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
                _overUnits pushBack ["", [_x, ""], [""]];
                _overCount = _overCount + 1;
                _crewIndex = _overCount - 1;
                if(_vehicleIndex == -1) then {_vehicleIndex = _crewIndex;};
                if(_cargoIndex == -1) then {_cargoIndex = _crewIndex;};
            }
            else
            {
                //Space available, add unit here
                private _subIndex = ((_overUnits select _crewIndex) select 1) find "";
                ((_overUnits select _crewIndex) select 1) set [_subIndex, _x];
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
                _overUnits pushBack ["", [""], [_x, ""]];
                _overCount = _overCount + 1;
                _cargoIndex = _overCount - 1;
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
                ((_overUnits select _cargoIndex) select 2) set [_subIndex, _x];
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
        private _crewSeatCount = [_x, false] call BIS_fnc_crewCount;
        private _crewArray = [];
        if(_vehicleIndex == -1) then
        {
            for "_i" from 1 to _crewSeatCount do
            {
                _crewArray pushBack "";
            };
            _overUnits pushBack [_x, _crewArray, [""]];
            _overCount = _overCount + 1;
            if(_cargoIndex == -1) then {_cargoIndex = _overCount - 1;};
            if(_crewIndex == -1) then {_crewIndex = _overCount - 1;};
        }
        else
        {
            (_overUnits select _vehicleIndex) set [0, _x];
            _crewArray = _overUnits select _vehicleIndex;
            for "_i" from (count _crewArray) to _crewSeatCount do
            {
                _crewArray pushBack "";
            };
            _vehicleIndex = _overUnits findIf {(_x select 0) == ""};
        };
    };
} forEach _units;

garrison setVariable [format ["%1_over", _marker], _overUnits, true];
