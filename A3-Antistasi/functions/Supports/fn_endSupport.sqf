params ["_supportName", "_side"];

/*  Removes the data of the support from the arrays

    Execution on: Server

    Scope: Internal

    Params:
        _supportName: STRING : The callsign of the support
        _side: SIDE : The side the support belongs too

    Returns:
        Nothing
*/

private _fileName = "endSupport";
server setVariable [format ["%1_targets", _supportName], nil, true];

if (_side == Occupants) then
{
    private _index = occupantsSupports findIf {(_x select 2) == _supportName};
    occupantsSupports deleteAt _index;
};

if(_side == Invaders) then
{
    private _index = invadersSupports findIf {(_x select 2) == _supportName};
    invadersSupports deleteAt _index;
};

deleteMarker (format ["%1_coverage", _supportName]);
deleteMarker (format ["%1_text", _supportName]);

[2, format ["Ended support and deleted data for %1", _supportName], _fileName] call A3A_fnc_log;
