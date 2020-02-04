params ["_marker", "_vehicle", "_crewGroup", "_cargoGroup"];

private _vehicles = garrison getVariable (format ["%1_vehicles", _marker]);
private _groups = garrison getVariable (format ["%1_groups", _marker]);

_vehicles pushBack _vehicle;
_groups pushBack _crewGroup;
_groups pushBack _cargoGroup;

garrison setVariable [format ["%1_vehicles", _marker], _vehicles, true];
garrison setVariable [format ["%1_groups", _marker], _groups, true];
