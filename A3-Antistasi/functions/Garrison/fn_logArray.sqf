params ["_array", ["_arrayName", "array"]];

/*  Logs a given array to the rpt
*   Params:
*     _array : ARRAY : The array, which will be logged
*     _arrayName : STRING : The name of the array for identifying the array (default array)
*
*   Returns:
*     Nothing
*/

[3, format ["Logging %1:", _arrayName], "logArray"] call A3A_fnc_log;
for "_i" from 0 to ((count _array) - 1) do
{
    [3, format ["%1, element %2: %3", _arrayName, _i, str (_array select _i)], "logArray"] call A3A_fnc_log;
};
