/*
Function:
    A3A_fnc_serialiseNestedObject

Description:
    Converts a nestedObject tree into strings.
    Multiple strings are produced if the set string limit is exceeded.
    Custom serialisation delegates may be provided.

Environment:
    <SCHEDULED> Recommended, not required. Recurses over entire sub-tree. Serialisation process is resource heavy.

Parameters:
    <LOCATION> Head of chosen nestedObject tree.
    <ARRAY<ANY,CODE<STRING,ANY,INTEGER,INTEGER>>> Serialisation override delegates. First value will be the type, if the type has no example use the string returned from typeOf, if the type is a string use "". _serialisation = [_var,_maxStringLength,_maxChunks] call _code.
    <INTEGER> Max string chunk length. [DEFAULT=1 000 000]
    <INTEGER> Max chunks, will throw exception if this is exceeded. [DEFAULT=1 000 000]

Returns:
    <ARRAY<STRING>> Serialisation of nestedObject tree;

Examples:


Author: Caleb Serafin
License: MIT License, Copyright (c) 2019 Barbolani & The Official AntiStasi Community
*/