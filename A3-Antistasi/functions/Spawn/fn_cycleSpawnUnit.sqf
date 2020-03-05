params ["_marker", "_type", "_lineIndex", "_group", "_spawnParameter", "_isOver"];

private _fileName = "cycleSpawnUnit";
[
    3,
    format ["Spawning in %1 on %2 in line %3 on position %4, is over %5", _type, _marker, _lineIndex, _spawnParameter, _isOver],
    _fileName
] call A3A_fnc_log;

private _position =_spawnParameter select 0;
private _dir = _spawnParameter select 1;

private _unit = _group createUnit [_type, _position, [], 0, "NONE"];
_unit setDir _dir;

//Should work as a local variable needs testing
if((_type != NATOCrew) && (_type != CSATCrew)) then
{
    _unit setVariable ["UnitIndex", (_lineIndex * 10 + 2)];
}
else
{
    _unit setVariable ["UnitIndex", (_lineIndex * 10 + 1)];
};
_unit setVariable ["UnitMarker", _marker];
_unit setVariable ["IsOver", _isOver];

//On unit death, remove it from garrison
_unit addEventHandler
[
    "Killed",
    {
        private _unit = _this select 0;
        private _id = _unit getVariable "UnitIndex";
        private _marker = _unit getVariable "UnitMarker";
        private _isOver = _unit getVariable "IsOver";
        if(_isOver) then
        {
            [_marker, typeOf _unit, _id] call A3A_fnc_removeFromOver;
        }
        else
        {
            [_marker, typeOf _unit, _id] call A3A_fnc_addToRequested;
        };
    }
];

if(side _group != teamPlayer) then
{
    [_unit, _marker] call A3A_fnc_NATOinit;
}
else
{
    [_unit] call A3A_fnc_FIAinit;
};

_unit disableAI "ALL";

_unit;
