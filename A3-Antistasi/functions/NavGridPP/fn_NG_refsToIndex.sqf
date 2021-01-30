// MODIFIES EXISTING MA
// [_map] call A3A_NG_refsToIndex;
params [
    ["_map",[],[ [] ]]  // ARRAY<key,ARRAY<key>>
];

private _keyIndexNS = [false] call A3A_fnc_createNamespace;
{
    _keyIndexNS setVariable [str _x#0,_forEachIndex];
} forEach _map;

private _refs = [];
{
    _refs = _x#1;
    {
        _refs set [_forEachIndex,_keyIndexNS getVariable [str _x,-1]]
    } forEach (_x#1);
} forEach _map;

deleteLocation _keyIndexNS;
