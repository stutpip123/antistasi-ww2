#define AIR         0
#define LAND_CONVOY 1   //LAND is an internal command and can't be used
#define FAST_ROPE   2
#define AMPHIBIOUS  3
#define LAND_REQ    4
#define AIR_REQ     5

params ["_vehicle", "_types", "_isRequested"];

if(_types isEqualTo []) exitWith {false};

private _result = false;

if(AIR in _types || {_isRequested && (AIR_REQ in _types)}) then
{
    _result = _vehicle isKindOf "Air";
};
if(LAND_CONVOY in _types || {_isRequested && (LAND_REQ in _types)}) then
{
    _result = _result || (_vehicle isKindOf "LandVehicle");
};
if(FAST_ROPE in _types) then
{
    _result = _result || (_vehicle in vehFastRope);
};
if(LAND_CONVOY in _types) then
{
    //Not yet, can be down once the dev team allows it
};

_result;
