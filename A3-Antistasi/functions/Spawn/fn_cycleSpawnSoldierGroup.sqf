params ["_side", "_marker", "_cargoArray", "_groupIndex", "_isOver"];

private _soldierCount = {_x != ""} count _cargoArray;

if(_soldierCount == 0) exitWith
{
    grpNull;
};

private _soldierGroup = createGroup _side;

private _spawnParameter = [_marker, _soldierCount, objNull] call A3A_fnc_createSpawnPlacementForGroup;

{
    if(_x != "") then
    {
        [_marker, _x, _groupIndex, _soldierGroup, _spawnParameter select _forEachIndex, _isOver] call A3A_fnc_cycleSpawnUnit;
        sleep 0.25;
    };
} forEach (_cargoArray select {_x != ""});

_soldierGroup;
