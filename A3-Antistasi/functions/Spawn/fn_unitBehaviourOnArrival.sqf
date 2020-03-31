params ["_unit", "_joinPos"];

if !(isNull objectParent _unit) then
{
    doGetOut _unit;
};

private _group = group _unit;
if (_group getVariable ["isCrewGroup", false]) then
{
    if (_group getVariable ["isInVehicle", false]) then
    {
        //Unit will move into the vehicle
        [_unit] orderGetIn true;
    }
    else
    {
        //Update the vehicle state
        _group setVariable ["shouldCrewVehicle", [_group] call A3A_fnc_shouldVehicleBeManned, true];
    };
};

//Check if group is on standby, if so join, if not upsmon will do whatever needed
if (_group getVariable ["isDisabled", false]) then
{
    //Group is disabled and waiting there
    [_unit] doMove (leader _group);
    waitUntil
    {
        sleep 1;
        !(_group getVariable ["isDisabled", false]) ||
        {(_unit distance2D (leader _group)) < 10}
    };
    if(_group getVariable ["isDisabled", false]) then
    {
        doStop _unit;
        _unit disableAI "ALL";
        _unit enableSimulationGlobal false;
    };
};

if(_joinPos == 0) then
{
    _group selectLeader _unit;
};
