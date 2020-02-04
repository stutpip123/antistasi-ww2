params ["_marker", ["_clearStatics", false]];

/*  Unlocks ALL locked vehicle slots of a marker
*   Params:
*       _marker : STRING : The name of the marker, which vehicle slots are freed
*       _clearStatics : BOOLEAN : Chooses if statics should be cleared too
*
*   Returns:
*       Nothing
*/

private _fileName = "freeSpawnPositions";
private _spawns = spawner getVariable [format ["%1_spawns", _marker], -1];
if(_spawns isEqualType -1) exitWith
{
    [
        1,
        format ["Marker %1 has no spawn places defined!", _marker],
        _fileName
    ] call A3A_fnc_log;
};

private _endIndex = 3;
if(_clearStatics) then
{
    _endIndex = 4;
};

for "_i" from 0 to _endIndex do
{
    private _places = _spawns select _i;
    {
        if(_x select 1) then
        {
            _x set [1, false];
        };
    } forEach _places;
};
