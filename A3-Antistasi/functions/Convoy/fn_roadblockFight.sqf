params ["_units", "_roadblockMarker"];

private _fileName = "roadblockFight";
private _nightTimeBonus = if (daytime < 6 || {daytime > 22}) then {1.25} else {0};
private _defenderBonus = 1 * _nightTimeBonus * (1 + (random 0.5));
private _garrison = [_roadblockMarker] call A3A_fnc_getGarrison;

_fn_calculateStrenght =
{
    params ["_array"];
    private _count = 0;
    _array params ["_vehicle", "_crew", "_cargo"];
    _count = (count _crew) + (count _cargo);
    switch (true) do
    {
        case (_vehicle isKindOf "APC"): {_count = _count + 3};
        case (_vehicle isKindOf "Tank"): {_count = _count + 6};
        case (_vehicle isKindOf "Helicopter"):
        {
            //Transport helicopter without a gun dont count
            if(count (getArray (configFile >> "CfgVehicles" >> _vehicle >> "weapons")) > 0) then
            {
                _count = _count + 4;
            };
        };
        case (_vehicle isKindOf "Plane"): {_count = _count + 6};
        default {_count = _count + 1;};
    };
    _count;
};

private _roadBlockStrength = 0;
{
    _roadBlockStrength = _roadBlockStrength + ([_x] call _fn_calculateStrenght);
} forEach _garrison;
_roadBlockStrength = _roadBlockStrength * _defenderBonus;
// Defender calculated

private _attackerStrength = 0;
{
    _attackerStrength = _attackerStrength + ([_x] call _fn_calculateStrenght);
} forEach _units;
//Attacker calculated

private _attackerWon = false;
if(_attackerStrength == 0) then
{
    //Attacker lost
    [2, format ["Attacker lost against roadblock %1", _roadblockMarker], _fileName] call A3A_fnc_log;
    _attackerWon = false;
}
else
{
    private _ratio = _roadBlockStrength/_attackerStrength;
    if(_roadBlockStrength == 0 || {_ratio < 0.9}) then
    {
        [2, format ["Defender at %1 lost against attacker with ratio %2", _roadblockMarker, _ratio], _fileName] call A3A_fnc_log;
        _attackerWon = true;
    }
    else
    {
        if(_ratio > 1.1) then
        {
            [2, format ["Attacker lost against roadblock %1", _roadblockMarker], _fileName] call A3A_fnc_log;
            _attackerWon = false;
        }
        else
        {
            _attackerWon = [true, false] selectRandomWeighted [0.5, 0.5];
            if(_attackerWon) then
            {
                [2, format ["Defender at %1 lost against attacker with ratio %2", _roadblockMarker, _ratio], _fileName] call A3A_fnc_log;
            }
            else
            {
                [2, format ["Attacker lost against roadblock %1", _roadblockMarker], _fileName] call A3A_fnc_log;
            };
        };
    };
};

if(_attackerWon) then
{
    outpostsFIA = outpostsFIA - [_roadblockMarker]; publicVariable "outpostsFIA";
    markersX = markersX - [_roadblockMarker]; publicVariable "markersX";
    sidesX setVariable [_roadblockMarker, nil, true];
    [5, -5, (getMarkerPos _roadblockMarker)] remoteExec ["A3A_fnc_citySupportChange",2];
    ["TaskFailed", ["", "Roadblock Lost"]] remoteExec ["BIS_fnc_showNotification", 2];
};

_attackerWon;
