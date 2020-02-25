params ["_type", "_marker"];

/*  Update the patrols on a marker
*   Params:
*       _type: STRING : The type of the marker
*       _marker: STRING : The name of the marker, which needs updating
*
*   Returns:
*       Nothing
*/

private _patrols = garrison getVariable [format ["%1_patrols", _marker], []];
private _patrolTypes = garrison getVariable (format ["%1_patrolPref", _type]);
for "_i" from (count _patrols) from ((count _patrolTypes) - 1) do
{
    private _type = _patrolTypes select _i;
    _patrols pushBack ([_type, _side] call A3A_fnc_createPatrolArray);
};
garrison setVariable [format ["%1_patrols", _marker], _patrols, true];
