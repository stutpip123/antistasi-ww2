params ["_unit", "_player"];

/*  The action of interrogating a surrendered unit.
*   Params:
*       _unit : OBJECT : The unit which will be interrogated
*       _player : OBJECT : The unit which is interrogating
*
*   Returns:
*       Nothing
*/

// Remove interrogate action but leave release/recruit actions
{
	private _actparams = _unit actionParams _x;
	if (_actparams select 0 == "Interrogate") then
    {
        _unit removeAction _x
    };
} forEach (actionIDs _unit);

if (!alive _unit) exitWith {};
if (_unit getVariable ["interrogated", false]) exitWith {};
_unit setVariable ["interrogated", true, true];

_player globalChat "You imperialist! Tell me what you know!";
private _chance = 0;
private _side = side (group _unit);
if (_side == Occupants) then
{
	_chance = 100 - prestigeNATO;
}
else
{
	_chance = 100 - prestigeCSAT;
};

_chance = _chance + 20;

sleep 5;

if ((round (random 100)) < _chance) then
{
    if((typeOf _unit) in squadLeaders) then
    {
        if(_unit getVariable ["hasIntel", false]) then
        {
            _unit globalChat "Okay, I tell you what I know";
            _unit setVariable ["hasIntel", false, true];
            ["Small", _side] spawn A3A_fnc_selectIntel;
        }
        else
        {
            _unit globalChat "I would, but I don't know anything";
        };
    }
    else
    {
        _unit globalChat "I would, but I am no squadleader, so I don't know anything";
    };
}
else
{
	_unit globalChat "Screw you, I am not telling anything!";
};
