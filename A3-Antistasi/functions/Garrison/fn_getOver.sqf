params ["_marker"];

/*  Returns the over units of a marker in the format it is needed
*   Params:
*     _marker: STRING : The name of the marker to get the over units from
*
*   Returns:
*     _result: ARRAY : The over units in the correct format
*/

private _result = [];

if(isNil "_marker") exitWith {diag_log "GetGarrison: No marker given!";};

_result = garrison getVariable [format ["%1_over", _marker], [["", [""], [""]]]];

_result;
