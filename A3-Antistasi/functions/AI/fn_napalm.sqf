_pos = _this select 0;
if (isNil "_pos") exitWith {};
if (count _pos == 0) exitWith {};

if (isServer) then{
	if (!napalmCurrent) then {napalmCurrent = true; publicVariable "napalmCurrent"};
};

if (hasInterface) then {
	_slight6 = "#lightpoint" createVehicleLocal [ _pos select 0, _pos select 1, 10];
	_slight6 setlightBrightness 21.4;
	_slight6 setlightAmbient[.3, .1, 0];
	_slight6 setlightColor[.3, .1, 0];

	_slight1 = "#lightpoint" createVehicleLocal [_pos select 0, _pos select 1, 10];
	_slight1 setlightBrightness 55.4;
	_slight1 setlightAmbient[1, 1, 1];
	_slight1 setlightColor[1, 1, .9];

	_color = [1, 1, 1];

	_pos = [_pos select 0, _pos select 1, 5];
	//--- Dust
	setwind [0.401112*2,0.204166*2,false];
	_velocity = wind;

	_color = [1, 1, 1];
	_alpha = 0.31 ;
	_ps4 = "#particlesource" createVehicleLocal _pos;  // this is fire is red
	_ps4 setParticleParams [["a3\data_f\ParticleEffects\Universal\Universal.p3d", 16, 1, 12, 0], "", "Billboard", 1, 2 + random 3, [0, 0, 5], _velocity, 1, 1.1, 1, 0, [1 + (random 1.1)], [_color + [0], _color + [_alpha], _color + [0]], [1000], 1, 0, "", "", 1];
	_ps4 setParticleRandom [3, [0, 0, 0], [random 4, random 4, 2], 14, 3, [0, 0, 0, .1], 1, 0];
	_ps4 setParticleCircle [20, [0, 0, 0]];
	_ps4 setDropInterval 0.004;
	_nul = [_ps4] spawn
		{
		_fireX = _this select 0;
		while {alive _fireX} do {
			_fireX say3D "fire";
			sleep 13;
			};
		};
	_alpha = 0.35 ;
	_ps7 = "#particlesource" createVehicleLocal _pos;  //this is fire is yellow
	_ps7 setParticleParams [["a3\data_f\ParticleEffects\Universal\Universal.p3d", 16, 3, 12, 0], "", "Billboard", 1, 1 + random 1, [5, 5, 4], _velocity, 1, 1.1, 1, 0, [1.8 + (random 1)], [_color + [0], _color + [_alpha], _color + [0]], [1000], 1, 0, "", "", 1];
	_ps7 setParticleRandom [3, [0, 0, 0], [random 5, random 2, 1], 14, 3, [0, 0, 0, .1], 1, 0];
	_ps7 setParticleCircle [20, [0, 0, 0]];
	_ps7 setDropInterval 0.0012;

	_alpha = 0.1 ;
	_color = [1, 1, .9];
	_ps9 = "#particlesource" createVehicleLocal _pos;
	_ps9 setParticleParams [["a3\data_f\ParticleEffects\Universal\Universal.p3d", 16, 12, 5, 0], "", "Billboard", 1, 16, [0, 0, 1], _velocity, 1, 1.52,1, 0, [.007 + (random .02)], [_color + [0], _color + [_alpha], _color + [0]], [1000], 1, 0, "", "", 1];
	_ps9 setParticleRandom [0, [0, 0, 0], [.2, .2, 4], 14, 3, [0, 0, 0, 22], 1, 0];
	_ps9 setParticleCircle [20, [0, 0, 0]];
	_ps9 setDropInterval 0.01;
	sleep .8;

	deletevehicle _ps9;
	_color = [1, 1, 0];
	_velocity = [10, 10, 35];
	sleep .05;
	_x = 0;
	_brightness = 55.4;
	while {_x < 50} do {
		_brightness = _brightness - 1;
		_slight1 setlightBrightness _brightness;
		sleep .01;
		_x = _x + 1;
	};
	_nul = [_pos] spawn A3A_fnc_napalmDamage;
	deletevehicle _ps9;
	sleep 3;
	deletevehicle _slight1;
	sleep 66;
	// end part
	deletevehicle _ps7;
	sleep 10;
	deletevehicle _ps4;
	sleep 15;
	deletevehicle _slight6;
} else {
	sleep 1;
	_nul = [_pos] spawn A3A_fnc_napalmDamage;
};

if (isServer) then {
	sleep 85;
	if (napalmCurrent) then {napalmCurrent = false; publicVariable "napalmCurrent"};
};