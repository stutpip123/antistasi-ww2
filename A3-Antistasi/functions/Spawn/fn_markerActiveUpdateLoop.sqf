#define SPAWNED         0
#define ON_STANDBY      1
#define DESPAWNED       2

/*  Checks all markers if they need to be spawned in, this is important, don't play with this !

    Execution on: Server only

    Scope: Internal

    Params:
        None

    Returns:
        Nothing
*/

if (!isServer) exitWith {};
waitUntil {!isNil "theBoss"};

[] call A3A_fnc_updateSpawnerUnits;
private _usedTime = 0;
private _timePerMarker = 1/(count markersX);
private _counter = 0;

private _deltaTime = 0;
private _allTime = 0;
private _debugCounter = 0;

while {true} do
{
    _counter = _counter + 1;
    //Update the currently active units
    if (_counter > 5) then
    {
        _counter = 0;
        [] call A3A_fnc_updateSpawnerUnits;
    };

    _deltaTime = time;
    _usedTime = time;
    {
        private _marker = _x;
        if ((spawner getVariable _marker) == DESPAWNED) then
        {
            private _markerShouldSpawn = ([_marker] call A3A_fnc_needsSpawn) == SPAWNED;
            if (_markerShouldSpawn) then
            {
                spawner setVariable [_marker, SPAWNED, true];
                if (_marker in citiesX) then
                {
                    [[_marker], "A3A_fnc_createCity"] spawn A3A_fnc_scheduler;
                }
                else
                {
                    [[_marker], "A3A_fnc_createAISite"] spawn A3A_fnc_scheduler;
                };
            };
        };
    } forEach markersX;

    if(_debugCounter < 100) then
    {
        _debugCounter = _debugCounter + 1;
        _allTime = _allTime + (time - _deltaTime);
        [2, format ["Runtime logged with %1 seconds, run %2", (time - _deltaTime), _debugCounter], "TIME DEBUG"] call A3A_fnc_log;
    }
    else
    {
        [2, format ["Average execution time was %1", (_allTime / _debugCounter)], "TIME DEBUG"] call A3A_fnc_log;
        _debugCounter = -1000;
    };

    _usedTime = abs (time - _usedTime); //abs to avoid fuckery with - values
    //Sleep only if the marker took less time than the we have time per marker (ensure stable marker check rates)
    [3, format ["Time used: %1 seconds out of 1 seconds, Will sleep: %2", _usedTime, str (_usedTime < 1)], "DEBUG_SLEEP"] call A3A_fnc_log;
    if(_usedTime < 1) then
    {
        sleep (1 - _usedTime);
    };


};
