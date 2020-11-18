/*
Function:
    A3A_fnc_customHintRender

Description:
    Renders top item on customHint queue.
    This should not be called outside of the render loop in A3A_fnc_customHintInit.

Scope:
    <LOCAL> Execute on each player to draw from individual hint queue.

Environment:
    <ANY>

Returns:
    <BOOLEAN> true if it hasn't crashed; nil if it has crashed.

Examples:
    call A3A_fnc_customHintRender;

Authors: Caleb Serafin
License: MIT License, Copyright (c) 2019 Barbolani & The Official AntiStasi Community
*/

private _filename = "fn_customHintRender.sqf";

if (!hasInterface || !A3A_customHintEnable) exitWith {false;}; // Disabled for server & HC.

if (A3A_customHint_MSGs isEqualTo []) then {
    hintSilent "";
} else{
    private _autoDismiss = 15;  // Number of seconds for message lifetime  // Constant Value
    if (serverTime - A3A_customHint_UpdateTime > _autoDismiss) exitWith {
        [true] call A3A_fnc_customHintDismiss;
    };
    private _alphaHex = [(((_autoDismiss + A3A_customHint_UpdateTime - serverTime) min (_autoDismiss-5)) / (_autoDismiss-5)) ] call A3A_fnc_shader_ratioToHex;
    private _keyBind = "";
    if ((actionKeysNames ["User12",1]) isEqualTo "") then {
        _keyBind = (["<br/><t size='0.8' color='#",_alphaHex,"e5b348' shadow='1' shadowColor='#",_alphaHex,"000000' valign='top' >Bind <t color='#",_alphaHex,"f0d498' >""Use Action 12""</t> to dismiss notification.</t>"] joinString ""); // Needs to be added to string table.
    };
    private _topMSGIndex = count A3A_customHint_MSGs - 1;
    private _previousNotifications = ["<t color='#",_alphaHex,"e5b348' font='RobotoCondensed' align='center' valign='middle' underline='0' shadow='1' shadowColor='#",_alphaHex,"000000' shadowOffset='0.0625'>"];
    if (_topMSGIndex < 4) then {
        _previousNotifications append ["<img size='",(2.0-0.375*_topMSGIndex),"' color='#",_alphaHex,"ffffff' shadowOffset='",0.015625*(4),"' image='functions\UI\images\logo.paa' /><br/>"]  // ["functions\UI\images\logo.paa",4]
    };
    for "_i" from 3 min (_topMSGIndex-1) to 0 step -1 do {
        _previousNotifications append ["<t size='",0.8-0.1*_i,"'>",A3A_customHint_MSGs#(_topMSGIndex-1-_i)#0,"</t><br/>"];
    };
    _previousNotifications pushBack "</t>";
    _previousNotifications = _previousNotifications joinString "";

    _structuredText = composeText [parseText _previousNotifications,A3A_customHint_MSGs#(_topMSGIndex)#1, parseText _keyBind];
    if (A3A_customHint_MSGs#(_topMSGIndex)#2) then {
        hintSilent _structuredText;
    } else {
        hint _structuredText;
        A3A_customHint_MSGs#(_topMSGIndex) set [2,true]; // so it does not ping more than once.
    };
};
true;

// Arma 3 Apex #218a36 // BIS Website Differs incorrectly from in-game
// Arma 3 #c48214
// Custom Orange #e5b348
