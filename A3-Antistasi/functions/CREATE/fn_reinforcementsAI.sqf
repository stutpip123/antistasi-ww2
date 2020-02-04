

private _recruitCount = 10 + 2 * tierWar + ((count allPlayers)/2);
{
		//Setting the number of recruitable units per ticks per airport
    garrison setVariable [format ["%1_recruit", _x], _recruitCount, true];
} forEach airportsX;

{
    //Setting the number of recruitable units per ticks per outpost
		garrison setVariable [format ["%1_recruit", _x], 0, true];
} forEach outposts;

//New reinf system (still reactive, so a bit shitty)
{
	_side = _x;
  _reinfMarker = if(_x == Occupants) then {reinforceMarkerOccupants} else {reinforceMarkerInvader};
	_canReinf = if(_x == Occupants) then {canReinforceOccupants} else {canReinforceInvader};
  diag_log format ["Side %1, needed %2, possible %3", _x, count _reinfMarker, count _canReinf];
	_reinfMarker sort true;
	{
		_target = (_x select 1);
		[_target, "Reinforce", _side, [_canReinf]] remoteExec ["A3A_fnc_createAIAction", 2];
		sleep 10;		// prevents convoys spawning on top of each other
		//TODO add a feedback if something was send or not
	} forEach _reinfMarker;
} forEach [Occupants, Invaders];
//hint "Reinforce AI done!";

//Replenish airports if possible
{
	[_x] call A3A_fnc_replenishGarrison;
} forEach airportsX;
