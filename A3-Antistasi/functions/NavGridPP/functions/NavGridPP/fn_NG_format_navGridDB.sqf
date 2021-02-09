params ["_navGridDB"];

private _chunks = [_navGridDB,5] call Col_fnc_array_toChunks;
private _trimOuterBrackets = {
    _this#0 select [1,count (_this#0)-2]
};
private _const_lineBrake = "
";
private _const_comma_lineBrake = ","+_const_lineBrake;
"navGrid = [" + _const_lineBrake + (_chunks apply {[str _x] call _trimOuterBrackets} joinString _const_comma_lineBrake) + _const_lineBrake + "];";
