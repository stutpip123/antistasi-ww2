private _fileName = "fn_fightLoop";
[2, "Fight loop started, combat now gets simulated!", _fileName] call A3A_fnc_log;

private _fightArray = [];
server setVariable ["fightArray", _fightArray];

fightLoopReady = true;

while {true} do
{
    sleep 1;
    if(count _fightArray > 0) then
    {
        //Next fight is up for battle
        if(((_fightArray select 0) select 1) < time) then
        {
            private _data = _fightArray deleteAt 0;
            private _number = _data select 0;
            [3, format ["Fight %1 is up for the next round!", _number], _fileName] call A3A_fnc_log;
            [_number] spawn A3A_fnc_fightRound;
        };
    };
};
