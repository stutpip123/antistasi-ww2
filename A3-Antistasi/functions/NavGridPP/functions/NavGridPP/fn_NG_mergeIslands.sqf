params [
    ["_navIslands",[],[ [] ]]  // ARRAY<ARRAY<segmentStruct>>
];
private _navGrid = [];
{ _navGrid append _x } forEach _navIslands;
_navGrid;
