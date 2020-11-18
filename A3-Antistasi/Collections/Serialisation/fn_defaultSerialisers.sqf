/*
Function:
    Col_fnc_defaultSerialisers

Description:
    Returns default type and object serialisers and deserialisers.
    Only the first matching object serialiser gets run.
    This is not a macro so that it can be fetched dynamically at runtime to re-order/modify the output.

Serialiser:
    CODE<ARRAY,ANY>> First value will be the type, if the type has no example use the string returned from typeOf, if the type is a string use "". _simpleArray = [_var,_maxStringLength,_maxChunks] call _code.

Returns:
    <
        ARRAY<ARRAY,CODE,CODE>, TypeNames; serialiser and deserialiser delegates.
        ARRAY<ARRAY,CODE,CODE> class names used in config; serialiser and deserialiser delegates.
    >


Examples:


Author: Caleb Serafin
License: MIT License, Copyright (c) 2019 Barbolani & The Official AntiStasi Community
*/
[
    [
        ["CODE", A3A_fnc_seriliseCode, A3A_fnc_deseriliseCode],  // Splits on size and trims extra braces.
        ["ARRAY", {str (_this#0)}, {parseSimpleArray (_this#0)}],
        ["SCALAR", {str (_this#0)}, {parseNumber (_this#0)}],
        ["STRING", {str (_this#0)}, {(parseSimpleArray (["[",(_this#0),"]"] joinString "")) #0;}],
        ["BOOLEAN",{str (_this#0)}, {(_this#0) isEqualTo "true"}],
        ["SIDE", A3A_fnc_seriliseSide, A3A_fnc_deseriliseSide]
    ],
    [
        ["All", A3A_fnc_seriliseAll, A3A_fnc_deseriliseAll],
        ["AllVehicles", A3A_fnc_seriliseAllVehicles, A3A_fnc_deseriliseAllVehicles]
    ]
];