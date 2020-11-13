/*
Function:
    A3A_fnc_remElement

Description:
    Recommend when loading ordered data, such as options array, pylon magazines ect..
    Searches for specified element in an Array. NB: IT IS PASSED AS A REFERENCE, ELEMENTS WILL BE DELETED!
    If found, the element is replaced with filler and the index returned. Otherwise -1 is returned. Performs strict value comparison.


Parameters:
    <ARRAY<ANY>> Map with any type of key and values.
    <ANY> Element. Limitation: cannot be used to find nils in map.

Returns:
    <ANY> Value or default.

Examples:
    private _allPylonMagazines = ["PylonRack_19Rnd_Rocket_Skyfire","PylonMissile_1Rnd_Bomb_03_F","PylonMissile_1Rnd_Bomb_03_F","PylonRack_19Rnd_Rocket_Skyfire"];
    [_allPylonMagazines,"PylonMissile_1Rnd_Bomb_03_F"] call A3A_fnc_remElement;  // 1
    _allPylonMagazines;  // ["PylonRack_19Rnd_Rocket_Skyfire","PylonMissile_1Rnd_Bomb_03_F","PylonRack_19Rnd_Rocket_Skyfire"]

Author: Caleb Serafin
License: MIT License, Copyright (c) 2019 Barbolani & The Official AntiStasi Community
*/
params [
    ["_array","",[ [] ]],
    ["_element",nil],
    ["_filler",nil]
];
private _filename = "fn_remElement";

private _i = _array find _element;
if !(_i isEqualTo -1) then {
    _array set [_i,_filler];
};
_i;
