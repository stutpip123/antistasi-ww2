params ["_marker"];

private _fnc_addToArray =
{
    params ["_array", "_unit"];
    private _index = _array findIf {(_x select 0) == _unit};
    if(_index == -1) then
    {
        _array pushBack [_unit, 1];
    }
    else
    {
        private _element = _array select _index;
        _element set [1, (_element select 1) + 1];
    };
};

private _garrison = [_marker] call A3A_fnc_getGarrison;
private _over = [_marker] call A3A_fnc_getOver;

private _unitCount = 0;
private _vehicleCount = 0;
private _unitTypes = [];
private _vehicleTypes = [];
{
    private _data = _x;
    private _displayName = "";
    _data params ["_vehicle", "_crew", "_cargo"];
    if(_vehicle != "") then
    {
        _vehicleCount = _vehicleCount + 1;
        _displayName = (configFile >> "CfgVehicles" >> _vehicle >> "displayName") call BIS_fnc_getCfgData;
        [_vehicleTypes, _displayName] call _fnc_addToArray;
    };
    {
        if(_x != "") then
        {
            _unitCount = _unitCount + 1;
            _displayName = (configFile >> "CfgVehicles" >> _x >> "displayName") call BIS_fnc_getCfgData;
            [_unitTypes, _displayName] call _fnc_addToArray;
        };
    } forEach (_crew + _cargo);
} forEach (_garrison + _over);

_text = format ["\n\nGarrisoned assets: %1\n\nVehicles: %2\n", (_unitCount + _vehicleCount), _vehicleCount];

{
    _x params ["_name", "_amount"];
    _text = format ["%3%1x %2\n", _amount, _name, _text];
} forEach _vehicleTypes;

_text = format ["%2\nUnits: %1\n", _unitCount, _text];

{
    _x params ["_name", "_amount"];
    _text = format ["%3%1x %2\n", _amount, _name, _text];
} forEach _unitTypes;

_text;
