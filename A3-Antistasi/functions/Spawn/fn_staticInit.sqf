params ["_static", "_marker", "_side", ["_index", -1]];

_static setVariable ["StaticMarker", _marker, true];
_static setVariable ["StaticSide", _side, true];
_static setCenterOfMass [(getCenterOfMass _static) vectorAdd [0, 0, -1], 0];

private _staticType = typeOf _static;

if(_side == teamPlayer) then
{
    _static addEventHandler
    [
        "Killed",
        {
            private _static = _this select 0;
            [_static, "remove"] remoteExec ["A3A_fnc_flagAction", [teamPlayer, civilian], _static];
            [_static] spawn A3A_fnc_postmortem;
        }
    ];

    if(_staticType == SDKMortar) then
    {
        _static addEventHandler
        [
            "Fired",
            {
                private _mortar = _this select 0;
                private _detectionData = _mortar getVariable ["detection", [getPos _mortar,0]];
                private _position = getPos _mortar;
                private _chance = _detectionData select 1;
                //Check if mortar has been moved
                if ((_position distance (_detectionData select 0)) < 300) then
                {
                    _chance = _chance + 2;
                }
                else
                {
                    _chance = 0;
                };
                if (random 100 < _chance) then
                {
                    {
                        if (side _x != teamPlayer) then
                        {
                            {
                                _x reveal [_mortar,4];
                            } forEach (units _x);
                        };
                    } forEach allGroups;
                    if (_mortar distance posHQ < 300) then
                    {
                        if (!(["DEF_HQ"] call BIS_fnc_taskExists)) then
                        {
                            private _Leader = leader (gunner _mortar);
                            if (!isPlayer _leader) then
                            {
                                [[],"A3A_fnc_attackHQ"] remoteExec ["A3A_fnc_scheduler",2];
                            }
                            else
                            {
                                if ([_leader] call A3A_fnc_isMember) then {[[],"A3A_fnc_attackHQ"] remoteExec ["A3A_fnc_scheduler",2]};
                            };
                        };
                    }
                    else
                    {
                        private _bases = airportsX select {(getMarkerPos _x distance _mortar < distanceForAirAttack) && ([_x,true] call A3A_fnc_airportCanAttack) && (sidesX getVariable [_x,sideUnknown] != teamPlayer)};
                        if (count _bases > 0) then
                        {
                            private _base = [_bases,_position] call BIS_fnc_nearestPosition;
                            private _baseSide = sidesX getVariable [_base,sideUnknown];
                            [[getPosASL _mortar,_baseSide,"Normal",false],"A3A_fnc_patrolCA"] remoteExec ["A3A_fnc_scheduler",2];
                        };
                    };
                };
                _mortar setVariable ["detection",[_position,_chance]];
            }
        ];
    };
}
else
{
    _static setVariable ["StaticIndex", _index];

    if (activeGREF && ((_staticType == staticATteamPlayer) || (_staticType == staticAAteamPlayer))) then
    {
        [_static,"moveS"] remoteExec ["A3A_fnc_flagaction",[teamPlayer,civilian],_static];
    }
    else
    {
        [_static,"steal"] remoteExec ["A3A_fnc_flagaction",[teamPlayer,civilian],_static];
    };

    if((_staticType == NATOMortar) || (_staticType == CSATMortar)) then
    {
        [_static] execVM "scripts\UPSMON\MON_artillery_add.sqf";//TODO need delete UPSMON link
    };

    _static addEventHandler
    [
        "Killed",
        {
            private _static = _this select 0;
            private _marker = _static getVariable "StaticMarker";
            private _side = _static getVariable "StaticSide";
            if((sidesX getVariable _marker) != teamPlayer) then
            {
                private _index = _static getVariable "StaticIndex";
                ["Static", _marker, _index, 30 * (4 - skillMult), _side] call A3A_fnc_addTimeoutForUnit;
            };
            [_static] spawn A3A_fnc_postmortem;
        }
    ];
};

_static addEventHandler
[
    "GetIn",
    {
        params ["_static", "_role", "_unit"];
        if((side (group _unit) == teamPlayer) && (!isPlayer _unit)) then
        {
            [_unit, "SwitchGunner"] remoteExec ["A3A_fnc_flagAction", [teamPlayer, civilian], _unit];
            _static setVariable ["gunner", _unit, true];
        };
    }
];

_static addEventHandler
[
    "GetOut",
    {
        params ["_static", "_role", "_unit"];

        if(side (group _unit) == teamPlayer) then
        {
            if (isPlayer _unit) then
            {
                //Player left the static, reman it
                private _gunner = _static getVariable ["gunner", objNull];
                if(isNull _gunner || (!(alive _gunner))) then
                {
                    //Gunner died while player used it, or was never assigned
                    //TODO assign new gunner
                }
                else
                {
                    //Gunner needs to get in again
                    _gunner moveInGunner _static;
                };
            }
            else
            {
                //Unit left static due to whatever reason, remove action
                private _switchActionID = _static getVariable ["switchActionID", -1];
                if(_switchActionID != -1) then
                {
                    [_static, _switchActionID] remoteExec ["removeAction", [teamPlayer, civilian], _static];
                };
            };
        };
    }
];
