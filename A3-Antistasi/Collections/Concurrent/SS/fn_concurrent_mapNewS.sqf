/*
Author: Caleb Serafin
    Initialises a new concurrent map and broadcasts it's availability.
    All settings can be found/changed through nestLoc: localNamespace > "Collisions" > "Concurrent" > _name > _settingName.
    All onEventHandlers can be found/changed through nestLoc: localNamespace > "Collisions" > "Concurrent" > _name > _onEventHandlerName.

    onCollision: This is called after the specified automatic collision resolution has occurred.
    onSubscribe: This is called after the client's machineNetworkID has been added to the subscribers list.
    onUnsubscribe: This is called after the client's machineNetworkID has been removed from the subscribers list.
    _onClientDisconnect: This is called if the client is a subscriber of this map; And is after the client's machineNetworkID has been removed from the subscribers list.

Arguments:
    <STRING> Name of new Map
    <CODE<NIL,ARRAY(allArguments)>> An event-Handler if map already exists. This is not saved anywhere as it won't matter after creation. Rest of script exits immediately after call. | <STRING> Will attempt to find defined function by name.
    <ARRAY<STRING,ANY>>         Initial items to add to map. (default: [])
    <ARRAY<SCALAR>>             Clients to auto-subscribe (default: [])
    <SCALAR>                    Collision Resolution setting. (default: 1)
    <CODE<NIL,STRING(MapName),ARRAY(Items)<ANY(ProposedValue),ANY(ExistingValue),SCALAR(ProposingClientID),SCALAR(ExistingClientID)>>> Server-side event-handler if key name already exists. (default: {}) | <STRING> Will attempt to find defined function by name.
    <CODE<NIL,STRING(MapName),SCALAR(ClientID)>>    Server-side event-handler if a client subscribes. (default: {}) | <STRING> Will attempt to find defined function by name.
    <CODE<NIL,STRING(MapName),SCALAR(ClientID)>>    Server-side event-handler if a client unsubscribes. (default: {}) | <STRING> Will attempt to find defined function by name.
    <CODE<NIL,STRING(MapName),SCALAR(ClientID)>>    Server-side event-handler if a client disconnects while subscribed. (default: {}) | <STRING> Will attempt to find defined function by name.

Return Value:
    <BOOLEAN> true if success, false if failure.

Scope: Client. will auto-subscribe client to new map.
Environment: Any.
Public: Yes.

Example:
    [] call Col_fnc_concurrent_ss_new;

*/
params [
    ["_name","",[""]],
    ["_onMapAlreadyExists",{},[{},""]],
    ["_metaDataItems",[],[ [] ]],
    ["_subscribedClients",[],[ [] ]],
    ["_collisionResolution",1,[ 1 ]]
];


if (_this call Col_fnc_concurrent_ss_new) exitWith {

    _container = [localNamespace,"Collections","Concurrent","LoadedMaps","_name",locationNull] call Col_fnc_nestLoc_get;

    _container setVariable ["Value", []];
    _container setVariable ["Type", Col_mac_concurrent_type_conMap];
    _container setVariable ["TypeFriendlyName", "Collections Concurrent Map"];

    [_name,Col_mac_concurrent_operation_add,Col_mac_concurrent_type_conMap] remoteExecCall ["Col_fnc_concurrent_updateAvailable",-2];
    [_name,Col_mac_concurrent_operation_add,Col_mac_concurrent_type_conMap] call Col_fnc_concurrent_updateAvailable;
    true;
};
false;
