#define SPAWNED         0
#define ON_STANDBY      1
#define DESPAWNED       2

params ["_marker", ["_lookForStandby", false]];

/*  Checks if the given marker needs to be spawned or on standby
*   Params:
*       _marker : STRING : The name of the marker to check
*       _lookForStandby : BOOLEAN : If the code should detect standby states (optional)
*
*   Returns:
*       _result : The state which the marker should have
*/

private _fileName = "needsSpawn";

if(_marker in forcedSpawn) exitWith
{
    SPAWNED
};

private _side = sidesX getVariable [_marker, teamPlayer];
private _markerPos = getMarkerPos _marker;
private _result = DESPAWNED;
private _spawnDistance = distanceSPWN;

private _enemyOne = [];
private _enemyTwo = [];
private _friends = [];

switch (_side) do
{
    case (Occupants):
    {
        _enemyOne = playerSpawner;
        _enemyTwo = invadersSpawner;
        _friends = occupantsSpawner;
    };
    case (Invaders):
    {
        _enemyOne = playerSpawner;
        _enemyTwo = occupantsSpawner;
        _friends = invadersSpawner;
    };
    case (teamPlayer):
    {
        _enemyOne = occupantsSpawner;
        _enemyTwo = invadersSpawner;
        _friends = playerSpawner;
    };
};

{
    private _distance = _markerPos distance2D (getPos _x);
    if(_lookForStandby && {_distance < (1.3 * _spawnDistance)}) then
    {
        _result = ON_STANDBY;
    };
    if(_distance < _spawnDistance) then
    {
        _result = SPAWNED;
    };
    if(_result == SPAWNED) exitWith {};
} forEach (_enemyOne + _enemyTwo);
if(_result != SPAWNED) then
{
    {
        private _distance = _markerPos distance2D (getPos _x);
        if(_lookForStandby && {_distance < (0.8 * _spawnDistance)}) then
        {
            _result = ON_STANDBY;
        };
        if(_distance < (0.5 * _spawnDistance)) then
        {
            _result = SPAWNED;
        };
        if(_result == SPAWNED) exitWith {};
    } forEach _friends;
};

_result;
