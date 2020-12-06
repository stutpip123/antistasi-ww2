/*
Author: Caleb Serafin
    This can just be copied into target file.
    The nil forces isEqualTo to compare memory address not values.
    This technique will not work over network or saving.

Return Value:
    <ARRAY> One nil

Scope: Same Machine.
Environment: Any.
Public: Yes.

Example:
    [_ID,_someOtherID] call Col_fnc_ID_LArray_isEqualTo
*/
_this#0 isEqualTo _this#1;