params [["_unitTypeName", nil, [""]], ["_unitLoadout", nil, [[]]]];

if (!isServer) exitWith {};

customUnitTypes setVariable [_unitTypeName, _unitLoadout, true];