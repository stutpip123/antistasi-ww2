params ["_marker", "_staticGroup", "_spawnParameter", "_allowedAt", "_index"];

private _side = side _staticGroup;
private _staticObject = objNull;

if(_side == teamPlayer) then
{
    _spawnParameter params ["_spawnPos", "_spawnDir", "_spawnType"];
    _staticObject = createVehicle [_spawnType, _spawnPos, [], 0, "CAN_COLLIDE"];
    _staticObject setDir _spawnDir;
    _staticObject setVariable ["StaticMarker", _marker];
}
else
{
    //Check if static has been killed and is not replenished by now
    if([_allowedAt] call A3A_fnc_unitAvailable) then
    {
        if(_spawnParameter isEqualType -1) then
        {
            _spawnParameter = [_marker, "Static"] call A3A_fnc_findSpawnPosition;
        };

        private _spawnPos = _spawnParameter select 0;
        private _nearestBuilding = nearestObject [_spawnPos, "HouseBase"];

        [4, format ["nearestBuilding is %1", (typeOf _nearestBuilding)], _fileName] call A3A_fnc_log;

        if(!(_nearestBuilding isKindOf "Ruins")) then
        {
            private _staticType = _spawnParameter select 2;
            private _crew = if(_side == Occupants) then {staticCrewOccupants} else {staticCrewInvaders};
            private _static = "";
            switch (_staticType) do
            {
                case ("MG"):
                {
                    _static = if(_side == Occupants) then {NATOMG} else {CSATMG};
                };
                case ("AA"):
                {
                    _static = if(_side == Occupants) then {staticAAOccupants} else {staticAAInvaders};
                };
                case ("AT"):
                {
                    _static = if(_side == Occupants) then {staticATOccupants} else {staticATInvaders};
                };
            };
            _staticObject = createVehicle [_static, _spawnPos, [], 0, "CAN_COLLIDE"];
            _staticObject setDir (_spawnParameter select 1);
            _staticObject setVariable ["StaticIndex", _index];
            _staticObject setVariable ["StaticMarker", _marker];
            _staticObject addEventHandler
            [
                "Killed",
                {
                    private _static = _this select 0;
                    private _marker = _static getVariable "StaticMarker";
                    private _index = _static getVariable "StaticIndex";
                    ["Static", _marker, _index, 60] call A3A_fnc_addTimeoutForUnit;
                }
            ];

            private _gunner =  _staticGroup createUnit [_crew, getMarkerPos _marker, [], 5, "NONE"];
            [_gunner, _marker] call A3A_fnc_NATOinit;
            _gunner moveInGunner _staticObject;

            _gunner setVariable ["StaticIndex", _index];
            _gunner setVariable ["StaticMarker", _marker];
            _gunner addEventHandler
            [
                "Killed",
                {
                    private _gunner = _this select 0;
                    private _marker = _gunner getVariable "StaticMarker";
                    private _index = _gunner getVariable "StaticIndex";
                    ["Static", _marker, _index, 30] call A3A_fnc_addTimeoutForUnit;
                }
            ];
        };
    };
};
