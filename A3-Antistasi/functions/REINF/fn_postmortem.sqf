params ["_victim"];

/*  Handles the despawn and cleanup of dead units
*   Params:
*       _victim : OBJECT : The dead unit
*
*   Returns:
*       Nothing
*/

private _group = group _victim;
if (!isNull _group) then
{
	if (((units _group) findIf {alive _x}) == -1) then
    {
        deleteGroup _group;
    };
}
else
{
	if (_victim in staticsToSave) then
    {
        staticsToSave = staticsToSave - [_victim];
        publicVariable "staticsToSave";
    };
};

sleep cleantime;
deleteVehicle _victim;
