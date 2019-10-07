params ["_marker", "_points"];

/*  Adds the destruction point to the given marker
*   Params:
*     _marker : STRING : The marker on which the points should be added
*     _points : NUMBER : The amount of points that will be added to the marker
*
*   Returns:
*     Nothing
*/

_currentDestruct = server getVariable [format ["%1_destruct", _marker], 0];

_isDestroyed = _currentDestruct >= 100;
_currentDestruct = _currentDestruct + _points;

//Limit at 200
if(_currentDestruct > 200) then {_currentDestruct = 200;};

//Once it hit 100, the site is destroyed
if(!_isDestroyed && {_currentDestruct >= 100}) then
{
  destroyedSites pushBack _marker;
  _name = [_marker] call A3A_fnc_localizar;
  publicVariable "destroyedSites";
  ["TaskFailed", ["", format ["%1 Destroyed",_name]]] remoteExec ["BIS_fnc_showNotification",[teamPlayer,civilian]];
};

server setVariable [format ["%1_destruct", _marker], _currentDestruct];
