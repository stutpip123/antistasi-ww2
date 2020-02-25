params ["_type", "_marker"];

/*  Update the patrols on a marker
*   Params:
*       _type: STRING : The type of the marker
*       _marker: STRING : The name of the marker, which needs updating
*
*   Returns:
*       Nothing
*/

private _side = sidesX getVariable _marker;
private _patrols = garrison getVariable [format ["%1_patrols", _marker], []];
private _patrolTypes = garrison getVariable (format ["%1_patrolPref", _type]);
for "_i" from (count _patrols) to ((count _patrolTypes) - 1) do
{
    private _type = _patrolTypes select _i;
    _patrols pushBack ([_type, _side] call A3A_fnc_createPatrolArray);
};
[3, format ["Updated patrols for %1, patrols are %2", _marker, _patrols], "updatePatrols", true] call A3A_fnc_log;
garrison setVariable [format ["%1_patrols", _marker], _patrols, true];
