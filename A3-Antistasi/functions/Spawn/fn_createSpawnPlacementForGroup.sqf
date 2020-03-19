params ["_marker", "_unitCount", ["_vehicle", objNull]];

if((_marker in controlsX) || (_marker in outpostsFIA) || {!(isNull _vehicle) && {[_vehicle] call A3A_fnc_isCombatVehicle && {(random 100) < (7.5 * tierWar)}}}) exitWith
{
    _vehicle lock 0;
    [-1, "NONE"];
};

_fn_createLinePosition =
{
    params ["_startPos", "_dir", "_units"];

    private _result = [[_startPos, _dir]];
    private _subCounter = 0;
    private _distance = 3;
    private _position = [];
    for "_i" from 2 to _units do
    {
        _subCounter = _subCounter + 1;
        if(_subCounter > 3) then
        {
            _distance = _distance + 1;
            _subCounter = 1;
        };
        if(_subCounter == 1) then
        {
            _position = [_startPos, _distance, _dir] call BIS_fnc_relPos;
            _result pushBack [_position, _dir - 180];
        };
        if(_subCounter == 2) then
        {
            _position = [_startPos, _distance, _dir] call BIS_fnc_relPos;
            _position = [_position, 1, _dir + 90] call BIS_fnc_relPos;
            _result pushBack [_position, _dir - 180];
        };
        if(_subCounter == 3) then
        {
            _position = [_startPos, _distance, _dir] call BIS_fnc_relPos;
            _position = [_position, 1, _dir - 90] call BIS_fnc_relPos;
            _result pushBack [_position, _dir - 180];
        };
    };

    _result;
};

private _animType = "NONE";
private _placements = [];
if(_unitCount < 3) then
{
    if(isNull _vehicle) then
    {
        //Not searching for a special place for small groups
        private _startParams = [_marker, "Vehicle"] call A3A_fnc_findSpawnPosition;
        if(_startParams isEqualType -1) then
        {
            _placements = -1;
        }
        else
        {
            _placements = [_startParams select 0, _startParams select 1, _unitCount] call _fn_createLinePosition;
            _animType = "IDLE";
        };
    }
    else
    {
        private _vehicleDir = getDir _vehicle;
        private _startPos = [getPos _vehicle, 4, _vehicleDir - 30] call BIS_fnc_relPos;
        _placements = [_startPos, _vehicleDir + 90, _unitCount] call _fn_createLinePosition;
        _animType = "VEHICLE";
    };
}
else
{
    private _building = objNull;
    private _distance = -1;
    if !(isNull _vehicle) then
    {
        _distance = 150 - (50 * floor (tierWar/3));
    };
    if(_unitCount <= 4) then
    {
        _building = [_marker, "Group", _distance] call A3A_fnc_findSpawnPosition;
    }
    else
    {
        _building = [_marker, "Squad", _distance] call A3A_fnc_findSpawnPosition;
    };
    if(_building isEqualType -1) then
    {
        //No building found, try placing them in a vehicle slot
        private _startParams = [_marker, "Vehicle", _distance] call A3A_fnc_findSpawnPosition;
        if(_startParams isEqualType -1) then
        {
            _placements = -1;
        }
        else
        {
            _placements = [_startParams select 0, _startParams select 1, _unitCount] call _fn_createLinePosition;
            _animType = "BRIEFING";
        };
    }
    else
    {
        //Building found
        _building = _building select 0;
        private _buildingPos = _building buildingPos -1;
        _buildingPos = _buildingPos select {[_x] call A3A_fnc_isBuildingPosValid};
        [3, format ["Got a building with %1 free positions for a %2 units", count _buildingPos, _unitCount], "createSpawnPlacementForGroup", true] call A3A_fnc_log;
        private _selected = [];
        for "_i" from 1 to _unitCount do
        {
            _selected = selectRandom _buildingPos;
            _placements pushBack [[_selected] call A3A_fnc_getRealBuildingPos, random 360];
            _buildingPos = _buildingPos - [_selected];
        };
        _animType = "IDLE";
    };
};

private _result = [_placements, _animType];
_result;
