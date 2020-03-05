params ["_marker", "_unitCount", ["_vehicle", objNull]];

if(!(isNull _vehicle) && {(random 100) < (7.5 * tierWar)}) exitWith
{
    _vehicle lock 0;
    -1;
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

_fn_getRandomPosition =
{
    params ["_marker"];

    private _distance = 10 + (40 - 4 * tierWar);
    private _result = [getMarkerPos _marker, _distance, random 360] call BIS_fnc_relPos;

    _result;
};


private _placements = [];
if(_unitCount < 3) then
{
    //Not searching for a special place for small groups
    private _startPos = [_marker] call _fn_getRandomPosition;
    _placements = [_startPos, random 360, _unitCount] call _fn_createLinePosition;
}
else
{
    private _building = objNull;
    if(_unitCount <= 4) then
    {
        _building = [_marker, "Group"] call A3A_fnc_findSpawnPosition;
    }
    else
    {
        _building = [_marker, "Squad"] call A3A_fnc_findSpawnPosition;
    };
    if(_building isEqualType -1) then
    {
        //No suitable building found, find place in the open
        private _startPos = [_marker] call _fn_getRandomPosition;
        _placements = [_startPos, random 360, _unitCount] call _fn_createLinePosition;
    }
    else
    {
        //Building found
        _building = _building select 0;
        private _buildingPos = _building buildingPos -1;
        private _selected = [];
        for "_i" from 1 to _unitCount do
        {
            _selected = selectRandom _buildingPos;
            _placements pushBack [_selected, random 360];
            _buildingPos = _buildingPos - [_selected];
        };
    };
};

_placements;
