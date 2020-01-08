params ["_nameSpace", "_varName"];

//TODO Name of this function may be a bit misleading, come up with something better
/*  Gets the needed variable from the server and waits if that variable is not yet set
*
*   Params:
*       _nameSpace : NAMESPACE : The namespace the variable is in
*       _varName : STRING : The name of the needed variable
*
*   Returns:
*       _result : ANY : Whatever is saved in that variable
*/

private _fileName = "getServerVariable";
private _result = _nameSpace getVariable _varName;
while {isNil "_result"} do
{
    [
        2,
        //Not sure if format namespace is working, if a strange error is appearing, delete that
        format ["Variable %1 in namespace %2 is not yet set, waiting!", _varName, _nameSpace],
        _fileName
    ] call A3A_fnc_log;
    sleep 1;
    _result = _nameSpace getVariable _varName;
};

_result
