/*
Maintainer: Caleb Serafin
    Converts navIslands to navGrid (The internal format).
    navGrid is not divided into island s.

Arguments:
    <ARRAY<             navIslands:
        <ARRAY<             A single road network island:
            <OBJECT>            Road
            <ARRAY<OBJECT>>         Connected roads.
            <ARRAY<SCALAR>>         True driving distance in meters to connected roads.
        >>
    >>

Return Value:
    <ARRAY<             navGrid:
        <OBJECT>            Road
        <ARRAY<OBJECT>>         Connected roads.
        <ARRAY<SCALAR>>         True driving distance in meters to connected roads.
    >>

Scope: Any, Global Arguments
Environment: Unscheduled
Public: Yes

Example:
    private _navGrid = [_navIslands] call A3A_fnc_NG_mergeIslands;
*/
params [
    ["_navIslands",[],[ [] ]]
];
private _navGrid = [];
{ _navGrid append _x } forEach _navIslands;
_navGrid;
