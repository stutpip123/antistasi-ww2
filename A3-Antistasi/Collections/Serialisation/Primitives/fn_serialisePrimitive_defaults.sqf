/*
Function:
    Col_fnc_serialise_primitive_defaults

Description:
    Returns default type and object serialisers and deserialisers.
    This is not a macro so that it can be fetched dynamically at runtime to re-order/modify the output.

Returns:
    <
        ARRAY<ARRAY,CODE,CODE>, TypeNames; serialiser and deserialiser delegates.
        ARRAY<ARRAY,CODE,CODE> class names used in config; serialiser and deserialiser delegates.
    >

Examples:
Serialiser Primitive:
    CODE<ANY> Value to serialise. (NB: Not in an array)
    return <ANY> Store of of variable

Serialiser Object:
    CODE<
        <LOCATION> lookUpTable_object.
        <ANY> Value to serialise.
    > return <ANY> Store of of object

Author: Caleb Serafin
License: MIT License, Copyright (c) 2019 Barbolani & The Official AntiStasi Community
*/
[
    ["BOOLEAN", {_this}, {_this}],
    ["STRING", {_this}, {_this}],
    ["SCALAR", {["SCALAR",_this toFixed 7]}, {parseNumber _this}],
    ["ARRAY", {["ARRAY",_this]}, {_this}],
    ["OBJECT", {["OBJECT",""]}, {objNull}],   // Disabled by default.
    ["CODE", Col_fnc_seriliseCode, Col_fnc_deseriliseCode],  // Splits on size and trims extra braces.
    ["SIDE", Col_fnc_seriliseSide, Col_fnc_deseriliseSide]  // Converts to enum.
]