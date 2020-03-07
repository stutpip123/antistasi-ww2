params ["_group", "_animType"];

//Deactivated this script for Spoffy <3
if(true) exitWith {};

switch (_animType) do
{
    case ("IDLE"):
    {
        //code
    };
    case ("VEHICLE"):
    {
        //code
    };
    case ("BRIEFING"):
    {
        private _squadleader = leader _group;
        _squadleader switchmove (selectRandom briefingAnims);
        _squadleader addEventHandler
        [
            "AnimDone",
            {
                private _unit = _this select 0;
                private _group = group _unit;
                if(_group getVariable ["isDisabled", false]) then
                {
                    _unit spawn
                    {
                        sleep (random 10);
                        _this switchmove (selectRandom briefingAnims);
                    };
                };
            }
        ];

        {
            _x switchmove (selectRandom listeningAnims);
            _x addEventHandler
            [
                "AnimDone",
                {
                    private _unit = _this select 0;
                    private _group = group _unit;
                    if(_group getVariable ["isDisabled", false]) then
                    {
                        _unit spawn
                        {
                            sleep (random 15);
                            _this switchmove (selectRandom listeningAnims);
                        };
                    };
                }
            ];
        } forEach ((units _group) - [_squadleader]);
    };
};
