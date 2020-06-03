#define CIV_HELI        0
#define MIL_HELI        1
#define JET             2


params ["_vehicle"];

//If vehicle already has an airspace control script, exit here
if(_vehicle getVariable ["airspaceControl", false]) exitWith {};

_vehicle setVariable ["airspaceControl", true, true];

private _airType = -1;
if(_vehicle isKindOf "Helicopter") then
{
    if(typeOf _vehicle == civHeli) then
    {
        _airType = CIV_HELI;
    }
    else
    {
        _airType = MIL_HELI;
    };
}
else
{
    _airType = JET;
};

//Select height and range for outposts, numbers are values for [CIV_HELI, MIL_HELI, JET]
private _outpostDetectionRange = [300, 500, 750] select _airType;
private _outpostDetectionHeight = [150, 250, 500] select _airType;

//Select height and range for outposts, numbers are values for [CIV_HELI, MIL_HELI, JET]
private _airportDetectionRange = [500, 750, 1500] select _airType;
private _airportDetectionHeight = [500, 500, 2500] select _airType;

//Selecting height and distance warning for outposts
private _outpostWarningRange = 500;
private _outpostWarningHeight = 250;

//Selecting height and distance warning for airports
private _airportWarningRange = 750;
private _airportWarningHeight = 750;

private _inWarningRangeOutpost = [];
private _inDetectionRangeOutpost = [];
private _inWarningRangeAirport = [];
private _inDetectionRangeAirport = [];
private _vehicleIsUndercover = false;
private _supportCallAt = -1;
private _vehPos = [];

while {!(isNull _vehicle) && {alive _vehicle && {count (crew _vehicle) != 0}}} do
{
    _vehicleIsUndercover = captive ((crew _vehicle) select 0);
    _vehPos = getPos _vehicle;

    private _enemyAirports = airportsX select {sidesX getVariable [_x, sideUnknown] != teamPlayer};
    private _enemyOutposts = outposts select {sidesX getVariable [_x, sideUnknown] != teamPlayer};

    if(_vehicleIsUndercover && {_vehicle getVariable ["NoFlyZoneDetected", ""] == ""}) then
    {
        //Warnings will be issued before undercover is broken
        private _airportsInWarningRange = _enemyAirports select
        {
            private _markerPos = getMarkerPos _x;
            private _heightDiff = (_vehPos select 2) - (_markerPos select 2);
            _heightDiff < _airportWarningHeight &&
            {_markerPos distance2D _vehPos < _airportWarningRange}
        };

        private _newAirports = _airportsInWarningRange - _inWarningRangeAirport;
        _inWarningRangeAirport = _airportsInWarningRange;

        private _outpostsInWarningRange = _enemyOutposts select
        {
            private _markerPos = getMarkerPos _x;
            private _heightDiff = (_vehPos select 2) - (_markerPos select 2);
            _heightDiff < _outpostWarningHeight &&
            {_markerPos distance2D _vehPos < _outpostWarningRange}
        };

        private _newOutposts = _outpostsInWarningRange - _inWarningRangeOutpost;
        _inWarningRangeOutpost = _outpostsInWarningRange;

        {
            //Assuming you only get a single one each second, need to split it otherwise
            private _warningText = format ["Unidentified helicopter<br/><br/>You are closing in on the airspace of %1.<br/><br/> Change your course or we will take defensive actions!", [_x] call A3A_fnc_localizar];
            ["Undercover", _warningText] remoteExec ["A3A_fnc_customHint", (crew _vehicle)];
        } forEach _newAirports + _newOutposts;

        {
            private _markerPos = getMarkerPos _x;
            private _heightDiff = (_vehPos select 2) - (_markerPos select 2);
            if(_heightDiff < _airportDetectionHeight && {_markerPos distance2D _vehPos < _airportDetectionRange}) exitWith
            {
                //Too close to airport, break undercover and let the other routine handle it
                _vehicle setVariable ["NoFlyZoneDetected", _x, true];
                _vehicleIsUndercover = false;
            };
        } forEach _inWarningRangeAirport;

        {
            private _markerPos = getMarkerPos _x;
            private _heightDiff = (_vehPos select 2) - (_markerPos select 2);
            if(_heightDiff < _outpostDetectionHeight && {_markerPos distance2D _vehPos < _outpostDetectionRange}) exitWith
            {
                //Too close to airport, break undercover and let the other routine handle it
                _vehicle setVariable ["NoFlyZoneDetected", _x, true];
                _vehicleIsUndercover = false;
            };
        } forEach _inWarningRangeOutpost;
    }
    else
    {
        //Vehicles will be attacked instantly once detected
        private _airportsInRange = _enemyAirports select
        {
            private _markerPos = getMarkerPos _x;
            private _heightDiff = (_vehPos select 2) - (_markerPos select 2);
            _heightDiff < _airportDetectionHeight &&
            {_markerPos distance2D _vehPos < _airportDetectionRange}
        };

        private _newAirports = _airportsInRange - _inDetectionRangeAirport;
        _inDetectionRangeAirport = _airportsInRange;

        if(count _newAirports > 0) then
        {
            //Vehicle detected by another airport
            //Call support here, not in this branch currently
            _supportCallAt = time + 300;
        }
        else
        {
            //No airport near, to save performance we only check outpost if they would be able to send support
            if(time > _supportCallAt) then
            {
                private _outpostsInRange = _enemyOutposts select
                {
                    private _markerPos = getMarkerPos _x;
                    private _heightDiff = (_vehPos select 2) - (_markerPos select 2);
                    _heightDiff < _outpostDetectionHeight &&
                    {_markerPos distance2D _vehPos < _outpostDetectionRange}
                };

                private _newOutposts = _outpostsInRange - _inDetectionRangeOutpost;
                _inDetectionRangeOutpost = _outpostsInRange;

                if(count _newOutposts > 0) then
                {
                    //Vehicle detected by another outpost, call support if possible
                    //Call support here, not in this branch currently
                    _supportCallAt = time + 300;
                };
            };
        };
    };
    sleep 1;
};

_vehicle setVariable ["airspaceControl", nil, true];
