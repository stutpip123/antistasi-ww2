/*
Maintainer: Caleb Serafin
    Removes a _roadStruct reference from navRegions

Arguments:
    <ARRAY<             navGrid:
        <OBJECT>            Road
        <ARRAY<OBJECT>>         Connected roads.
        <ARRAY<SCALAR>>         True driving distance in meters to connected roads.
    >>

Return Value:
    <BOOLEAN> true if deleted, false if not found.

Scope: Any, Global Arguments
Environment: Unscheduled
Public: Yes

Example:
    private _navGrid = [_navIslands] call A3A_fnc_NG_convert_navIslands_navGrid;
*/
params [
    ["_navRegions",locationNull,[ locationNull ]],
    ["_roadStruct",[],[ [] ]]
];

private _pos = getPos (_roadStruct#0);
private _region = str [floor (_pos#0 / 100),floor (_pos#1 / 100)];
private _items = _navRegions getVariable [_region,[]];
private _index = _items find [_pos,_roadStruct];
_items deleteAt _index;     // No need to set after deletion.

_index != -1;
