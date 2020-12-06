/*
Function:
    Col_fnc_serialisation_primitive_defaults

Description:
    Returns default type and object serialisers and deserialisers.
    This is not a macro so that it can be fetched dynamically at runtime to re-order/modify the output.

Returns:
    <
        ARRAY<ARRAY,CODE,CODE>, TypeNames; serialiser and deserialiser delegates.
        ARRAY<ARRAY,CODE,CODE> class names used in config; serialiser and deserialiser delegates.
    >

Serialiser Examples:
    CODE<
        <LOCATION> Serialisation builder.
        <ANY> Value to serialise.
    > return <ARRAY <TYPE>,Serialisation of of object>

Author: Caleb Serafin
License: MIT License, Copyright (c) 2019 Barbolani & The Official AntiStasi Community
*/
[
    ["BOOLEAN", {_this#1}, {_this#1}],
    ["STRING", {_this#1}, {_this#1}],
    ["SCALAR", {["SCALAR",(_this#1) toFixed 7]}, {parseNumber (_this#1)}],
    ["ARRAY", Col_fnc_serialise_array, Col_fnc_deserialise_array],
    ["CODE", Col_fnc_serialise_code, Col_fnc_deserialise_code],  // Splits on size and trims extra braces.
    ["SIDE", Col_fnc_serialise_side, Col_fnc_deserialise_side],  // Converts to enum.
    ["OBJECT", {["NIL",0]}, {objNull}],   // Disabled by default.
    ["NIL", {["NIL",0]}, {nil}]
];
