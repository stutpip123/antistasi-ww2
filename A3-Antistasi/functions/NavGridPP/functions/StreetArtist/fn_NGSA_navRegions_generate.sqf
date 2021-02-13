/*
Maintainer: Caleb Serafin
    Generates a region lookup table for navGrid. This allows fast fetching of nearMarkers to a map point.
    The lookup table creates references to the original navGrid.

Arguments:
    <ARRAY<             navGrid:
        <OBJECT>            Road
        <ARRAY<OBJECT>>         Connected roads.
        <ARRAY<SCALAR>>         True driving distance in meters to connected roads.
    >>

Return Value:
    <LOCATION> same _navRegions as found in localNamespace >> "NavGridPP" >> "NavRegions".
        Each var element: <<STRING>Region POS,<ARRAY< <POS2D|POSAGL>Road Pos, <ARRAY>StructReference >>

Scope: Any, Global Arguments
Environment: Unscheduled
Public: Yes

Example:
    private _navGrid = [_navIslands] call A3A_fnc_NG_convert_navIslands_navGrid;
*/
params [
    ["_navGrid",[],[ [] ]]
];

private _navRegions = [localNamespace,"NavGridPP","NavRegions",nil,nil] call Col_fnc_nestLoc_set;

{
    private _pos = getPos (_x#0);
    private _region = str [floor (_pos#0 / 100),floor (_pos#1 / 100)];
    private _items = _navRegions getVariable [_region,[]];
    _items pushBack [_pos,_x];
    _navRegions setVariable [_region,_items];
} forEach _navGrid;

