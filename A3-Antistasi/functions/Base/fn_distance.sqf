#define SPAWNED         0
#define ON_STANDBY      1
#define DESPAWNED       2

if (!isServer) exitWith{};

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

    //Local variables are faster than server ones
    private _distanceSpawn = distanceSPWN;
    private _distanceSpawn2 = distanceSPWN2;

    //TODO maybe exclude markers of whom we know that they are spawned in
    {
        sleep _timeX;
        private _marker = _x;

        private _positionMRK = getMarkerPos (_marker);
        private _isForced = (_marker in forcedSpawn);

        private _bluforNear = ([_blufor, _positionMRK, _distanceSpawn] call _fnc_checkForEnemy);
        private _opforNear = ([_opfor, _positionMRK, _distanceSpawn] call _fnc_checkForEnemy);
        private _greenforNear = ([_greenfor, _positionMRK, _distanceSpawn] call _fnc_checkForEnemy);

        //If marker is owned by Occupants
        if (sidesX getVariable [_marker,sideUnknown] == Occupants) then
        {
            if (spawner getVariable _marker != SPAWNED) then
            {
                if (spawner getVariable _marker == DESPAWNED) then
                {
                    if (_isForced || _opforNear || _greenforNear || _bluforNear) then
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
                            [[_marker], "A3A_fnc_createAISide"] call A3A_fnc_scheduler;
                        };
                    };
                }
                else
                {
                    //They were on standby, now activated
                    if (_greenforNear || _opforNear || _isForced || _blufor) then
                    {
                        spawner setVariable [_marker, SPAWNED, true];
                        //TODO This seems like it could be improved, investigate
                        {
                            if (_x getVariable ["markerX",""] == _marker) then
                            {
                                if (vehicle _x == _x) then
                                {
                                    _x enableSimulationGlobal true;
                                };
                            };
                        } forEach allUnits;
                    }
                    else
                    {
                        //TODO I would like to handle despawn to the marker script, this here should only handle spawns
                        if (!_isForced && {!_opforNear && {[_greenfor, _positionMRK, _distanceSpawn * 1.3] call _fnc_checkForEnemy}}) then
                        {
                            spawner setVariable [_marker, DESPAWNED, true];
                        };
                    };
                };
            }
            else
            {
                if (!(_greenforNear || {_opforNear && {_bluforNear}}) && (!_isForced)) then
                {
                    spawner setVariable [_marker, ON_STANDBY, true];
                    {
                        if (_x getVariable ["markerX",""] == _marker) then
                        {
                            if (vehicle _x == _x) then
                            {
                                _x enableSimulationGlobal false
                            };
                        };
                    } forEach allUnits;
                };
            };
        }
        else
        {
            if (sidesX getVariable [_marker,sideUnknown] == teamPlayer) then
            {
                if (spawner getVariable _marker != SPAWNED) then
                {
                    if (spawner getVariable _marker == DESPAWNED) then
                    {
                        if (_bluforNear || _opforNear || _greenforNear || _isForced) then
                        {
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
                    }
                    else
                    {
                        if (_bluforNear || _opforNear || _greenforNear || _isForced) then
                        {
                            spawner setVariable [_marker, SPAWNED,true];
                            {
                                if (_x getVariable ["markerX",""] == _marker) then
                                {
                                    if (vehicle _x == _x) then
                                    {
                                        _x enableSimulationGlobal true;
                                    };
                                };
                            } forEach allUnits;
                        }
                        else
                        {
                            if (!_bluforNear && !_opforNear && !_greenforNear && !_isForced) then
                            {
                                spawner setVariable [_marker, DESPAWNED, true];
                            };
                        };
                    };
                }
                else
                {
                    if (!(_bluforNear || _opforNear || _greenforNear || _isForced)) then
                    {
                        spawner setVariable [_marker, ON_STANDBY, true];
                        {
                            if (_x getVariable ["markerX",""] == _marker) then
                            {
                                if (vehicle _x == _x) then
                                {
                                    _x enableSimulationGlobal false;
                                };
                            };
                        } forEach allUnits;
                    };
                };
            }
            else
            {
                if (spawner getVariable _marker != SPAWNED) then
                {
                    if (spawner getVariable _marker == DESPAWNED) then
                    {
                        if (_greenforNear || _bluforNear || _isForced || _opforNear) then
                        {
                            spawner setVariable [_marker, SPAWNED, true];
                            [[_marker], "A3A_fnc_createAISide"] call A3A_fnc_scheduler;
                        };
                    }
                    else
                    {
                        if (_greenforNear || _bluforNear || _opforNear || _isForced) then
                        {
                            spawner setVariable [_marker, SPAWNED, true];
                            {
                                if (_x getVariable ["markerX",""] == _marker) then
                                {
                                    if (vehicle _x == _x) then
                                    {
                                        _x enableSimulationGlobal true;
                                    };
                                };
                            } forEach allUnits;
                        }
                        else
                        {
                            if (!(_greenforNear || _opforNear || _bluforNear || _isForced)) then
                            {
                                spawner setVariable [_marker, DESPAWNED, true];
                            };
                        };
                    };
                }
                else
                {
                    if (!(_greenforNear || _opforNear || _bluforNear || _isForced)) then
                    {
                        spawner setVariable [_marker, ON_STANDBY, true];
                        {
                            if (_x getVariable ["markerX",""] == _marker) then
                            {
                                if (vehicle _x == _x) then
                                {
                                    _x enableSimulationGlobal false;
                                };
                            };
                        } forEach allUnits;
                    };
                };
            };
        };
    } forEach markersX;
};
