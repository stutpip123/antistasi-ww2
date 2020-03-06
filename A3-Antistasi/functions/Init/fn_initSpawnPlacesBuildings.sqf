params ["_marker", "_distance"];

/*  Searches the marker for buildings units can spawn in

    Execution on: Server

    Scope: Internal

    Params:
        _marker: STRING : The name of the marker which will be checked
        _distance: NUMBER : The distance which should be searched

    Returns:
        _result: ARRAY : Array of building data
*/

private _nearBuildings = nearestObjects [getMarkerPos _marker, ["House"], _distance, true];

private _result = [];
private _buildingPos = [];
private _buildingSpawnPos = [];
private _countSpawnPos = 0;
{
    _buildingPos = getPos _x;
    if(_buildingPos inArea _marker) then
    {
        _buildingSpawnPos = _x buildingPos -1;
        _buildingSpawnPos = _buildingSpawnPos select {[_x] call A3A_fnc_isBuildingPosValid};
        _countSpawnPos = count _buildingSpawnPos;
        if(_countSpawnPos >= 4) then
        {
            if(_countSpawnPos >= 8) then
            {
                //Building is suited for 8 people
                _result pushBack [[_x, 8], false];
            }
            else
            {
                //Building can handle 4 units
                _result pushBack [[_x, 4], false];
            };
        };
    };
} forEach _nearBuildings;

_result;
