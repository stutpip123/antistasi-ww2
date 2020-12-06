/*
Author: Caleb Serafin
    Returns a 14 digit base 10 local unique identifier. 0.0070ms.
    Will wrap around to 0. If you left this running at 1500 at 60Hz (max speed) for 4 years, you will still have space left.
    Use an isNil block to make thread-safe.

Return Value:
    <STRING> 14 digit LID. Format: "X.XXXXXXX.XXXXXX".

Scope: Same Machine.
Environment: Unscheduled.
Public: Yes.

Example:
    call Col_fnc_ID_LUID14
*/
Col_ID_LUID14_1 = Col_ID_LUID14_1 + 1;  // Little-Endian encoding
Col_ID_LUID14_0 = (Col_ID_LUID14_0 + floor (Col_ID_LUID14_1 / 10000000)) mod 10000000;
Col_ID_LUID14_1 = Col_ID_LUID14_1 mod 10000000;
(Col_ID_LUID14_0 / 1000000 toFixed 6) + (Col_ID_LUID14_1 / 1000000 toFixed 6);
