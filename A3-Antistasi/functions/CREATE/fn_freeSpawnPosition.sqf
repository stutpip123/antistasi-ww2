

params ["_marker", "_type", "_position"];

/*  Clears a SINGLE spawn position of the give marker
*   Params:
*       _marker : STRING : The name of the marker, which position should be freed
*       _type : NUMBER : The type of the position 0 - land, 1 - heli, 2 - plane, 3 - mortar, 4 - static
*       _position : POSITION : The position which should be cleared
*
*   Returns:
*       Nothing
*/

private _fileName = "freeSpawnPosition";

private _spawns = spawner getVariable [format ["%1_spawns", _marker], -1];
if(_spawns isEqualType -1) exitWith
{
    [
        1,
        format ["%1 does not have any spawn positions set!", _marker],
        _fileName
    ] call A3A_fnc_log;
};

private _data = _spawns select _type;
private _index = _data findIf {(_position distance2D ((_x select 0) select 0)) < 1};

if(_index == -1) exitWith
{
    [
        2,
        "Given position is not in the spawn positions!",
        _fileName
    ] call A3A_fnc_log;
};

(_data select _index) set [1, false];
