params ["_type", "_side"];

private _result = [];
private _fileName = "createPatrolArray";

switch (_type) do
{
    case ("PATROL_NORMAL"):
    {
        if(_side == Occupants) then
        {
            _result = +groupsNATOSentry;
        }
        else
        {
            _result = +groupsCSATSentry;
        };
    };
    case ("PATROL_SNIPER"):
    {
        if(_side == Occupants) then
        {
            _result = +groupsNATOSniper;
        }
        else
        {
            _result = +groupsCSATSniper;
        };
    };
    case ("PATROL_SPECOPS"):
    {
        if(_side == Occupants) then
        {
            _result = +(groupsNATOsmall select 2);
        }
        else
        {
            _result = +(groupsCSATsmall select 2);
        };
    };
    case ("PATROL_POLICE"):
    {
        if(_side == Occupants) then
        {
            _result = +groupsNATOGen;
        }
        else
        {
            _result = +groupsCSATSentry;
        };
    };
    case ("PATROL_ATTACK"):
    {
        if(_side == Occupants) then
        {
            _result = selectRandom [+groupsNATOSniper, +(groupsNATOsmall select 1)];
        }
        else
        {
            _result = selectRandom [+groupsCSATSniper, +(groupsCSATsmall select 1)];
        };
    };
    case ("PATROL_DEFENSE"):
    {
        if(_side == Occupants) then
        {
            _result = selectRandom [+groupsNATOSentry, +groupsNATOGen];
        }
        else
        {
            _result = +groupsCSATSentry;
        };
    };
};
[
    3,
    format ["Result for input %1 is: %2", _type, _result],
    _fileName
] call A3A_fnc_log;

private _units = [];
{
    _units pushBack [_x, -1];
} forEach _result;

_units;
