/*
Author: Caleb Serafin
    Provides more precision of float serialisation in Arma 3 SQF.
    Always formatted as scientific notation.

Arguments:
    <SCALAR> Valid Number in Arma 3 SQF.

Return Value:
    <STRING> Scientific format serialisation of number; "1.1754943132400513e-38" <= abs x <= "3.4028236865997314e38"; || <STRING> "1.#INF", "-1.#INF", "-1.#IND", 1.#QNAN (all possible outputs of str)

Scope: Local.
Environment: Any
Public: Yes

Example:
    // These values had to be brute forced by hand :'(
    _number = 0.0000000000000000000000000000000000000117549431578982583459901; // Smallest positive input gives "1.1754943132400513e-38" (However serialisation is too small for parseNumber)
    _number = -0.0000000000000000000000000000000000000117549431578982583459901; // Smallest negative input gives "-1.1754943132400513e-38" (However serialisation is too small for parseNumber)
    _number = 340282356779733642751999999999999999999.99999999999999999999999; // (recurring 9s) Largest positive input gives "3.4028236865997314e38" (However serialisation is too big for parseNumber)
    _number = -340282356779733642751999999999999999999.99999999999999999999999; // (recurring 9s) Largest negative input gives "-3.4028236865997314e38" (However serialisation is too big for parseNumber)

    private _n = 12345678;
    private _sn = [locationNull,_n] call Col_fnc_serialise_scalar_max;  // ["SCALAR_MAX","1.2345677614212036e7"]
    _n = parseNumber (_sn#1);
    _sn = [locationNull,_n] call Col_fnc_serialise_scalar_max;
    _n = parseNumber (_sn#1);
    _sn = [locationNull,_n] call Col_fnc_serialise_scalar_max;  // Will still be ["SCALAR_MAX","1.2345677614212036e7"]  // Value does not drift.
    _n - 12345678;  // 0  // Close enough as far as floats are concerned. Compare to next example:

    private _n = 12345678;
    private _sn = str _n;
    _n = parseNumber _sn;
    _n - 12345678;  // 22  // Quite far off.
*/
params [
    ["_serialisation_builder",locationNull,[locationNull]],
    ["_number",0,[0,1e39]]
];

private _serialisedNumber = "";
private _exponent = floor log abs _number;
if (finite _exponent) then {
    private _coefficient = 0;
    if (_exponent isEqualTo 38) then {
        _coefficient = _number / 10^(_exponent); // Cannot be used if N has ~38 fraction decimals (throws zero devisor).
    } else {
        _coefficient = _number * 10^(-_exponent); // Cannot be used if N has ~38 leading numbers (rounds to zero).
    };
    _serialisedNumber = (_coefficient toFixed 16) + "e" + (str _exponent);
} else {
    _serialisedNumber = str _number;
};
["SCALAR_MAX", _serialisedNumber];
