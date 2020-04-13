params ["_marker", "_type", "_lineIndex", "_group", "_spawnParameter", "_isOver"];

private _fileName = "cycleSpawnUnit";
[
    3,
    format ["Spawning in %1 on %2 in line %3 on position %4, is over %5", _type, _marker, _lineIndex, _spawnParameter, _isOver],
    _fileName
] call A3A_fnc_log;

private _position =_spawnParameter select 0;
private _dir = _spawnParameter select 1;

private _unit = _group createUnit [_type, _position, [], 5, "NONE"];
_unit setDir _dir;
_unit setPosATL _position;

private _unitIndex = -1;
if((_type != NATOCrew) && (_type != CSATCrew)) then
{
    _unitIndex = (_lineIndex * 10 + 2);
}
else
{
    _unitIndex = (_lineIndex * 10 + 1);
};
[_unit, _marker, _isOver, _unitIndex] call A3A_fnc_markerUnitInit;

if(side _group != teamPlayer) then
{
    [_unit, _marker] call A3A_fnc_NATOinit;
}
else
{
    [_unit] call A3A_fnc_FIAinit;
};


(group _unit) setVariable ["isDisabled", true, true];
_unit disableAI "ALL";
doStop _unit;
_unit spawn
{
    sleep 5;
    if((group _this) getVariable ["isDisabled", false]) then
    {
        _this enableSimulation false;
    };
    _this doFollow (leader (group _this));
};

_unit;
