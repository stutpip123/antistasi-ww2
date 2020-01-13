/*  Updates the preferences of markers when tierWar changes. Handles the update of every marker
*   Params:
*       Nothing
*
*   Returns:
*       Nothing
*/

private _fileName = "updatePreference";

[2, format ["tierWar has changed, is now %1, checking for preference update", tierWar], _fileName] call A3A_fnc_log;

//No need to update the preferences
if(tierPreference >= tierWar) exitWith
{
    [2, "Update of preference aborted as this war level was already reached before", _fileName] call A3A_fnc_log;
};

for "_i" from (tierPreference + 1) to tierWar do
{
    if(_i in airportUpdateTiers) then
    {
        _preference = garrison getVariable ["Airport_preference", []];
        //Update vehicle types
        [_preference] call A3A_fnc_updateVehicles;

        //Add new vehicles
        _index = airportUpdateTiers findIf {_x == _i};
        if(_index % 2 == 0) then
        {
            _preference pushBack ["LAND_LIGHT", -1, "SQUAD"];
            _preference pushBack ["HELI_LIGHT", -1, "GROUP"];
        }
        else
        {
            _preference pushBack ["LAND_AIR", -1, "AA"];
            _preference pushBack ["AIR_GENERIC", -1, "EMPTY"];
        };

        [2, format ["Airport_preference hit level %1", _i], _fileName] call A3A_fnc_log;
        [_preference, "Airport_preference"] call A3A_fnc_logArray;

        garrison setVariable ["Airport_preference", _preference, true];
        garrison setVariable ["Airport_statics", (airportStaticsTiers select _index), true];

        //Update all the airports
        {
            ["Airport", _x] spawn A3A_fnc_updateGarrison;
        } forEach airportsX;
    };

    if(_i in outpostUpdateTiers) then
    {
        _preference = garrison getVariable ["Outpost_preference", []];
        //Update vehicle types
        [_preference] call A3A_fnc_updateVehicles;

        //Add new vehicles
        _index = outpostUpdateTiers findIf {_x == _i};
        if(_index % 2 == 0) then
        {
            _preference pushBack ["LAND_LIGHT", -1, "SQUAD"];
        }
        else
        {
            _preference pushBack ["HELI_LIGHT", -1, "GROUP"];
        };

        [2, format ["Outpost_preference hit level %1", _i], _fileName] call A3A_fnc_log;
        [_preference, "Outpost_preference"] call A3A_fnc_logArray;
;
        garrison setVariable ["Outpost_preference", _preference, true];
        garrison setVariable ["Outpost_statics", (outpostStaticsTiers select _index), true];

        {
            ["Outpost", _x] spawn A3A_fnc_updateGarrison;
        } forEach outposts;
    };

  if(_i in cityUpdateTiers) then
  {
      //Update preferences of cities
      _preference = garrison getVariable ["City_preference", []];
      _preference pushBack ["LAND_LIGHT", -1, "GROUP"];

      [2, format ["City_preference hit level %1", _i], _fileName] call A3A_fnc_log;
      [_preference, "City_preference"] call A3A_fnc_logArray;

      garrison setVariable ["City_preference", _preference, true];

      //Update statics percentage
      _index = cityUpdateTiers findIf {_x == _i};
      garrison setVariable ["City_statics", (cityStaticsTiers select _index), true];

      {
          ["City", _x] spawn A3A_fnc_updateGarrison;
      } forEach citiesX;
  };

  if(_i in otherUpdateTiers) then
  {
      //Update preferences of other sites
      _preference = garrison getVariable ["Other_preference", []];
      //Update vehicle types
      [_preference] call A3A_fnc_updateVehicles;

      _preference pushBack ["EMPTY", 0, "SQUAD"];

      [2, format ["Other_preference hit level %1", _i], _fileName] call A3A_fnc_log;
      [_preference, "Other_preference"] call A3A_fnc_logArray;

      garrison setVariable ["Other_preference", _preference, true];

      //Update statics percentage
      _index = otherUpdateTiers findIf {_x == _i};
      garrison setVariable ["Other_statics", (otherStaticsTiers select _index), true];

      {
          ["Other", _x] spawn A3A_fnc_updateGarrison;
      } forEach resourcesX + factories + seaports;
  };
};

tierPreference = tierWar;
publicVariable "tierPreference";
