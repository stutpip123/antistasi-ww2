params ["_buildings", "_marker", "_mortarMarker"];


private _statics = [];
{
    private _building = _x;
    private _buildingType = typeOf _building;
    if(_buildingType in listStaticHQ) then
    {
        //Building is a HQ and should be equipted with an AA gun
        private _pos = _building buildingPos 8;
        private _dir = getDir _building;
        _statics pushBack [[_pos, _dir, "AA"], false];
    }
    else
    {
        if(_buildingType in listStaticWatchtower) then
        {
            //Building is a watchtower and should be equipted with one MG
        }
        else
        {
            //Building is a large tower, should have two MGs on top
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
