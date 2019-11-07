private _buildings = nearestTerrainObjects [getPos player, ["House"], 20, false, false];

{
    private _building = _x;
    private _pos = getPos _building;
    private _dir = getDir _building;
    private _type = typeOf _building;
    hint format ["Type is %1", getModelInfo _building];
    hideObjectGlobal _building;
    //createVehicle [_type, _pos, [], 0, "CAN_COLLIDE"];
} forEach _buildings;
