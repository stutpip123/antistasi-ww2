/*
Author: Caleb Serafin
    Adds or removes maps from available list.
    If a map has OnDispose EH's for loaded data, they will be called.
    If a map is loaded, it will be disposed.

Arguments:


Return Value:
    <nil>

Scope: Client. will auto-subscribe client to new map.
Environment: Any.
Public: No.

Example:
    ["Test",Col_mac_concurrent_operation_add,Col_mac_concurrent_type_conLoc] call Col_fnc_concurrent_updateAvailable;
*/
#include "concurrent_defines.hpp"
params [
    ["_name","",[""]],
    ["_operation",-1,[ 0 ]],
    ["_type",-1,[ 0 ]]
];
_name = toLower _name;
private _conNamespace = [localNamespace,"Collections","Concurrent",locationNull] call Col_fnc_nestLoc_get;
switch (_operation) do {

    case (Col_mac_concurrent_operation_add): {
        isNil {
            private _availableConcurrentCollections = _conNamespace getVariable ["Available",[]];
            _availableConcurrentCollections pushBackUnique [_name,_type];
            _conNamespace setVariable["Available",_availableConcurrentCollections];
        };

        private _onNewEHs = [_conNamespace,"Loaded",_name,"OnNew",[]] call Col_fnc_nestLoc_get;
        {[_name] call _x} forEach _onNewEHs;
    };

    case (Col_mac_concurrent_operation_remove): {
        isNil {
            private _availableConcurrentCollections = _conNamespace getVariable ["Available",[]];
            [_availableConcurrentCollections,_name] call Col_fnc_map_rem;
            _conNamespace setVariable["Available",_availableConcurrentCollections];
        };

        private _container = _conNamespace getVariable [_name,locationNull];
        private _onDisposeEHs = _container getVariable ["OnDispose",[]];
        {[_name] call _x} forEach _onDisposeEHs;

        switch (_container getVariable ["Type",-1]) do {
            case (-1): { true; };
            case (Col_mac_concurrent_type_conLoc): { deleteLocation (_container getVariable ["Value",locationNull]); };
            case (Col_mac_concurrent_type_conMap): { _container setVariable ["Value",nil]; };
            case (Col_mac_concurrent_type_conArray): { _container setVariable ["Value",nil]; };
            default {
                diag_log "ERROR: fn_concurrent_updateAvailable: Attempted to dispose concurrent collection of type <"+str _container getVariable ["Type",-1]+">, with friendly Name <"+_container getVariable ["TypeFriendlyName","Friendly name undefined"]+">."; // TODO: implement overridable method for logging.
            };
        };
        deleteLocation _container;
    };

    default {
        diag_log "ERROR: fn_concurrent_updateAvailable: Operation type <"+_operation+"> requested ."; // TODO: implement overridable method for logging.
    };
};



nil;
