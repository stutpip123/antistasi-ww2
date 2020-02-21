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
    ["LAND_APC", -1, "SQUAD"],
    ["LAND_START", -1, "SQUAD"],
    ["LAND_LIGHT", 0, "EMPTY"],       //Empty light vehicle
    ["HELI_LIGHT", -1, "GROUP"],
    ["HELI_LIGHT", -1, "GROUP"],
    ["HELI_LIGHT", 0, "EMPTY"],       //Empty helicopter
    ["AIR_DRONE", -1, "EMPTY"],
    ["AIR_DRONE", 0, "EMPTY"]         //Empty plane
];

private _patrol =
[
    "PATROL_NORMAL",
    "PATROL_NORMAL",
    "PATROL_NORMAL",
    "PATROL_NORMAL"
];

garrison setVariable ["Airport_preference", _preference];
garrison setVariable ["Airport_patrolPref", _patrol];
garrison setVariable ["Airport_staticPerc", 0.35];

//Setting up outpost preferences
_preference =
[
  ["LAND_START", -1, "SQUAD"],
  ["LAND_START", -1, "SQUAD"],
  ["LAND_LIGHT", 0, "EMPTY"],       //Empty light vehicle
  ["HELI_LIGHT", -1, "GROUP"],
  ["HELI_LIGHT", 0, "EMPTY"]        //Empty helicopter
];

private _patrol =
[
    "PATROL_NORMAL",
    "PATROL_NORMAL"
];


garrison setVariable ["Outpost_preference", _preference];
garrison setVariable ["Outpost_patrolPref", _patrol];
garrison setVariable ["Outpost_staticPerc", 0.2];

//Setting up city preferences
_preference =
[
  //No units in cities at start
];

private _patrol =
[
    "PATROL_POLICE",
    "PATROL_POLICE",
    "PATROL_POLICE",
    "PATROL_POLICE"
];

garrison setVariable ["City_preference", _preference];
garrison setVariable ["City_patrolPref", _patrol];
garrison setVariable ["City_staticPerc", 0];

//Setting up other preferences
_preference =
[
  ["LAND_START", -1, "SQUAD"],
  ["LAND_START", -1, "SQUAD"],
  ["LAND_LIGHT", 0, "EMPTY"]      //Empty light vehicle
];

private _patrol =
[
    "PATROL_NORMAL",
    "PATROL_NORMAL"
];

garrison setVariable ["Other_preference", _preference];
garrison setVariable ["Other_patrolPref", _patrol];
garrison setVariable ["Other_staticPerc", 0];
