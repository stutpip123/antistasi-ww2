params ["_gunner", "_player", "_actionID"];

/*  The action to switch places with a gunner of a static

    Execution on: All

    Scope: Internal

    Params:
        _gunner: OBJECT : The _gunner
        _player: OBJECT : The player executing this action
        _actionID: NUMBER : The ID of this action

    Returns:
        Nothing
*/

//private _gunner = _static getVariable ["gunner", objNull];
private _static = objectParent _gunner;

//Remove the action from the gunner
[_gunner, _actionID] remoteExec ["removeAction", [teamPlayer, civilian], _static];

moveOut _gunner;
[_gunner] orderGetIn false;
doStop _gunner;

_player moveInGunner _static;
