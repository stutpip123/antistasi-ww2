/*
Author: Caleb Serafin
    Defines enums to reduced network traffic.

Example:
    #include "concurrent_defines.hpp"                                 // If sqf file in Concurrent wanted to use this.
    #include "..\concurrent_defines.hpp"                              // If sqf file in ss wanted to use this.
    #include "..\Concurrent\concurrent_defines.hpp"                   // If sqf file in Map wanted to use this.
    #include "..\..\Collections\Concurrent\concurrent_defines.hpp"    // If sqf file in functions\Utility wanted to use this.

*/
#ifndef Col_mac_concurrent_defines
#define Col_mac_concurrent_defines

#define Col_mac_concurrent_type_conLoc 0
#define Col_mac_concurrent_type_conMap 1
#define Col_mac_concurrent_type_conArray 2


#define Col_mac_concurrent_operation_add 0
#define Col_mac_concurrent_operation_remove 1

#endif