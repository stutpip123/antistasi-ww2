private _pos = _this#0;
private _name = _this#1;

private _road = roadAt _pos;
if !(isNull _road) exitWith {
    _road;
};

private _roadObjects = nearestTerrainObjects [_pos, ["ROAD", "MAIN ROAD", "TRACK"], 10, false, true];
private _index = _roadObjects findIf {str _x isEqualTo _name};
if (_index != -1) exitWith {
    _roadObjects#_index;
};

[1,"Could not round-trip position of road "+_name+" at " + str _pos + ".","fn_NG_DB_roadAtStruct"] call A3A_fnc_log;
objNull;
