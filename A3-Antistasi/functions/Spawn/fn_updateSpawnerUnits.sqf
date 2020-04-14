/*  Updates the arrays containing all units which are able to spawn controlled locations (ConLocs?)
*
*   Execution on: Server only
*
*   Scope: Internal
*
*   Params:
*       None
*
*   Returns:
*       Nothing
*/

[[],[],[]] params ["_teamPlayerUnits", "_occupantsUnits", "_invaderUnits"];

private _spawnerGroups = allGroups select {(side _x) == teamPlayer && {(leader _x != objNull) && {!(isPlayer (leader _x)) && {((leader _x) getVariable ["UnitMarker", ""]) == ""}}}};
private _spawnerUnits = allPlayers + (_spawnerGroups apply {leader _x});

{
    switch (side (group _x)) do
    {
        case (teamPlayer):
        {
            _teamPlayerUnits pushBack _x;
        };
        case (Occupants):
        {
            _occupantsUnits pushBack _x;
        };
        case (Invaders):
        {
            _invaderUnits pushBack _x;
        };
    };
} forEach _spawnerUnits;

[
    3,
    format ["Spawners are %1 / %2 / %3", _teamPlayerUnits, _occupantsUnits, _invaderUnits],
    "UpdateSpawnerUnits"
] call A3A_fnc_log;

playerSpawner = _teamPlayerUnits; publicVariable "playerSpawner";
occupantsSpawner = _occupantsUnits; publicVariable "occupantsSpawner";
invadersSpawner = _invaderUnits; publicVariable "invadersSpawner";
