/*
Author: Caleb Serafin
    Creates a lookup table of defined macros for run-time.

Return Value:
    <nil>

Scope: Local.
Environment: Any.
Public: NO (Only called in init)

Example:

*/
#include "concurrent_defines.hpp"
private _defines = [[localNamespace,"Collections","Concurrent","Defines"]] call Col_fnc_location_new;
[localNamespace,"Collections","Concurrent","Defines",_defines] call Col_fnc_nestLoc_set;

_macroKeyValues = [
    ["concurrent_type_conDict",Col_mac_concurrent_type_conLoc],
    ["concurrent_type_conMap",Col_mac_concurrent_type_conMap],
    ["concurrent_type_conArray",Col_mac_concurrent_type_conArray],

    ["concurrent_operation_add",Col_mac_concurrent_operation_add],
    ["concurrent_operation_remove",Col_mac_concurrent_operation_remove]
];
{
    _defines setVariable [_x#0,_x#1];
} forEach _macroKeyValues;
