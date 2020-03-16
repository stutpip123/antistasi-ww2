params ["_preference"];

/*  Updates the preferences of the given array
*   Params:
*     _preference : ARRAY : the preferences array
*
*   Returns:
*     Nothing
*/

for "_i" from 0 to ((count _preference) - 1) do
{
    _data = _preference select _i;
    _vehicle = _data select 0;
    _cargo = _data select 2;

    //All possible land types LAND_TRUCK, LAND_START, LAND_LIGHT_UNARMED, LAND_LIGHT, LAND_LIGHT_ARMED, LAND_MEDIUM, LAND_APC, LAND_HEAVY, LAND_TANK, LAND_AIR
    //All possible heli types HELI_PATROL, HELI_LIGHT, HELI_TRANSPORT, HELI_HEAVY, HELI_ATTACK
    //All possible air types AIR_DRONE, AIR_GENERIC, AIR_ATTACK
    //All other types EMPTY

    _newVehicle = _vehicle;
    if(!(_vehicle in ["EMPTY", "LAND_TANK", "LAND_AIR", "HELI_ATTACK", "AIR_ATTACK"])) then
    {
        //Vehicle not fully upgraded, continue upgrading
        switch (_vehicle) do
        {
            //Update land vehicle
            case ("LAND_TRUCK") : {_newVehicle = "LAND_LIGHT_UNARMED";};
            case ("LAND_START") : {_newVehicle = "LAND_LIGHT";};
            case ("LAND_LIGHT_UNARMED") : {_newVehicle = "LAND_LIGHT_ARMED";};
            case ("LAND_LIGHT") : {_newVehicle = "LAND_LIGHT_ARMED";};
            case ("LAND_LIGHT_ARMED") : {_newVehicle = "LAND_MEDIUM";};
            case ("LAND_MEDIUM") : {_newVehicle = "LAND_APC";};
            case ("LAND_APC") : {_newVehicle = "LAND_HEAVY";};
            case ("LAND_HEAVY") : {_newVehicle = "LAND_TANK";};

            //Update air vehicle
            case ("HELI_PATROL") : {_newVehicle = "HELI_LIGHT";};
            case ("HELI_LIGHT") : {_newVehicle = "HELI_TRANSPORT";};
            case ("HELI_TRANSPORT") : {_newVehicle = "HELI_HEAVY";};
            case ("HELI_HEAVY") : {_newVehicle = "HELI_ATTACK";};

            //Update air vehicles
            case ("AIR_DRONE") : {_newVehicle = "AIR_GENERIC";};
            case ("AIR_GENERIC") : {_newVehicle = "AIR_ATTACK";};
        };
    };
    _data set [0, _newVehicle];

    //All possible cargo groups EMPTY, GROUP, SQUAD, AA, AT, SPECOPS
    _newCargo = _cargo;
    if(!(_cargo in ["EMPTY", "AA", "AT", "SPECOPS"])) then
    {
        if(_newVehicle in ["LAND_TRUCK", "LAND_START", "LAND_LIGHT_UNARMED", "LAND_LIGHT", "LAND_LIGHT_ARMED"]) then
        {
            _newCargo = "GROUP";
        };
        if(_newVehicle in ["LAND_MEDIUM", "LAND_APC", "LAND_HEAVY"]) then
        {
            _newCargo = "SQUAD";
        };
        if(_newVehicle in ["LAND_TANK"]) then
        {
            _newCargo = "AT";
        };
        if(_newVehicle in ["HELI_PATROL", "HELI_LIGHT", "HELI_ATTACK"]) then
        {
            _newCargo = "GROUP";
        };
        if(_newVehicle in ["HELI_TRANSPORT", "HELI_HEAVY"]) then
        {
            _newCargo = "SQUAD";
        };
    };
    _data set [2, _newCargo];
};
