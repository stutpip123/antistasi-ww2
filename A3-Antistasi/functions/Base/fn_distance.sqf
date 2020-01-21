#define SPAWNED         0
#define ON_STANDBY      1
#define DESPAWNED       2

if (!isServer) exitWith {};

_fnc_checkForEnemy =
{
    params ["_array", "_markerPos" , "_distance"];
    private _index = _array findIf {((getPos _x) distance2D _markerPos) < _distance};
    private _result = (_index != -1);
    _result;
};

waitUntil {!isNil "theBoss"};

private _timeX = 1/(count markersX);
private _countX = 0;
private _greenfor = [];
private _blufor = [];
private _opfor = [];

while {true} do
{
    _countX = _countX + 1;
    //Update the currently active units
    if (_countX > 5) then
    {
        _countX = 0;
        private _spawners = allPlayers;
        _greenfor = [];
        _blufor = [];
        _opfor = [];
        {
            private _side = side (group _x);
            switch (_side) do
            {
                case (Occupants):
                {
                    _blufor pushBack _x;
                };
                case (Invaders):
                {
                    _opfor pushBack _x;
                };
                case (teamPlayer):
                {
                    _greenfor pushBack _x;
                };
            };
        } forEach _spawners;
    };

    //TODO maybe exclude markers of whom we know that they are spawned in
    {
        sleep _timeX;
        private _marker = _x;
        private _isForced = (_marker in forcedSpawn);

        private _markerShouldSpawn = [_marker, _greenfor, _blufor, _opfor] call A3A_fnc_needsSpawn;
        _markerShouldSpawn = (_markerShouldSpawn != DESPAWNED) || _isForced;

        //If marker is owned by Occupants or Invaders
        if (sidesX getVariable [_marker,sideUnknown] != teamPlayer) then
        {
            if ((spawner getVariable _marker) == DESPAWNED) then
            {
                if (_markerShouldSpawn) then
                {
                    spawner setVariable [_marker, SPAWNED, true];
                    if (_marker in citiesX) then
                    {
                        [[_marker],"A3A_fnc_createAICities"] call A3A_fnc_scheduler;
                        /*
                        if (!(_marker in destroyedSites)) then
                        {
                            [[_marker],"A3A_fnc_createCIV"] call A3A_fnc_scheduler;
                        };
                        */
                    }
                    else
                    {
                        if(!(_marker in controlsX)) then
                        {
                            [[_marker], "A3A_fnc_createAISite"] call A3A_fnc_scheduler;
                        };
                    };
                };
            };
        }
        else
        {
            if ((spawner getVariable _marker) == DESPAWNED) then
            {
                if (_markerShouldSpawn) then
                {
                    //[3, format ["%1 will be spawned in now, spawner %2!", _marker, (spawner getVariable _marker)], "distance"] call A3A_fnc_log;
                    spawner setVariable [_marker, SPAWNED, true];
                    if (_marker in citiesX) then
                    {
                        /*
                        if (!(_marker in destroyedSites)) then
                        {
                            [[_marker], "A3A_fnc_createCIV"] call A3A_fnc_scheduler;
                        };
                        */
                    };
                    if (_marker in outpostsFIA) then
                    {
                        //[[_marker],"A3A_fnc_createFIAOutposts2"] call A3A_fnc_scheduler;
                    }
                    else
                    {
                        if (!(_marker in controlsX)) then
                        {
                            [[_marker],"A3A_fnc_createSDKGarrisons"] call A3A_fnc_scheduler;
                        };
                    };
                };
            };
        };
    } forEach markersX;
};
