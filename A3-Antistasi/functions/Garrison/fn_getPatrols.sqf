params ["_marker"];

/*  Returns the patrol data of a marker in the format it is needed
*   Params:
*     _marker: STRING : The name of the marker to get the patrol data from
*
*   Returns:
*     _result: ARRAY : The patrol data in the correct format
*/

private _result = [];
_result = garrison getVariable [format ["%1_patrols", _marker], []];

_result;
