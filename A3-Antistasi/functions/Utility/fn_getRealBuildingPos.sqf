params ["_buildingPos"];

/*  When given a buidling position, it returns the position of the underlaying floor

    Execution on: All

    Scope: External

    Params:
        _buildingPos : ARRAY : A building pos in format ATL

    Returns:
        _newPos: ARRAY or NUMBER : The actual position of the floor or -1 if not found
*/

//Convert to ASL
private _posASL = +_buildingPos;
_posASL set [2, ((ATLToASL _posASL) select 2)];

//Do a raycast to check for the floor
private _newPos = lineIntersectsSurfaces [_posASL, (_posASL vectorAdd [0, 0, -1])];

//No intersection found, return -1
if(count _newPos == 0) exitWith {-1};

//Get the right data array
_newPos = (_newPos select 0) select 0;
_newPos = ASLToATL _newPos;
_newPos;
