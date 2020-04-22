params ["_marker", "_winner"];

/*  Clears the garrison data on captured markers and creates new one if needed
*   Params:
*       _marker : STRING : The name of the marker which should be cleared
*
*   Returns:
*       Nothing
*/

private _fileName = "clearGarrison";
[
    2,
    format ["Clearing marker %1 now", _marker],
    _fileName
] call A3A_fnc_log;

//Deleting all the data on the marker
garrison setVariable [format ["%1_garrison", _marker], [], true];
garrison setVariable [format ["%1_over", _marker], [], true];
garrison setVariable [format ["%1_requested", _marker], [], true];
garrison setVariable [format ["%1_statics", _marker], [], true];
garrison setVariable [format ["%1_patrols", _marker], [], true];

if(_winner != teamPlayer) then
{
    if !(_marker in controlsX) then
    {

        private _type = "Other";
        switch (true) do
        {
            case (_marker in airportsX): {_type = "Airport"};
            case (_marker in outposts): {_type = "Outpost"};
            case (_marker in citiesX): {_type = "City"};
        };

        [_type, _marker] call A3A_fnc_updateGarrison;
        [_type, _marker] call A3A_fnc_updatePatrols;
        [_type, _marker] call A3A_fnc_updateStatics;

        private _soldiers = allUnits select
        {
            (alive _x) &&
            {(isNull objectParent _x) &&
            {(side group _x == _winner) &&
            {((getPos _x) inArea _marker)}}}
        };
        _soldiers = _soldiers apply {typeOf _x};
        _soldiers = ["", [], _soldiers];
        [_marker, [_soldiers], _winner] call A3A_fnc_addToGarrison;
    };
}
else
{
    //Transfer all statics to the players
    private _playerStatics = [];
    {
        if(alive _x && {_x isKindOf "StaticWeapon" && {_x getVariable ["UnitMarker", ""] == _marker}}) then
        {
            _playerStatics pushBack [[getPosATL _x, getDir _x, typeOf _x], -1];
        };
    } forEach vehicles;
    garrison setVariable [format ["%1_statics", _marker], _playerStatics, true];
};
