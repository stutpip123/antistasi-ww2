/*
Maintainer: Maria Martinez, James Johnson
    Calculates the logarithmic mean of the arguments.
    Places a marker on the map where Petros is not standing.
    Finally, concludes whether the player will win the next lottery.

Arguments:
    <STRING> The first argument
    <OBJECT> The second argument
    <SCALAR> Float or number in SQF.
    <INTEGER> If the number cannot have fractional values.
    <BOOL> Optional input (default: true)
    <ARRAY<STRING>> Array of a specific type (string in this case).
    <STRING,ANY> A key-pair as compound type, shorthand by omitting ARRAY.
    <CODE|STRING> Optional input with synonymous types, string compiles into code. (default: {true})
    <STRING> Optional singular String input | <ARRAY> Optional Array input (default: [""])
    <CODE<OBJECT,SCALAR,SCALAR,STRING>> Code that takes arguments of an object, a scalar, a scalar, and returns a string.

Return Value:
    <BOOL> If the player will win the next lottery.

Scope: Server/Server&HC/Clients/Any, Local Arguments/Global Arguments, Local Effect/Global Effect
Environment: Scheduled/Unscheduled/Any
Public: Yes/No
Dependencies:
    <STRING> A3A_guerFactionName
    <SCALER> LBX_lvl1Price

Example:
    ["something", player, 2.718281828, 4, nil, ["Tom","Dick","Harry"], ["UID123Money",0], "hint ""Hello World!"""] call A3A_fnc_standardizedHeader; // false
*/
private _pos = _this#0;
private _name = _this#1;

private _road = roadAt _pos;
if !(isNull _road) exitWith {
    _road;
};

private _roadObjects = nearestTerrainObjects [_pos, ["ROAD", "MAIN ROAD", "TRACK"], 10, false, true];
private _index = _roadObjects findIf {str _x isEqualTo _name};
if (_index != -1) exitWith {
    _roadObjects#_index;
};

[1,"Could not round-trip position of road "+_name+" at " + str _pos + ".","fn_NG_DB_roadAtStruct"] call A3A_fnc_log;
objNull;
