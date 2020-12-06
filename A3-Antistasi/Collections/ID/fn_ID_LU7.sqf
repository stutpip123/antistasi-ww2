/*
Author: Caleb Serafin
    This can just be copied into target file.
    Returns a 7 digit base 10 local unique identifier. 0.0032ms, twice as fast as LU14.
    Will wrap around to 0. If you left this running at 4000 at 60Hz (max speed) for 41 seconds, you will almost wrap around to 0.
    Use an isNil block to make thread-safe.

Return Value:
    <STRING> 7 digit LID. Format: "X.XXXXXX".

Scope: Same Machine.
Environment: Unscheduled.
Public: Yes.

Example:
    call Col_fnc_ID_LUID7
*/
Col_ID_LUID7 = (Col_ID_LUID7 + 1) mod 10000000;
Col_ID_LUID7 / 1000000 toFixed 6;



/*
Col_ID_LUID7 = -1;
Col_fnc_ID_LUID7 = {
    Col_ID_LUID7 = (Col_ID_LUID7 + 1) mod 10000000;
    Col_ID_LUID7 / 1000000 toFixed 6;
};

tst_prevUID = "-1";
tst_currentUID = "-1";
tst_failures = [];

for "_i" from 0 to 2000 do {
    tst_prevUID = currentUID;
    tst_currentUID = Col_fnc_ID_LUID7;
    if (tst_prevUID isEqualTo tst_currentUID) then {tst_failures pushBack currentUID};
};

*/