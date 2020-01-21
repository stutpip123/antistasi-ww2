params ["_marker", "_groups"];

private _fileName = "markerAlert";
private _isAlerted = false;
while {spawner getVariable _marker != 0} do
{
    sleep 1;
    if(!_isAlerted) then
    {
        {
            private _state = behaviour (leader _x);
            if(_state == "COMBAT") exitWith
            {
                [
                    3,
                    format ["Group on %1 has state %2, get in!", _marker, _state],
                    _fileName
                ] call A3A_fnc_log;
                _isAlerted = true;
                {
                    //Appearently some unit detected enemies, man the vehicles, unleash hell!!!
                    if(!(assignedVehicle (leader _x) isEqualTo objNull)) then
                    {
                        //The groups has an assigned vehicle, get in
                        (assignedVehicle (leader _x)) lock 0;
                        (units _x) orderGetIn true;
                        (leader _x) addEventHandler
                        [
                            "GetInMan",
                            {
                                //Search for attacker, fire and engage at will
                                params ["_unit"];
                                [(group _unit)] spawn
                                {
                                    private _group = _this select 0;
                                    sleep 5;
                                    private _waypoint = _group addWaypoint [getPos (leader _group), 50];
                                    _waypoint setWaypointType "SAD";
                                    _group setCurrentWaypoint _waypoint;
                                    _group setCombatMode "RED";
                                };
                            }
                        ];
                    };
                } forEach _groups;
            };
            if(_isAlerted) exitWith {};
        } forEach _groups;
    };
    if(_isAlerted) exitWith {};
    if(spawner getVariable _marker != 2) then
    {
        waitUntil {sleep 5; (spawner getVariable _marker) != 1};
    };
};
