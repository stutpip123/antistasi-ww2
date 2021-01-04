/*
Author: Caleb Serafin
    Creates following variables.

Return Value:
    <nil>

Scope: Local.
Environment: Unscheduled, Pre-Init.
Public: NO (Only called in pre-init)

Example:
    class Collections_ID
    {
        file="Collections\Concurrent";
        class netLoc_init { preInit = 1 };
    };
*/

if !(assert isMultiplayer) then {
    diag_log "WARNING: Collections framework Concurrent does not support a single-player environment. Further errors will occur."; // TODO: implement overridable method for logging.
    call Col_fnc_NetLoc_initServer;
} else {
    if (isServer) then {
        call Col_fnc_NetLoc_initServer;  // Contains direct alternatives to client version.
    } else {
        call Col_fnc_NetLoc_initClient;
    };
};

private _namespace = [[localNamespace,"Collections","Concurrent"]] call Col_fnc_location_new;
[localNamespace,"Collections","Concurrent",_namespace] call Col_fnc_nestLoc_set;

_namespace setVariable ["Loaded",[[localNamespace,"Collections","Concurrent","Loaded"]] call Col_fnc_location_new];
_namespace setVariable ["Available",[]];

_namespace setVariable ["OutboundQueue",[[localNamespace,"Collections","Concurrent","OutboundQueue"]] call Col_fnc_location_new];
_namespace setVariable ["LastSent",[]];
_namespace setVariable ["WaitingForResponse",false];
_namespace setVariable ["TimeOutExpiry",serverTime];
_namespace setVariable ["TimeOutRunning",false];

[false] call Col_fnc_concurrent_defines;