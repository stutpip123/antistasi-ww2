params ["_buildingPos"];

/*  Checks whether the given building pos is a valid position to place units

    Execution on: All

    Scope: External

    Params:
        _buildingPos: ARRAY : A building pos in format ATL

    Returns:
        _isValid: BOOLEAN : True if position is valid, false otherwise
*/

private _isValid = (([_buildingPos] call A3A_fnc_getRealBuildingPos) isEqualType []);

_isValid;
