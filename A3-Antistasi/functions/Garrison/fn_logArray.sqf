params ["_array", ["_arrayName", "array"]];

/*  Logs a given array to the rpt
*   Params:
*     _array : ARRAY : The array, which will be logged
*     _arrayName : STRING : The name of the array for identifying the array (default array)
*
*   Returns:
*     Nothing
*/
//Array logging is expensive, only in debug mode
if(LogLevel != 3) exitWith {};
private _fileName = "fn_logArray";

[3, format ["Logging %1:", _arrayName], _fileName] call A3A_fnc_log;
for "_i" from 0 to ((count _array) - 1) do
{
  [3, format ["  %1, element %2: %3", _arrayName, _i, str (_array select _i)], _fileName] call A3A_fnc_log;
};
