params ["_marker", "_group"];

private _units = units _group;
private _dontDespawn = false;
private _markerPos = getMarkerPos _marker;

if (spawner getVariable _marker != 2) then
{
	{
        deleteWaypoint _x
    } forEach (waypoints _group);
	private _wp = _group addWaypoint [(getMarkerPos _marker), 0];
	_wp setWaypointType "MOVE";
    _wp setWaypointCompletionRadius 15;

	waitUntil
    {
        sleep 5;
        //Wait till marker changes its owner
        !(sidesX getVariable [_marker,sideUnknown] == teamPlayer) ||
        //Or till group arrived and marker despawned
        {((leader _group) distance2D _markerPos) < 50 &&
        {(spawner getVariable _marker) == 2}}
    };
	if (!(sidesX getVariable [_marker,sideUnknown] == teamPlayer)) then
    {
        _dontDespawn = true;
    };
};

if (!_dontDespawn) then
{
    //Units have arrived and outpost despawned
    private _aliveUnits = [];
	{
        if (alive _x) then
		{
            _aliveUnits pushBack (typeOf _x);
            deleteVehicle _x;
		};
	} forEach _units;
    [_marker, _aliveUnits] call A3A_fnc_addToOver;
    [_marker] call A3A_fnc_mrkUpdate;
	deleteGroup _group;
}
else
{
    //The marker changed its owner, returning as HC squad
	{
        if (alive _x) then
		{
            _x setVariable ["markerX",nil,true];
            _x removeAllEventHandlers "killed";
            _x addEventHandler
            [
                "killed",
                {
                    _this params ["_victim", "_killer"];
                    [_victim] call A3A_fnc_postmortem;
                    if ((isPlayer _killer) && (side _killer == teamPlayer)) then
                    {
                        if (!isMultiPlayer) then
                        {
                            [0,20] call A3A_fnc_resourcesFIA;
                            _killer addRating 1000;
                        };
                    }
                    else
                    {
                        if (side _killer == Occupants) then
                        {
                            [0.25,0, getPos _victim] call A3A_fnc_citySupportChange;
                            [-0.25,0] call A3A_fnc_prestige;
                        }
                        else
                        {
                            if (side _killer == Invaders) then
                            {
                                [0,-0.25] call A3A_fnc_prestige;
                            };
                        };
                    };
                    _victim setVariable ["spawner",nil,true];
                }
            ];
		};
	} forEach _units;
	theBoss hcSetGroup [_group];
	(format ["Group %1 is back to HC control because the zone which they should garrison has been lost",groupID _group]) remoteExec ["hint", theBoss];
};
