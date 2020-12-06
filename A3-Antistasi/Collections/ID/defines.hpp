/*
Author: Caleb Serafin
    Alternative macros for short ID functions.
    Remeber to add a private to outVar if it's a new declaration!

Scope: Local. Collection objects are local.
Environment: All are Unscheduled.
Public: Yes.

Example:
    Col_mac_ID_LU14(private _missionID)
*/

#define Col_fnc_ID_LArray(outVar) outVar = [nil];
#define Col_fnc_ID_LArray_isEqualTo(ID1,ID2) ID1 isEqualTo ID2;
#define Col_mac_ID_LU7(outVar) Col_ID_LUID7 = (Col_ID_LUID7 + 1) mod 10000000; Col_ID_LUID7 / 1000000 toFixed 6;
#define Col_mac_ID_LU14(outVar) Col_ID_LUID14_1 = Col_ID_LUID14_1 + 1; Col_ID_LUID14_0 = (Col_ID_LUID14_0 + floor (Col_ID_LUID14_1 / 10000000)) mod 10000000; Col_ID_LUID14_1 = Col_ID_LUID14_1 mod 10000000; (Col_ID_LUID14_0 / 1000000 toFixed 6) + (Col_ID_LUID14_1 / 1000000 toFixed 6);
