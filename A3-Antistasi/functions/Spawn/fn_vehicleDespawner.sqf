params ["_vehicle"];

/*  Handles despawn of vehicles which are stolen from outpost or spawned by rebels or convoys

    Execution on: Server or HC

    Scope: Internal

    Params:
        _vehicle : OBJECT : The vehicle which the despawner should handle

    Returns:
        Nothing
*/

private _shouldDespawn = false;
while {!_shouldDespawn} do
{
    waitUntil
    {
        sleep 60;
        (isNil "_vehicle") ||
        {!alive _vehicle ||
        {count ((crew _vehicle) select {alive _x}) == 0}}
    };

    //Check if the vehicle has been destroyed or deleted by some other script
    if (isNil "_vehicle" || {!alive _vehicle}) exitWith {};

    waitUntil
    {
        sleep 10;
        (isNil "_vehicle") ||
        {!alive _vehicle ||
        {count ((crew _vehicle) select {alive _x}) != 0 ||
        {allPlayers findIf {_x distance2D _vehicle < distanceSPWN} == -1}}}
    };

    //Check if the vehicle has been destroyed or deleted by some other script
    if (isNil "_vehicle" || {!alive _vehicle}) exitWith {};

    //No unit in crew, meaning no unit close, despawn
    if(count ((crew _vehicle) select {alive _x}) == 0) then
    {
        _shouldDespawn = true;
    };
};

//Vehicle needs to be despawned by this script, despawning now
if(_shouldDespawn) then
{
    private _vehicleType = typeOf _vehicle;
    if(_vehicle in reportedVehs) then
    {
        reportedVehs = reportedVehs - [_vehicle]
    };
    if (!(_vehicleType in arrayCivVeh)) then
    {
        //Only put on marker if the nearest marker is closer than 500 meters
        private _marker = [markersX, getPos _vehicle] call BIS_fnc_nearestPosition;
        if((getMarkerPos _marker) distance2D _vehicle < 500) then
        {
            [_marker, [[_vehicleType, [], []]], civilian] spawn A3A_fnc_addToGarrison;
            if(sidesX getVariable _marker == teamPlayer) then
            {
                private _markerName = [_marker, false] call A3A_fnc_localizar;
                private _vehicleName = getText (configFile >> "CfgVehicles" >> _vehicleType >> "displayName");
                [petros, "sideChat", format ["Our garrison at %1 has recovered a %2. It is now stationated there.", _markerName, _vehicleName]];
            };
        };
    };
    deleteVehicle _vehicle;
};
