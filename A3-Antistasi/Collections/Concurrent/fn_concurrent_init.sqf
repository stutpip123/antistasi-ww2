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

private _concurrent = [localNamespace,"Collections","Concurrent",nil,nil] call Col_fnc_nestLoc_set;

[_concurrent,"Loaded",nil,nil] call Col_fnc_nestLoc_set;
_concurrent setVariable ["Available",[]];

[_concurrent,"OutboundQueue",nil,nil] call Col_fnc_nestLoc_set;
_concurrent setVariable ["LastSent",[]];
_concurrent setVariable ["WaitingForResponse",false];
_concurrent setVariable ["TimeOutExpiry",serverTime];
_concurrent setVariable ["TimeOutRunning",false];

[false] call Col_fnc_concurrent_defines;