#define POINTS_NEEDED       10

/*  Handles the reinforcements of markers
*   Params:
*       Nothing
*
*   Returns:
*       Nothing
*/

private _fileName = "reinforcementsAI";
private _recruitCount =  round ((10 + 2 * tierWar + (floor ((count allPlayers)/2))) * (0.5 * skillMult));
[2, format ["Airports get a total of %1 points this tick", _recruitCount], _fileName] call A3A_fnc_log;
{
    //Setting the number of recruitable units per ticks per airport
    private _current = garrison getVariable [format ["%1_recruit", _x], 0];
    garrison setVariable [format ["%1_recruit", _x], _recruitCount + _current, true];
} forEach airportsX + ["NATO_carrier", "CSAT_carrier"];

_recruitCount = 0;//round ((5 + (round (0.5 * tierWar)) + (floor ((count allPlayers)/4))) * (0.5 * skillMult));
[2, format ["Outposts get a total of %1 points this tick", _recruitCount], _fileName] call A3A_fnc_log;
{
    //Setting the number of recruitable units per ticks per outpost
    private _current = garrison getVariable [format ["%1_recruit", _x], 0];
    garrison setVariable [format ["%1_recruit", _x], _recruitCount + _current, true];
} forEach outposts;

//New reinf system (still reactive, so a bit shitty)
{
    _side = _x;
    _reinfMarker = if(_x == Occupants) then {reinforceMarkerOccupants} else {reinforceMarkerInvader};
    _canReinf = if(_x == Occupants) then {canReinforceOccupants} else {canReinforceInvader};
    //Make a hard copy to work on it
    _canReinf = +_canReinf;
    _canReinf = _canReinf select {(garrison getVariable [format ["%1_recruit", _x], 0]) >= POINTS_NEEDED};
    [
        2,
        format ["Side %1, %2 sites need reinforcement , %3 can send some", _x, count _reinfMarker, count _canReinf],
        _fileName
    ] call A3A_fnc_log;
    _reinfMarker sort true;
    {
        if(count _canReinf == 0) exitWith {};
        _target = (_x select 1);
        [_target, "Reinforce", _side, [_canReinf]] remoteExec ["A3A_fnc_createAIAction", 2];
        sleep 2;		// prevents convoys spawning on top of each other
        _canReinf = _canReinf select {(garrison getVariable [format ["%1_recruit", _x], 0]) >= POINTS_NEEDED};
        //No bases left for sending reinforcements
    } forEach _reinfMarker;
} forEach [Occupants, Invaders];
//hint "ReinforcementsAI done";

//Replenish airports if possible
{
    [_x] call A3A_fnc_replenishGarrison;
} forEach airportsX;
