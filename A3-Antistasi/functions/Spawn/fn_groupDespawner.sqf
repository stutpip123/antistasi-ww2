params ["_group"];

/*  Handles the despawn of all groups

    Execution on: Server or HC

    Scope: Internal

    Params:
        _group: GROUP : The group, which despawn should be handled

    Returns:
        Nothing
*/

private _side = side _group;
private _marker = (leader _group) getVariable ["UnitMarker", ""];

if(_marker != "") then
{
    //Units are stationated on a marker somewhere, this command is only executed when the marker despawns
    //So we are sure that the units in the group can be despawned now
    //They can't be further away then 500 meters anyways and the next enemy is more then 1300 meters away
    {
        
        deleteVehicle _x;
    } forEach (units _group);
}
else
{
    //Unit is somewhere else, checking for all spawner, whether they are closer than spawn distance
    //If none found, despawn directly, otherwise wait till they are gone
    //No need to force despawn, there is no reason that they would spawn again (no mission despawns and spawns again and so on)
    if((playerSpawner + occupantsSpawner + invadersSpawner) findIf {(_x distance2D (leader _group)) < distanceSPWN} != -1) then
    {
        waitUntil
        {
            sleep 5;
            (playerSpawner + occupantsSpawner + invadersSpawner) findIf {(_x distance2D (leader _group)) < distanceSPWN} != -1
        };
    };
    {
        deleteVehicle _x;
    } forEach (units _group);
};
