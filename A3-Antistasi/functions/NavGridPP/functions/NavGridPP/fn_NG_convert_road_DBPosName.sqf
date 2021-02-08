params ["_road"];

private _const_pos2DSelect = [0,2];
private _const_posOffsetMatrix = [[-3,-3],[-3,-2],[-3,-1],[-3,0],[-3,1],[-3,2],[-3,3],[-2,-3],[-2,-2],[-2,-1],[-2,0],[-2,1],[-2,2],[-2,3],[-1,-3],[-1,-2],[-1,-1],[-1,0],[-1,1],[-1,2],[-1,3],[0,-3],[0,-2],[0,-1],[0,0],[0,1],[0,2],[0,3],[1,-3],[1,-2],[1,-1],[1,0],[1,1],[1,2],[1,3],[2,-3],[2,-2],[2,-1],[2,0],[2,1],[2,2],[2,3],[3,-3],[3,-2],[3,-1],[3,0],[3,1],[3,2],[3,3]];

private _pos = getPos _road;
private _name = 0;      // Type may change to string if name is required
if (isNull roadAt _pos) then {
    _pos = _pos select _const_pos2DSelect;
};
if (isNull roadAt _pos) then {    // Now we go all out and try a bunch of values from an offset matrix.
    {
        private _newPos = _pos vectorAdd _x select _const_pos2DSelect;  // vectorAdd puts the z back
        if (roadAt _newPos isEqualTo _road) exitWith { _pos = _newPos };   // isEqual check in case a different road was found.
    } forEach _const_posOffsetMatrix;
};
if (isNull roadAt _pos) then {
    _name = str _road;
};
[_pos,_name];
