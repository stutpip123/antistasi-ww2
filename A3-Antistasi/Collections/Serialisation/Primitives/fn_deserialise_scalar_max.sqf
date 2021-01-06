/*
Author: Caleb Serafin
    Provides more precision of float deserialisation in Arma 3 SQF.
    Always formatted as scientific notation.

Arguments:
    <SCALAR> Valid Number in Arma 3 SQF.

Return Value:
    <STRING> Scientific format serialisation of number; "1.1754943132400513e-38" <= abs x <= "3.4028236865997314e38"; || <STRING> "1.#INF", "-1.#INF", "1.#IND", "-1.#IND", 1.#QNAN, -1.#QNAN (all possible outputs of str) (Almost 2^-126 <= abs x <= 2^128)

Scope: Local.
Environment: Any
Public: Yes

Example:

*/
// Col_fnc_deserialise_scalar_max = {
params [
    ["_serialisation_builder",locationNull,[locationNull]],
    ["_serialisation",0,[0]]
];

private _splitSerialisation = (_serialisation splitString "e");
if !(count _splitSerialisation isEqualTo 2) exitWith {

};

private _exponent = parseNumber (_splitSerialisation#1);

private _splitCoefficientString = (_splitSerialisation#0) splitString ".";
if (count _splitCoefficientString isEqualTo 1) then {
    _splitCoefficientString pushBack "";
};
_splitCoefficientString = _splitCoefficientString apply {reverse ([_x,7] call Col_fnc_string_toChunks);};

private _splitCoefficient = [];
{
    private _number =  0;
    private _miniExponent = 0;
    {
        _number = _number + (parseNumber _x) * (10^_miniExponent);
        _miniExponent = _miniExponent - 7;
    } forEach _x;
} forEach _splitCoefficientString;

private _coefficient = 0;
{
    // Current result is saved in variable _x

} forEach _coefficientChunks;
// }