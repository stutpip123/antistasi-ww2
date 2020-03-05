params ["_side", "_marker", "_patrolGroup", "_patrolGroupIndex", "_patrolMarker"];


private _unitIndex = 0;
private _patrolUnitOne = _patrolGroup select 0;
private _patrolUnitTwo = _patrolGroup select 1;
private _group = grpNull;
if([_patrolUnitOne select 1] call A3A_fnc_unitAvailable) then
{
    _group = createGroup _side;
    _unitIndex = _patrolGroupIndex * 10;
    [_patrolUnitOne select 0, _group, _marker, _unitIndex] call A3A_fnc_cycleSpawnPatrolUnit;
};
if([_patrolUnitTwo select 1] call A3A_fnc_unitAvailable) then
{
    if(isNull _group) then
    {
        _group = createGroup _side;
    };
    _unitIndex = _patrolGroupIndex * 10 + 1;
    [_patrolUnitTwo select 0, _group, _marker, _unitIndex] call A3A_fnc_cycleSpawnPatrolUnit;
};
if !(isNull _group) then
{
    _group deleteGroupWhenEmpty true;
    [leader _group, _patrolMarker, "SAFE", "SPAWNED", "RANDOM", "NOFOLLOW", "NOVEH2"] execVM "scripts\UPSMON.sqf";
    sleep 0.25;
};

_group;
