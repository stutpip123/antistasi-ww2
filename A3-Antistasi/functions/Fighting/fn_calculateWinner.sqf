#define NOT_FINISHED        -1
#define PLAYER_WON          0
#define OCCUPANTS_WON       1
#define INVADERS_WON        2
#define NO_WINNER           3

params ["_data"];
private _fileName = "fn_calculateWinner";

if(simulationLevel == 0) exitWith
{
    private _unitCount = [0, 0, 0];

    for "_side" from 0 to 2 do
    {
        private _count = 0;
        private _allUnits = _data select _side;
        for "_kind" from 0 to 2 do
        {
            _count = _count + (count (_allUnits select _kind));
        };
        _unitCount set [_side, _count];
    };

    [3, format ["Remaining units per side are %1", _unitCount], _fileName] call A3A_fnc_log;

    _winner = NOT_FINISHED;
    _playersHaveNoUnits = ((_unitCount select 0) == 0);
    _occupantsHaveNoUnits = ((_unitCount select 1) == 0);
    _invadersHaveNoUnits = ((_unitCount select 2) == 0);
    if (_playersHaveNoUnits) then
    {
        if(_occupantsHaveNoUnits) then
        {
            if(_invadersHaveNoUnits) then
            {
                //All units are dead, war never changes
                _winner = NO_WINNER
            }
            else
            {
                //Invaders have the last remaining units
                _winner = INVADERS_WON;
            };
        }
        else
        {
            if(_invadersHaveNoUnits) then
            {
                //Occupants have the last remaining units
                _winner = OCCUPANTS_WON
            }
            else
            {
                //Occupants and invaders have units left
                _winner = NOT_FINISHED;
            };
        };
    }
    else
    {
        if(_occupantsHaveNoUnits && {_invadersHaveNoUnits}) then
        {
            //Teamplayer has won this fight, no units of other sides remaining
            _winner = PLAYER_WON;
        }
        else
        {
            //At least one other side has unit left, continue fight
            _winner = NOT_FINISHED;
        };
    };

    [3, format ["Result is %1", _winner], _fileName] call A3A_fnc_log;
    _winner;
};
