#define FIRE_MAIN_GUN     101
#define FIRE_PISTOL       102

params ["_unit"];

private _actions = [];
if (unit has maingun) then
{
  _actions pushBack ""
};
if (unit has pistol) then
{

};
