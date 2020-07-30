params
[
    ["_weaponsArray", [], [[]]],
    ["_blackListedWeapons", [], [[]]]
];

/*  Picks a weapon from the array according to the war level, selects random if not sorted

    Execution on: HC or Server

    Call by: call

    Params:
        _weaponsArray : ARRAY : The array you want to pick a weapon from
        _blackListedWeapons : ARRAY : List of weapons which cannot be picked

    Returns:
        STRING : The weapon name of the picked weapon
*/

if(_weaponsArray isEqualTo []) exitWith {""};

//If not sorted, return random array
if !(weaponsSortedBySide) exitWith
{
    selectRandom _weaponsArray;
};

private _warlevel = tierWar;

//Reduce possible options
private _weaponsArray = _weaponsArray - _blackListedWeapons;

private _tierPoint = ((_warlevel - 1)/10) * (count _weaponsArray);
//Calculate a number equal or bigger zero, but at least one less then the last array index
private _lowerIndex = ((floor _tierPoint) min ((count _weaponsArray) - 2)) max 0;
private _upperIndex = (_lowerIndex + 1) min ((count _weaponsArray) - 1);

//Large array, add more possible options
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

//Small array, take worst option
if (count _weaponsArray <= 3) exitWith
{
    _weaponsArray select _lowerIndex;
};

//Select random item from range
private _index = _lowerIndex + (round (random (_upperIndex - _lowerIndex)));
private _weapon = _weaponsArray select _index;

_weapon;
