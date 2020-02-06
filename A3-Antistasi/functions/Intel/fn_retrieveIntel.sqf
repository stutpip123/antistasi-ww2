/*  Handles the retrieving of any kind of intel
*   Params:
*       _intelType/_preCheck : STRING : The type of the intel, one of "Small", "Medium" and "Large"
*       if _intelType == "Small"
*           _caller : OBJECT : The unit which is searching
*           _squadLeader : OBJECT : The unit (or body) which holds the intel
*           _searchAction : NUMBER : The ID of the action which started this script
*       if _intelType == "Medium"
*           _intel : OBJECT : The object which is holding the intel
*       if _intelType == "Large"
*           _intel : OBJECT : The object which is holding the intel
*           _marker : STRING : The string of the marker where the intel is
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
        _this params ["_intelType", "_caller", "_squadLeader", "_searchAction"];
        [_caller, _squadLeader, _searchAction] spawn A3A_fnc_retrieveSmallIntel;
    };
    case ("Medium"):
    {
        _this params ["_intelType", "_intel"];
        //Take intel from desk
        private _side = _intel getVariable "side";
        deleteVehicle _intel;
        hint "Medium intel taken";
        ["Medium intel retrieved!"] call A3A_fnc_showIntel;
        //Show intel content
    };
    case ("Large"):
    {
        _this params ["_intelType", "_intel", "_marker", "_searchAction"];
        [_intel, _marker, _searchAction] spawn A3A_fnc_retrieveLargeIntel;
    };
};
