/*  Initiates the prefered garrison types and size
*   Params:
*     Nothing
*
*   Returns:
*     Nothing
*/

private _isSinglePlayer = !isMultiplayer;

//Setting up airport preferences
private _preference =
[
    ["LAND_AIR", -1, "AA"],
    ["LAND_MEDIUM", -1, "SQUAD"],
    ["LAND_LIGHT", -1, "GROUP"],
    ["LAND_LIGHT_UNARMED", 0, "EMPTY"],       //Empty light vehicle
    ["HELI_PATROL", -1, "GROUP"],
    ["HELI_PATROL", -1, "GROUP"],
    ["HELI_LIGHT", 0, "EMPTY"],       //Empty helicopter
    ["AIR_DRONE", -1, "EMPTY"],
    ["AIR_DRONE", 0, "EMPTY"]         //Empty drone
];

private _patrol =
[
    "PATROL_NORMAL",
    "PATROL_NORMAL",
    "PATROL_NORMAL",
    "PATROL_NORMAL"
];

garrison setVariable ["Airport_preference", _preference, true];
garrison setVariable ["Airport_patrolPref", _patrol, true];
garrison setVariable ["Airport_staticPerc", 0.35, true];

//Setting up outpost preferences
_preference =
[
  ["LAND_START", -1, "GROUP"],
  ["LAND_TRUCK", -1, "GROUP"],
  ["LAND_TRUCK", 0, "EMPTY"],       //Empty light vehicle
  ["HELI_PATROL", -1, "GROUP"],
  ["HELI_PATROL", 0, "EMPTY"]        //Empty helicopter
];

private _patrol =
[
    "PATROL_NORMAL",
    "PATROL_NORMAL",
    "PATROL_NORMAL"
];


garrison setVariable ["Outpost_preference", _preference, true];
garrison setVariable ["Outpost_patrolPref", _patrol, true];
garrison setVariable ["Outpost_staticPerc", 0.2, true];

//Setting up city preferences
_preference =
[
  //No units in cities at start
];

private _patrol =
[
    "PATROL_POLICE",
    "PATROL_POLICE",
    "PATROL_POLICE"
];

garrison setVariable ["City_preference", _preference, true];
garrison setVariable ["City_patrolPref", _patrol, true];
garrison setVariable ["City_staticPerc", 0, true];

//Setting up other preferences
_preference =
[
  ["LAND_START", -1, "GROUP"],
  ["LAND_TRUCK", -1, "GROUP"],
  ["LAND_TRUCK", 0, "EMPTY"]
];

private _patrol =
[
    "PATROL_NORMAL",
    "PATROL_NORMAL"
];

garrison setVariable ["Other_preference", _preference, true];
garrison setVariable ["Other_patrolPref", _patrol, true];
garrison setVariable ["Other_staticPerc", 0, true];
