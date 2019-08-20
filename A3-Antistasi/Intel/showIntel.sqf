if (isDedicated) exitWith {};

params ["_text"];

if(_text == "") exitWith {};

_textX = format ["<t size='0.6' color='#C1C0BB'>Intel Found.<br/> <t size='0.5' color='#C1C0BB'><br/>"];

_textX = format ["%1 %2", _textX, _text];

[_textX, [safeZoneX, (0.2 * safeZoneW)], [0.25, 0.5], 30, 0, 0, 4] spawn bis_fnc_dynamicText;
