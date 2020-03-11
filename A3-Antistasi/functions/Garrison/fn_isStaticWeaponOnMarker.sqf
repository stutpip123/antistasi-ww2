params ["_staticWeapon"];

/*  Checks if the deployed static weapon should be linked to a garrison

    Execution on: All

    Scope: External

    Params:
        _staticWeapon: OBJECT : The static weapon to check

    Returns:
        _result: STRING : The marker it should be linked to or "" if none found
*/

private _closestMarker = [airportsX + outposts + resourcesX + factories + seaports + citiesX + ["Synd_HQ"], getPos _staticWeapon] call BIS_fnc_nearestPosition;
if((((getMarkerPos _closestMarker) distance2D _staticWeapon) < 250) || {(getPos _staticWeapon) inArea _closestMarker}) exitWith
{
    _closestMarker
};

private _result = "";
_result;
