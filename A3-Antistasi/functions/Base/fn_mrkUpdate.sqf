params ["_marker"];

private _side = sidesX getVariable _marker;
private _mrkD = format ["Dum%1",_marker];
private _text = "";

if (_side == teamPlayer) then
{
    private _garrisonCount = [([_marker] call A3A_fnc_getOver), true] call A3A_fnc_countGarrison;
	_text = format [": %1", _garrisonCount];

	_mrkD setMarkerColor colorTeamPlayer;
    switch (true) do
    {
        case (_marker in airportsX):
        {
            _text = format ["%2 Airbase%1", _text, nameTeamPlayer];
    		[_mrkD,format ["%1 Airbase", nameTeamPlayer]] remoteExec ["setMarkerTextLocal", [Occupants,Invaders], true];
    		if (markerType _mrkD != "flag_Syndicat") then {_mrkD setMarkerType "flag_Syndicat"};
            _mrkD setMarkerColor "Default";
        };
        case (_marker in resourcesX):
        {
            _text = format ["Resources%1",_text];
        };
        case (_marker in factories):
        {
            _text = format ["Factory%1",_text];
        };
        case (_marker in seaports):
        {
            _text = format ["Sea Port%1",_text]
        };
        case (_marker in outposts):
        {
            _text = format ["%2 Outpost%1", _text, nameTeamPlayer];
			[_mrkD,format ["%1 Outpost", nameTeamPlayer]] remoteExec ["setMarkerTextLocal", [Occupants,Invaders], true];
        };
    };
	[_mrkD,_text] remoteExec ["setMarkerTextLocal",[teamPlayer,civilian],true];
}
else
{
    private _nameOwner = if(_side == Occupants) then {nameOccupants} else {nameInvaders};
    private _colorOwner = if (_side == Occupants) then {colorOccupants} else {colorInvaders};
    private _flag = if (_side == Occupants) then {flagNATOmrk} else {flagCSATmrk};

    _mrkD setMarkerColor _colorOwner;
    switch (true) do
    {
        case (_marker in airportsX):
        {
            _mrkD setMarkerText format ["%1 Airbase", _nameOwner];
			_mrkD setMarkerType _flag;
            _mrkD setMarkerColor "Default";
        };
        case (_marker in resourcesX):
    	{
    		_mrkD setMarkerText "Resources";
    	};
        case (_marker in factories):
    	{
			_mrkD setMarkerText "Factory";
    	};
        case (_marker in seaports):
        {
            _mrkD setMarkerText "Sea Port";
        };
        case (_marker in outposts):
        {
            _mrkD setMarkerText format ["%1 Outpost", _nameOwner];
            _mrkD setMarkerColor _colorOwner;
        };
    };
};
