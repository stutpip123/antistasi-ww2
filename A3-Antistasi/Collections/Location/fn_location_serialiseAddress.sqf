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
    [localNamespace,"Collections","TestBucket","NewLocation"] call Col_fnc_location_serialiseAddress;
*/
if (count _this < 2) exitWith {
    diag_log "ERROR: fn_location_serialiseAddress: Too little args for array parent."; // TODO: implement overridable method for logging.
    "";
};

private _serialisation = "col_locationaddress:[";
private _array = [];
private _root = _this#0;
if !(_root isEqualType missionNamespace) then { // All namespaces will work.
    private _textRoot = toLower text _root;
    if (_root isEqualType locationNull && { (_textRoot select [0,20]) isEqualTo "col_locationaddress:" }) then {
        _serialisation = (_textRoot select [20,count _textRoot -21] + ",");  // extra -1 to remove closing square brace
    } else {
        diag_log "ERROR: fn_location_serialiseAddress: invalidLocationAddressRoot: Address root is type of <"+typeName _root+">."; // TODO: implement overridable method for logging.
        throw ["invalidLocationAddressRoot","Address root is type of <"+typeName _root+">."];
    };
} else {
    _serialisation = _serialisation + [locationNull,_root] call Col_fnc_serialise_code;
}