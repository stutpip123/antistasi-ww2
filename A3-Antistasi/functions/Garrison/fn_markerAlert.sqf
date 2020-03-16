#define SPAWNED         0
#define ON_STANDBY      1
#define DESPAWNED       2

params ["_marker"];

private _fileName = "markerAlert";
private _isAlerted = false;

[
    3,
    format ["Starting marker alert for %1", _marker],
    _fileName
] call A3A_fnc_log;

while {spawner getVariable _marker != DESPAWNED} do
{
    sleep 1;
    private _groups = [_marker, "Groups"] call A3A_fnc_getSpawnedArray;
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
                    //Enemies detected (or faulty damage), activate the units which are deactivated
                    if(_x getVariable ["isDisabled", false]) then
                    {
                        _x setVariable ["isDisabled", false, true];
                        //Reactivate all units of the group
                        {
                            _x enableSimulation true;
                            _x enableAI "ALL";
                        } forEach (units _x);
                        (units _x) doFollow (leader _x);

                        if !(_x getVariable ["isCrewGroup", false]) then
                        {
                            //Combat groups on marker, activate combat mode
                            [leader _x, (leader _x) getVariable "UnitMarker", "COMBAT", "SPAWNED", "ORIGINAL", "NOFOLLOW", "NOVEH2"] execVM "scripts\UPSMON.sqf";
                        };

                        //[_x] call A3A_fnc_abortAmbientAnims; //Currently not needed as animations are not used yet (File does not exist neither)
                        //_x setBehaviour "COMBAT"; //That seems to be handled by upsmon, I leave it here for vcom conversion
                    };

                    if (_x getVariable ["shouldCrewVehicle", false]) then
                    {
                        if(_x getVariable ["isInVehicle", false]) then
                        {
                            //Unit are already sitting in the vehicle, activate upsmon
                            [leader _x, (leader _x) getVariable "UnitMarker", "COMBAT", "SPAWNED", "ORIGINAL", "NOFOLLOW"] execVM "scripts\UPSMON.sqf";
                        }
                        else
                        {
                            //Unlock vehicle, get crew in
                            (assignedVehicle (leader _x)) lock 0;
                            (units _x) orderGetIn true;

                            (assignedVehicle (leader _x)) addEventHandler
                            [
                                "GetIn",
                                {
                                    private _unit = _this select 0;
                                    private _group = group _unit;
                                    if(side _group != teamPlayer) then
                                    {
                                        if ((units _group) findIf {isNull (objectParent _x)} == -1) then
                                        {
                                            //All units managed to get into the vehicle, roll out
                                            [leader _group, (leader _group) getVariable "UnitMarker", "COMBAT", "SPAWNED", "ORIGINAL"] execVM "scripts\UPSMON.sqf";
                                        };
                                    };
                                }
                            ];


                            {
                                _x addEventHandler
                                [
                                    "Killed",
                                    {
                                        private _unit = _this select 0;
                                        private _group = group _unit;

                                        //Can't command the vehicle with one crew units missing, get out and defend from the ground
                                        (units _group) orderGetIn false;
                                        [leader _group, (leader _group) getVariable "UnitMarker", "COMBAT", "SPAWNED", "ORIGINAL", "NOFOLLOW", "NOVEH2", "NOWP3"] execVM "scripts\UPSMON.sqf";
                                    }
                                ];
                            } forEach (units _x);
                        };

                    };
                } forEach _groups;
            };
            if(_isAlerted) exitWith {};
        } forEach _groups;
    };
    if(_isAlerted) exitWith {};
    if(spawner getVariable _marker != SPAWNED) then
    {
        waitUntil {sleep 5; (spawner getVariable _marker) != ON_STANDBY};
    };
};

[
    3,
    format ["Marker alert on %1 ended", _marker],
    _fileName
] call A3A_fnc_log;
