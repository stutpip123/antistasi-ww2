params
[
    ["_side", sideEmpty, [sideEmpty]],
    ["_weaponsArray", [], [[]]],
    ["_blacklistedWeapons", [], [[]]]
];

/*
*/

if(_side == sideEmpty) exitWith {""};

if(_weaponsArray isEqualTo []) exitWith {""};

private _warlevel = tierWar;

private _tierPoint = (_warlevel/10) * (count _weaponsArray);

private _lowerIndex = floor _tierPoint;
private _upperIndex = _lowerIndex + 1;

if (count _weaponsArray > 5) then
{
    if(_lowerIndex == 0) then
    {
        _upperIndex = _upperIndex + 1;
    }
    else
    {
        _lowerIndex = _lowerIndex - 1;
    };
};

if (count _weaponsArray <= 3) exitWith
{
    _weaponsArray select _lowerIndex;
};
