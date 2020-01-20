params ["_marker", "_groups"];

private _isAlerted = false;
while {spawner getVariable _marker != 0} do
{
    sleep 1;
    if(!_isAlerted) then
    {
        {
            private _state = behaviour (leader _x);
            if(_state != "SAFE") exitWith
            {
                _isAlerted = true;
                //Appearently some unit detected enemies, man the vehicles, unleash hell!!!
                if(!(assignedVehicle (leader _x) isEqualTo objNull)) then
                {
                    //The groups has an assigned vehicle, get in
                    (units _x) orderGetIn true;
                    (leader _x) addEventHandler
                    [
                        "GetInMan",
                        {
                            //Search for attacker, fire and engage at will
                            params ["_unit"];
                            (group _unit) addWaypoint [getPos _unit, 50, 0, "Seek attackers"];
                            (group _unit) setCombatMode "RED";
                        }
                    ];
                };
            };
        } forEach _groups;
    };
    if(_isAlerted) exitWith {};
    if(spawner getVariable _marker != 2) then
    {
        waitUntil {sleep 5; (spawner getVariable _marker) != 1};
    };
};
