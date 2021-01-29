/*
Author: Caleb Serafin
    Initialises a new concurrent collections.
    All settings can be found/changed through nestLoc: localNamespace > "Collisions" > "Concurrent" > _name > _settingName.
    All onEventHandlers can be found/changed through nestLoc: localNamespace > "Collisions" > "Concurrent" > _name > _onEventHandlerName.

    onCollision: This is called after the specified automatic collision resolution has occurred.
    onSubscribe: This is called after the client's machineNetworkID has been added to the subscribers list.
    onUnsubscribe: This is called after the client's machineNetworkID has been removed from the subscribers list.
    _onClientDisconnect: This is called if the client is a subscriber of this map; And is after the client's machineNetworkID has been removed from the subscribers list.

Arguments:
    <STRING> Name of new collection
    <CODE<NIL,ARRAY(allArguments)>> An event-Handler if map already exists. This is not saved anywhere as it won't matter after creation. Rest of script exits immediately after call. | <STRING> Will attempt to find defined function by name.
    <ARRAY<STRING,ANY>>         Initial items to add to map. (default: [])
    <ARRAY<SCALAR>>             Clients to auto-subscribe (default: [])
    <SCALAR>                    Collision Resolution setting. (default: 1)

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
    ["_containerItems",[],[ [] ]],
    ["_subscribedClients",[],[ [] ]],
    ["_collisionResolution",1,[ 1 ]]
];

private _loaded = locationNull;
private _container = locationNull;
if (isNil {
    _loaded = [localNamespace,"Collections","Concurrent","Loaded",locationNull] call Col_fnc_nestLoc_get;
    if (!isNull (_loaded getVariable [_name,locationNull])) exitWith {
        if (_onMapAlreadyExists isEqualType "") then {
            _onMapAlreadyExists = missionNamespace getVariable [_onMapAlreadyExists,{}];
        };
        _this call _onMapAlreadyExists;
        nil;
    };
    _container =  [_loaded,_name,nil,nil] call Col_fnc_nestLoc_set;
    true;
}) exitWith {false};

_container setVariable ["Name", _name];
_container setVariable ["Value", false];
_container setVariable ["Type", -1];
_container setVariable ["TypeFriendlyName", "Collections Undefined"];
_container setVariable ["SubscribedClients", _subscribedClients];
_container setVariable ["CollisionResolution", _collisionResolution];


_container setVariable ["OnCollision",[]];
_container setVariable ["OnClientLoad",[]];
_container setVariable ["OnClientUnload",[]];
_container setVariable ["OnClientDisconnect",[]];

true;
