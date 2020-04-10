/*  Handles the info about sites of the map
*   Params:
*       Nothing
*
*   Returns:
*       Nothing
*/

positionTel = [];

private _popFIA = 0;
private _popAAF = 0;
private _popCSAT = 0;
private _pop = 0;
{
    private _data = server getVariable _x;
    _data params ["_numCiv", "_unused", "_prestigeOPFOR", "_prestigeBLUFOR"];
    _popFIA = _popFIA + (_numCiv * (_prestigeBLUFOR / 100));
    _popAAF = _popAAF + (_numCiv * (_prestigeOPFOR / 100));
    _pop = _pop + _numCiv;
    if (_x in destroyedSites) then
    {
        _popCSAT = _popCSAT + _numCIV
    };
} forEach citiesX;

_popFIA = round _popFIA;
_popAAF = round _popAAF;
["City Information", format ["%7<br/><br/>Total pop: %1<br/>%6 Support: %2<br/>%5 Support: %3 <br/><br/>Murdered Pop: %4<br/><br/>Click on the zone",_pop, _popFIA, _popAAF, _popCSAT,nameOccupants,nameTeamPlayer,worldName]] call A3A_fnc_customHint;

if (!visibleMap) then {openMap true};

onMapSingleClick "positionTel = _pos;";


//waitUntil {sleep 1; (count positionTel > 0) or (not visiblemap)};
while {visibleMap} do
{
	sleep 1;
	if (count positionTel > 0) then
	{
		private _positionTel = positionTel;
		private _marker = [markersX, _positionTel] call BIS_Fnc_nearestPosition;
		private _text = "Click on the zone";
        private _side = sidesX getVariable _marker;
		private _nameOwner = if (_side == teamPlayer) then {nameTeamPlayer} else {if (_side == Occupants) then {nameOccupants} else {nameInvaders}};

        switch (true) do
        {
            case (_marker == "Synd_HQ"):
            {
                _text = format ["%2 HQ%1", [_marker] call A3A_fnc_garrisonInfo, nameTeamPlayer];
            };
            case (_marker in citiesX):
            {
                private _data = server getVariable _marker;
                _data params ["_numCiv", "_unused", "_prestigeOPFOR", "_prestigeBLUFOR"];

    			private _influence = [_marker] call A3A_fnc_getSideRadioTowerInfluence;
    			_text = format ["%1\n\nPop %2\n%6 Support: %3 %5\n%7 Support: %4 %5",[_marker,false] call A3A_fnc_location,_numCiv,_prestigeOPFOR,_prestigeBLUFOR,"%",nameOccupants,nameTeamPlayer];
    			private _result = "NONE";
    			switch (_influence) do
    			{
    				case teamPlayer:{_result = nameTeamPlayer};
    				case Occupants: {_result = nameOccupants};
    				case Invaders:  {_result = nameInvaders};
    			};
    			_text = format ["%1\nInfluence: %2",_text,_result];
    			if (_side == teamPlayer) then
                {
                    _text = format ["%1\n%2",_text,[_marker] call A3A_fnc_garrisonInfo]
                };
            };
            case (_marker in outpostsFIA):
            {
                if (isOnRoad (getMarkerPos _marker)) then
    			{
    				_text = format ["%2 Roadblock%1",[_marker] call A3A_fnc_garrisonInfo,_nameOwner];
    			}
    			else
    			{
    				_text = format ["%1 Watchpost",_nameOwner];
    			};
            };
            default
            {
                private _type = "";
                switch (true) do
                {

                    case (_marker in seaports):
                    {
                        _type = "Seaport";
                    };
                    case (_marker in airportsX):
                    {
                        _type = "Airport";
                    };
                    case (_marker in factories):
                    {
                        _type = "Factory";
                    };
                    case (_marker in resourcesX):
                    {
                        _type = "Resource";
                    };
                    default
                    {
                        _type = "Outpost";
                    };
                };
                _text = format ["%1 %2", _nameOwner, _type];
                if(_side != teamPlayer) then
                {
                    private _garrisonRatio = [_marker] call A3A_fnc_getGarrisonRatio;
                    private _garrisonStatus = "Decimated";
                    if(_garrisonRatio > 0.7) then
                    {
                        _garrisonStatus = "Good";
                    }
                    else
                    {
                        if(_garrisonRatio > 0.3) then
                        {
                            _garrisonStatus = "Weakened";
                        };
                    };
                    _text = format ["%1\nGarrison: %2",_text, _garrisonStatus];
                }
                else
                {
                    _text = format ["%1%2", _text, [_marker] call A3A_fnc_garrisonInfo];
                };
            };
        };
        if (_marker in destroyedSites) then
        {
            _text = format ["%1\nDESTROYED",_text]
        };
		["City Information", format ["%1",_text]] call A3A_fnc_customHint;
	};
	positionTel = [];
};
onMapSingleClick "";
