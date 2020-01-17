if (!isServer) exitWith{};

//debugperf = false;

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
        //TODO remove AI units from this behaviour
        private _spawners = allUnits select {_x getVariable ["spawner",false]};
        _greenfor = [];
        _blufor = [];
        _opfor = [];
        {
            private _sideX = side (group _x);
            switch (_sideX) do
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

    {
        sleep _timeX;
        private _marker = _x;

        _positionMRK = getMarkerPos (_marker);

        if (sidesX getVariable [_marker,sideUnknown] == Occupants) then
        {
            if (spawner getVariable _marker != 0) then
            {
                if (spawner getVariable _marker == 2) then
                {
                    if (({if (_x distance2D _positionMRK < distanceSPWN) exitWith {1}} count _greenfor > 0) or ({if ((_x distance2D _positionMRK < distanceSPWN2)) exitWith {1}} count _opfor > 0) or (_marker in forcedSpawn)) then
                    {
                        spawner setVariable [_marker,0,true];
                        if (_marker in citiesX) then
                        {
                            if (({if (_x distance2D _positionMRK < distanceSPWN) exitWith {1}} count _greenfor > 0) or ({if ((isPlayer _x) and (_x distance2D _positionMRK < distanceSPWN2)) exitWith {1}} count _blufor > 0) or (_marker in forcedSpawn)) then {[[_marker],"A3A_fnc_createAICities"] call A3A_fnc_scheduler};
                            if (not(_marker in destroyedSites)) then
                            {
                                if (({if ((isPlayer _x) and (_x distance2D _positionMRK < distanceSPWN)) exitWith {1};false} count allUnits > 0) or (_marker in forcedSpawn)) then {[[_marker],"A3A_fnc_createCIV"] call A3A_fnc_scheduler};
                            };
                        }
                        else
                        {
                            if (_marker in controlsX) then
                            {
                                [[_marker],"A3A_fnc_createAIcontrols"] call A3A_fnc_scheduler
                            }
                            else
                            {
                                if (_marker in airportsX) then
                                {
                                    [[_marker],"A3A_fnc_createAIAirplane"] call A3A_fnc_scheduler
                                }
                                else
                                {
                                    if (((_marker in resourcesX) or (_marker in factories))) then
                                    {
                                        [[_marker],"A3A_fnc_createAIResources"] call A3A_fnc_scheduler
                                    }
                                    else
                                    {
                                        if ((_marker in outposts) or (_marker in seaports)) then
                                        {
                                            [[_marker],"A3A_fnc_createAIOutposts"] call A3A_fnc_scheduler
                                        };
                                    };
                                };
                            };
                        };
                    };
                }
                else
                {
                    if (({if (_x distance2D _positionMRK < distanceSPWN) exitWith {1}} count _greenfor > 0) or ({if ((_x distance2D _positionMRK < distanceSPWN2)) exitWith {1}} count _opfor > 0) or (_marker in forcedSpawn)) then
                    {
                        spawner setVariable [_marker,0,true];
                        if (isMultiplayer) then
                        {
                            {
                                if (_x getVariable ["markerX",""] == _marker) then {if (vehicle _x == _x) then {_x enableSimulationGlobal true}}
                            } forEach allUnits;
                        }
                        else
                        {
                            {
                                if (_x getVariable ["markerX",""] == _marker) then {if (vehicle _x == _x) then {_x enableSimulation true}}
                            } forEach allUnits;
                        };
                    }
                    else
                    {
                        if (({if (_x distance2D _positionMRK < distanceSPWN1) exitWith {1}} count _greenfor == 0) and ({if ((_x distance2D _positionMRK < distanceSPWN)) exitWith {1}} count _opfor == 0) and (not(_marker in forcedSpawn))) then
                        {
                            spawner setVariable [_marker,2,true];
                        };
                    };
                };
            }
            else
            {
                if (({if (_x distance2D _positionMRK < distanceSPWN) exitWith {1}} count _greenfor == 0) and ({if ((_x distance2D _positionMRK < distanceSPWN2)) exitWith {1}} count _opfor == 0) and ({if ((isPlayer _x) and (_x distance2D _positionMRK < distanceSPWN2)) exitWith {1}} count _blufor == 0) and (not(_marker in forcedSpawn))) then
                {
                    spawner setVariable [_marker,1,true];
                    if (isMultiplayer) then
                    {
                        {
                            if (_x getVariable ["markerX",""] == _marker) then {if (vehicle _x == _x) then {_x enableSimulationGlobal false}}
                        } forEach allUnits;
                    }
                    else
                    {
                        {
                            if (_x getVariable ["markerX",""] == _marker) then {if (vehicle _x == _x) then {_x enableSimulation false}}
                        } forEach allUnits;
                    };
                };
            };
        }
        else
        {
            if (sidesX getVariable [_marker,sideUnknown] == teamPlayer) then
            {
                if (spawner getVariable _marker != 0) then
                {
                    if (spawner getVariable _marker == 2) then
                    {
                        if (({if (_x distance2D _positionMRK < distanceSPWN) exitWith {1}} count _blufor > 0) or ({if (_x distance2D _positionMRK < distanceSPWN) exitWith {1}} count _opfor > 0) or ({if (((_x getVariable ["owner",objNull]) == _x) and (_x distance2D _positionMRK < distanceSPWN2)) exitWith {1}} count _greenfor > 0) or (_marker in forcedSpawn)) then
                        {
                            spawner setVariable [_marker,0,true];
                            if (_marker in citiesX) then
                            {
                                //[_marker] remoteExec ["A3A_fnc_createAICities",HCGarrisons];
                                if (not(_marker in destroyedSites)) then
                                {
                                    if (({if ((isPlayer _x) and (_x distance2D _positionMRK < distanceSPWN)) exitWith {1};false} count allUnits > 0) or (_marker in forcedSpawn)) then {[[_marker],"A3A_fnc_createCIV"] call A3A_fnc_scheduler};
                                };
                            };
                            if (_marker in outpostsFIA) then {[[_marker],"A3A_fnc_createFIAOutposts2"] call A3A_fnc_scheduler} else {if (not(_marker in controlsX)) then {[[_marker],"A3A_fnc_createSDKGarrisons"] call A3A_fnc_scheduler}};
                        };
                    }
                    else
                    {
                        if (({if (_x distance2D _positionMRK < distanceSPWN) exitWith {1}} count _blufor > 0) or ({if (_x distance2D _positionMRK < distanceSPWN) exitWith {1}} count _opfor > 0) or ({if (((_x getVariable ["owner",objNull]) == _x) and (_x distance2D _positionMRK < distanceSPWN2) or (_marker in forcedSpawn)) exitWith {1}} count _greenfor > 0)) then
                        {
                            spawner setVariable [_marker,0,true];
                            if (isMultiplayer) then
                            {
                                {
                                    if (_x getVariable ["markerX",""] == _marker) then {if (vehicle _x == _x) then {_x enableSimulationGlobal true}}
                                } forEach allUnits;
                            }
                            else
                            {
                                {
                                    if (_x getVariable ["markerX",""] == _marker) then {if (vehicle _x == _x) then {_x enableSimulation true}}
                                } forEach allUnits;
                            };
                        }
                        else
                        {
                            if (({if (_x distance2D _positionMRK < distanceSPWN1) exitWith {1}} count _blufor == 0) and ({if (_x distance2D _positionMRK < distanceSPWN1) exitWith {1}} count _opfor == 0) and ({if (((_x getVariable ["owner",objNull]) == _x) and (_x distance2D _positionMRK < distanceSPWN)) exitWith {1}} count _greenfor == 0) and (not(_marker in forcedSpawn))) then
                            {
                                spawner setVariable [_marker,2,true];
                            };
                        };
                    };
                }
                else
                {
                    if (({if (_x distance2D _positionMRK < distanceSPWN) exitWith {1}} count _blufor == 0) and ({if (_x distance2D _positionMRK < distanceSPWN) exitWith {1}} count _opfor == 0) and ({if (((_x getVariable ["owner",objNull]) == _x) and (_x distance2D _positionMRK < distanceSPWN2)) exitWith {1}} count _greenfor == 0) and (not(_marker in forcedSpawn))) then
                    {
                        spawner setVariable [_marker,1,true];
                        if (isMultiplayer) then
                        {
                            {if (_x getVariable ["markerX",""] == _marker) then {if (vehicle _x == _x) then {_x enableSimulationGlobal false}}} forEach allUnits;
                        }
                        else
                        {
                            {if (_x getVariable ["markerX",""] == _marker) then {if (vehicle _x == _x) then {_x enableSimulation false}}} forEach allUnits;
                        };
                    };
                };
            }
            else
            {
                if (spawner getVariable _marker != 0) then
                {
                    if (spawner getVariable _marker == 2) then
                    {
                        if (({if (_x distance2D _positionMRK < distanceSPWN) exitWith {1}} count _greenfor > 0) or ({if (_x distance2D _positionMRK < distanceSPWN2) exitWith {1}} count _blufor > 0) or (_marker in forcedSpawn)) then
                        {
                            spawner setVariable [_marker,0,true];
                            if (_marker in controlsX) then
                            {
                                [[_marker],"A3A_fnc_createAIcontrols"] call A3A_fnc_scheduler
                            }
                            else
                            {
                                if (_marker in airportsX) then
                                {
                                    [[_marker],"A3A_fnc_createAIAirplane"] call A3A_fnc_scheduler
                                }
                                else
                                {
                                    if (((_marker in resourcesX) or (_marker in factories))) then
                                    {
                                        [[_marker],"A3A_fnc_createAIResources"] call A3A_fnc_scheduler
                                    }
                                    else
                                    {
                                        if ((_marker in outposts) or (_marker in seaports)) then
                                        {
                                            [[_marker],"A3A_fnc_createAIOutposts"] call A3A_fnc_scheduler
                                        };
                                    };
                                };
                            };
                        };
                    }
                    else
                    {
                        if (({if (_x distance2D _positionMRK < distanceSPWN) exitWith {1}} count _greenfor > 0) or ({if (_x distance2D _positionMRK < distanceSPWN2) exitWith {1}} count _blufor > 0) or (_marker in forcedSpawn)) then
                        {
                            spawner setVariable [_marker,0,true];
                            if (isMultiplayer) then
                            {
                                {
                                    if (_x getVariable ["markerX",""] == _marker) then {if (vehicle _x == _x) then {_x enableSimulationGlobal true}}
                                } forEach allUnits;
                            }
                            else
                            {
                                {
                                    if (_x getVariable ["markerX",""] == _marker) then {if (vehicle _x == _x) then {_x enableSimulation true}}
                                } forEach allUnits;
                            };
                        }
                        else
                        {
                            if (({if (_x distance2D _positionMRK < distanceSPWN1) exitWith {1}} count _greenfor == 0) and ({if ((_x distance2D _positionMRK < distanceSPWN)) exitWith {1}} count _blufor == 0) and (not(_marker in forcedSpawn))) then
                            {
                                spawner setVariable [_marker,2,true];
                            };
                        };
                    };
                }
                else
                {
                    if (({if (_x distance2D _positionMRK < distanceSPWN) exitWith {1}} count _greenfor == 0) and ({if ((_x distance2D _positionMRK < distanceSPWN2) and (isPlayer _x)) exitWith {1}} count _opfor == 0) and ({if (_x distance2D _positionMRK < distanceSPWN2) exitWith {1}} count _blufor == 0) and (not(_marker in forcedSpawn))) then
                    {
                        spawner setVariable [_marker,1,true];
                        if (isMultiplayer) then
                        {
                            {
                                if (_x getVariable ["markerX",""] == _marker) then {if (vehicle _x == _x) then {_x enableSimulationGlobal false}}
                            } forEach allUnits;
                        }
                        else
                        {
                            {
                                if (_x getVariable ["markerX",""] == _marker) then {if (vehicle _x == _x) then {_x enableSimulation false}}
                            } forEach allUnits;
                        };
                    };
                };
            };
        };
    } forEach markersX;
};
