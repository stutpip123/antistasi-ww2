params ["_vehicle", "_preference", "_side"];

/*  Selects a suitable group for the given vehicle and preference
*   Params:
*     _vehicle : STRING : The vehicle typename
*     _preference : STRING : The preferred group
*     _side : SIDE : The side of the selected group
*
*   Returns:
*     _group : ARRAY of STRINGS : The selected group
*/

private _fileName = "SelectGroupType";

//If preference is empty, return empty
if(_preference == "EMPTY") exitWith {[]};

private _groupPref = _preference;
if(_vehicle != "") then
{
    private _vehicleSeats = ([_vehicle, true] call BIS_fnc_crewCount) - ([_vehicle, false] call BIS_fnc_crewCount);
    if(_vehicleSeats < 8) then
    {
        if(_vehicleSeats >= 4) then
        {
            if(_groupPref == "SQUAD") then
            {
                [
                    2,
                    format ["Vehicle %1 cannot transport a squad, but one was selected, reducing to group!", _vehicle],
                    _fileName,
                    true
                ] call A3A_fnc_log;
                _groupPref = "GROUP";
            };
        }
        else
        {
            //Vehicle does not have enough vehicle spaces for any group, assuming preference is wanted and the user knows what he is doing
            [
                2,
                format ["Vehicle %1 cannot transport four or more people, reconsider using another vehicle!", _vehicle],
                _fileName,
                true
            ] call A3A_fnc_log;
        };
    };
};

private _group = [];
switch (_groupPref) do
{
    case ("SQUAD"):
    {
        if(_side == Occupants) then {_group = +(selectRandom groupsNATOSquad)};
        if(_side == Invaders) then {_group = +(selectRandom groupsCSATSquad)};
    };
    case ("GROUP"):
    {
        if(_side == Occupants) then {_group = +(selectRandom groupsNATOmid)};
        if(_side == Invaders) then {_group = +(selectRandom groupsCSATmid)};
    };
    case ("AT"):
    {
        if(_side == Occupants) then {_group = +groupsNATOAT};
        if(_side == Invaders) then {_group = +groupsCSATAT};
    };
    case ("AA"):
    {
        if(_side == Occupants) then {_group = +groupsNATOAA};
        if(_side == Invaders) then {_group = +groupsCSATAA};
    };
    case ("SPECOPS"):
    {
        if(_side == Occupants) then {_group = +NATOSpecOp};
        if(_side == Invaders) then {_group = +CSATSpecOp};
    };
};

_group;
