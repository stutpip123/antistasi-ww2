/*
Author: Caleb Serafin
    WORK IN PROGRESS
    Turns a parent array into a string.
    attempts to recurse up tree if root is not a namespace.
    Process can be reversed by deserialise.

Arguments:
    <VARSPACE/OBJECT> Root variable space
    <STRING> Names of nested locations {0 ≤ repeat this param < ∞}
    ...
    <STRING> Name of final location.

Return Value:
    <STRING> serialisation of namespace parents.

Scope: Local return. Local arguments.
Environment: Any.
Public: Yes

Exceptions:
    ["invalidLocationAddressRoot",_details] If root of location tree cannot be traced back to a namespace.
    ["invalidParams",_details] If root of location tree cannot be traced back to a namespace.

Example:
    [localNamespace,"Collections","TestBucket","NewLocation"] call Col_fnc_location_serialiseAddress;  // "[""col_locaddress"",4,""collections"",""testbucket"",""newlocation""]"
*/
if (count _this < 2) exitWith {
    // diag_log "ERROR: fn_location_serialiseAddress: Too little args for array parent."; // TODO: implement overridable method for logging.
    // We will let it slide for now.
    "";
};

private _serialisation = ["col_locaddress"];
private _array = [];
private _root = _this#0;
if !(_root isEqualType missionNamespace) then { // All namespaces will work.
    if (_root isEqualType locationNull && { (toLower text _root select [0,17]) isEqualTo "[""col_locaddress""" }) then {
        _serialisation = parseSimpleArray (toLower text _root);
    } else {
        diag_log "ERROR: fn_location_serialiseAddress: invalidLocationAddressRoot: Address root is type of <"+typeName _root+">."; // TODO: implement overridable method for logging.
        throw ["invalidLocationAddressRoot","Address root is type of <"+typeName _root+">."];
    };
} else {
    _serialisation pushBack ([locationNull,_root] call Col_fnc_serialise_namespace)#1;
};
for "_i" from 1 to count _this -1 do {
    _serialisation pushBack toLower (_this#_i);
};
str _serialisation;
