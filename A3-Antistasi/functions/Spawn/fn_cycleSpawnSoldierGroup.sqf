params ["_side", "_marker", "_cargoArray", "_groupIndex", "_isOver"];

private _soldierCount = {_x != ""} count _cargoArray;

if(_soldierCount == 0) exitWith
{
    grpNull;
};

private _soldierGroup = createGroup _side;

private _spawnParameter = [_marker, _soldierCount, objNull] call A3A_fnc_createSpawnPlacementForGroup;

private _needsPatrol = false;
private _animType = "NONE";
if((_spawnParameter select 0) isEqualType -1) then
{
    _needsPatrol = true;
    _spawnParameter = [];
    {
        _spawnParameter pushBack [getMarkerPos _marker, 0];
    } forEach _cargoArray;
}
else
{
    _animType = _spawnParameter select 1;
    _spawnParameter = _spawnParameter select 0;
};

{
    if(_x != "") then
    {
        private _unit = [_marker, _x, _groupIndex, _soldierGroup, _spawnParameter select _forEachIndex, _isOver] call A3A_fnc_cycleSpawnUnit;
        sleep 0.25;
    };
} forEach (_cargoArray select {_x != ""});

if(_needsPatrol) then
{
    _soldierGroup setVariable ["isDisabled", false];
    {
        _x enableSimulationGlobal true;
        _x enableAI "ALL";
    } forEach (units _soldierGroup);
    [leader _soldierGroup, _marker, "SAFE", "SPAWNED", "ORIGINAL", "NOFOLLOW", "NOVEH2"] execVM "scripts\UPSMON.sqf";
}
else
{
    [_soldierGroup, _animType] call A3A_fnc_startAmbientAnims;
};

_soldierGroup;
