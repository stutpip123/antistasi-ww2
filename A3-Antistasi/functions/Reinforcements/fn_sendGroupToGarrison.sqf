params ["_marker", "_group"];

private _units = units _group;
private _markerChanged = false;
private _markerDespawned = false;
private _markerPos = getMarkerPos _marker;
_group setVariable ["DestinationMarker", _marker];

if (spawner getVariable _marker != 2) then
{
	{
        deleteWaypoint _x
    } forEach (waypoints _group);
	private _wp = _group addWaypoint [(getMarkerPos _marker), 0];
	_wp setWaypointType "MOVE";
    _wp setWaypointCompletionRadius 15;
    _wp setWaypointStatements
    [
        "true",
        "
            private _units = (thisList select {alive _x});
            private _marker = (group this) getVariable 'DestinationMarker';
            [_marker, [['', [], _units]], teamPlayer] call A3A_fnc_addSpawnedToGarrison;
            [_marker, _units] spawn
            {
                sleep 5;
                _this call A3A_fnc_manStaticsOnArrival;
            };
        "
    ];

	waitUntil
    {
        sleep 5;
        //Wait till marker changes its owner
        (!(sidesX getVariable [_marker,sideUnknown] == teamPlayer)) ||
        //Or till group arrived
        ((leader _group) distance2D _markerPos) < 50 ||
        //Or till marker despawned
        (spawner getVariable _marker) == 2
    };
	if (!(sidesX getVariable [_marker,sideUnknown] == teamPlayer)) then
    {
        _markerChanged = true;
    };
    if ((spawner getVariable _marker) == 2) then
    {
        _markerDespawned = true;
    };
};

if (_markerChanged) then
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
                }
            ];
		};
	} forEach _units;
	theBoss hcSetGroup [_group];
	(format ["Group %1 is back to HC control because the zone which they should garrison has been lost",groupID _group]) remoteExec ["hint", theBoss];
}
else
{
    if (_markerDespawned) then
    {
        //Outpost despawned, warp units
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
    };
};
