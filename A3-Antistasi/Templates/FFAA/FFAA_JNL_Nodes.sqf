//JNL mounting nodes for cargo and statics.
jnl_vehicleHardpoints append [
//4x4s
//pegaso open
  ["\ffaa_et_pegaso\ffaa_et_pegaso.p3d",[
    [1,[0,-0.81,-0.01],[3,4,5,6,7]],
    [1,[0,-0.51,-0.01],[2,8,9,10]]
  ]],
//6x6s
//m250 (all variants share a model)
  ["\ffaa_et_pegaso\ffaa_et_m250_blindado.p3d",[
    [1,[-0,0.80,-0.54],[8,9,10,11,12,13]],
    [1,[-0,0.30,-0.54],[4,5,6,7]],
    [1,[-0,-0.50,-0.54],[]]
  ]],
//8x8s

//Boats
  ["\ffaa_ar_supercat\ffaa_ar_supercat",[
    [0,[-0.237793,1.02588,-0.681825],[2,3,4,5,6,7]]
  ]]
];
//Add to the weapon sets
jnl_smallVicWeapons append [];
jnl_largeVicWeapons append [];
//Weapon lists for each vehicle.
jnl_allowedWeapons append [];
//Offsets for adding new statics/boxes to the JNL script.
jnl_attachmentOffset append [];
