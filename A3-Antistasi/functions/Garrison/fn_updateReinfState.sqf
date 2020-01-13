params ["_marker", "_winner", ["_looser", teamPlayer]];

/*  Updates the reinf state if the marker, decides whether it can reinforce others and/or needs reinforcement
*   Params:
*       _marker : STRING : The name of the marker
*       _winner : SIDE : The side who is the new owner
*       _looser : SIDE : The looser, nothing happens if you use teamPlayer (default teamPlayer)
*
*   Returns:
*     Nothing
*/

private _ratio = [_marker] call A3A_fnc_getGarrisonRatio;

//Remove old entry
if(_looser != teamPlayer) then
{
    private _index = -1;
    if(_looser == Occupants) then
    {
        //Remove marker from occupants
        _index = reinforceMarkerOccupants findIf {(_x select 1) == _marker};
        reinforceMarkerOccupants deleteAt _index;
        canReinforceOccupants = canReinforceOccupants - [_marker];
    }
    else
    {
        //Remove marker form occupants
        _index = reinforceMarkerInvader findIf {(_x select 1) == _marker};
        reinforceMarkerInvader deleteAt _index;
        canReinforceInvader = canReinforceInvader - [_marker];
    };
};

if(_winner != teamPlayer) then
{
    private _reinfMarker = if(_side == Occupants) then {reinforceMarkerOccupants} else {reinforceMarkerInvader};
    private _canReinf = if(_side == Occupants) then {canReinforceOccupants} else {canReinforceInvader};

    private _isAirport = _marker in airportsX;

    //If in need of reinforcements and not an airport, add to reinfMarker
    if(_ratio != 1 && {!_isAirport}) then
    {
        _reinfMarker pushBack [_ratio, _marker];
    };

    private _isOutpost = _marker in outposts;

    //If units are not depleted, let the outpost send units
    if((_isAirport && _ratio > 0.4) || {_isOutpost && _ratio > 0.8}) then
    {
        _canReinf pushBack [_marker];
    };
};
