params ["_marker", "_unit", "_unitIndex"];

/*  Removes the given unit from the over units, checks if the arrays is too large for units, resizes if needed
*   Params:
*       _marker : STRING : The name of the marker the unit was garrisoned on
*       _unit : STRING : The config name of the unit
*       _unitIndex : NUMBER : The unit ID given on spawn
*
*   Returns:
*       Nothing
*/

private _unitType = _unitIndex % 10;
private _groupID = floor (_unitIndex / 10);

private _overUnits = [_marker] call A3A_fnc_getOver;

private _element = _overUnits select _groupID;
switch (_unitType) do
{
    case (0):
    {
        //Unit is a vehicle
        _element set [0, ""];
    };
    case (1):
    {
        //Unit is a crew unit, all crew units are equal
        (_element select 1) deleteAt 0;
    };
    case (2):
    {
        //Unit is a cargo unit, search for it
        private _subIndex = (_element select 2) find _unit;
        (_element select 2) deleteAt _subIndex;
    };
};

private _unitCount = [_overUnits, false] call A3A_fnc_countGarrison;
private _overCount = count _overUnits;

if
(
    ((_unitCount select 0) < (_overCount/2)) &&
    {(((_unitCount select 1)/3) < (_overCount/2)) &&
    {(((_unitCount select 2)/8) < (_overCount/2))}}
) then
{
    //Units are spreaded thin in this array, repack
    private _split = ceil (_overCount / 2);
    private _repack = [];
    //Save all units after the split index
    for "_i" from _split to (_overCount - 1) do
    {
        private _data = _overUnits select _i;
        if((_data select 0) != "") then
        {
            _repack pushBack (_data select 0);
        };
        {
            if(_x != "") then
            {
                _repack pushBack _x;
            }
        } forEach (_data select 1);
        {
            if(_x != "") then
            {
                _repack pushBack _x;
            }
        } forEach (_data select 2);
    };
    //Makes the array smaller and deletes all units above the split index
    _overUnits resize _split;
    //Readds the elements in higher density
    [_marker, _repack] call A3A_fnc_addToOver;
};

garrison setVariable [format ["%1_over", _marker], _overUnits, true];
