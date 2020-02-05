/*  Handles the retrieving of any kind of intel
*   Params:
*       _intelType/_preCheck : STRING : The type of the intel, one of "Small", "Medium" and "Large"
*       if _intelType == "Small"
*           _caller : OBJECT : The unit which is searching
*           _squadLeader : OBJECT : The unit (or body) which holds the intel
*           _hasIntel : BOOLEAN : Decides if the _squadLeader has actual intel
*           _searchAction : NUMBER : The ID of the action which started this script
*           _side : SIDE : The side of the _squadLeader
*       if _intelType == "Medium"
*           _intel : OBJECT : The object which is holding the intel
*           _side : SIDE : The side to which to intel belongs
*       if _intelType == "Large"
*           _intel : OBJECT : The object which is holding the intel
*           _marker : STRING : The string of the marker where the intel is
*           _isTrap : BOOELAN : Determines if the intel is secured by a explosive charge
*           _searchAction : NUMBER : The ID of the action which started this script
*
*   Returns:
*       Nothing
*/

_preCheck = _this select 0;
switch (_preCheck) do
{
    case ("Small"):
    {
        _this params ["_intelType", "_squadLeader", "_side", "_hasIntel", "_caller", "_searchAction"];
        ["_caller", "_squadLeader", "_hasIntel", "_searchAction", "_side"] spawn A3A_fnc_retrieveSmallIntel;
    };
    case ("Medium"):
    {
        _this params ["_intelType", "_intel", "_side"];
        //Take intel from desk
        deleteVehicle _intel;
        hint "Medium intel taken";
        //Show intel content
    };
    case ("Large"):
    {
        _this params ["_intelType", "_intel", "_marker", "_isTrap", "_searchAction"];
        ["_intel", "_marker", "_isTrap", "_searchAction"] spawn A3A_fnc_retrieveLargeIntel;
    };
};
