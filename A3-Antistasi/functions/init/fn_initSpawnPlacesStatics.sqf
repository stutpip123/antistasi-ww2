params ["_buildings", "_marker", "_mortarMarker"];

/*  Searches and saves the spawn positions of statics
*
*/

private _statics = [];
{
    private _building = _x;
    private _buildingType = typeOf _building;
    switch (true) do
    {
        case (_buildingType in listStaticHQ):
        {
            //Building is a HQ and should be equipted with an AA gun
            private _pos = getPos _building;
            _pos set [2, (_building buildingPos 8) select 2];
            private _dir = getDir _building;
            _statics pushBack [[_pos, _dir, "AA"], false];
        };
        case (_buildingType in listStaticWatchtower):
        {
            //Building is a watchtower and should be equipted with one MG
            private _pos = _building buildingPos 1;
            private _dir = (getDir _building) - 180;
            _pos = [_pos, 1.8, (_dir - 20)] call BIS_fnc_relPos;
            _statics pushBack [[_pos, _dir, "MG"], false];
        };
        case (_buildingType in listStaticMGNest):
        {
            //Building is a MG nest, should have one MG
            private _pos = _building buildingPos 0;
            private _dir = (getDir _building) - 180;
            _pos = [_pos, 1.5, (_dir)] call BIS_fnc_relPos;
            _statics pushBack [[_pos, _dir, "MG"], false];
        };
        case (_buildingType in listStaticCUPSpecial):
        {
            //No clue what kind of a building this is
            private _pos = _building buildingPos 1;
            private _dir = (getDir _building) - 180;
            _pos = [_pos, -1, _dir] call BIS_fnc_relPos;
            _statics pushBack [[_pos, _dir, "MG"], false];
        };
        case (_buildingType in listStaticHBarrierBunker):
        {
            //HBarrier Bunker course Laze asked for them (appearently these are the "Chad bunkers")
            private _pos = getPos _building;
            _pos = _pos vectorAdd [0, 0, 2.3];  //Set height
            _pos = _pos vectorAdd ((vectorDir _building) vectorMultiply -2); //Set forward
            private _dir = (getDir _building) - 180;
            _statics pushBack [[_pos, _dir, "MG"], false];
        };
        default
        {
            //Building is a large tower, should have two MGs on top
            private _pos = _building buildingPos 13;
            _pos = _pos vectorAdd ((vectorDir _building) vectorMultiply -1);
            private _dir = getDir _building;
            _statics pushBack [[_pos, _dir, "MG"], false];
            _pos = _building buildingPos 17;
            _pos = _pos vectorAdd ((vectorDir _building) vectorMultiply 0.1);
            _dir = _dir + 180;
            _statics pushBack [[_pos, _dir, "MG"], false];
        };
    };
} forEach _buildings;

//Handle mortar markers
private _mortars = [];
{
    private _pos = getMarkerPos _x;
    _pos set [2, ((_pos select 2) + 0.1) max 0.1];
    _mortars pushBack [[_pos, 0], false];
} forEach _mortarMarker;

_result = [_mortars, _statics];
_result;
