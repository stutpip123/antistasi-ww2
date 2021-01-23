//Each element is: [model name, [nodes]]
//Nodes are build like this: [Available(internal use,  always 1), Hardpoint location, Seats locked when node is in use]
A3A_logistics_vehicleHardpoints append [
    //Scania 16
    ["\d3s_scania_16\SCANIA_16",[[1,[0,2,0.2],[]],[1,[0,1.2,0.2],[]],[1,[0,0.4,0.2],[]],[1,[0,-0.4,0.2],[]],[1,[0,-1.2,0.2],[]],[1,[0,-2,0.2],[]],[1,[0,-2.8,0.2],[]],[1,[0,-3.6,0.2],[]]]],
    //Merc Actros
    ["\d3s_actros_14\ACTROS_14",[[1,[0,2,-1],[]],[1,[0,1.2,-1],[]],[1,[0,0.4,-1],[]],[1,[0,-0.4,-1],[]],[1,[0,-1.2,-1],[]],[1,[0,-2,-1],[]],[1,[0,-2.8,-1],[]],[1,[0,-3.6,-1],[]]]],
    //Derry Longhorn
   ["\d3s_SRlonghorn_4520\4520",[[1,[0,0.1,0.4],[]],[1,[0,-0.7,0.4],[]],[1,[0,-1.5,0.4],[]],[1,[0,-2.3,0.4],[]],[1,[0,-3.1,0.4],[]],[1,[0,-3.9,0.4],[]]]],
   //GMC
   ["\d3s_SRmh_9500\MH_9500",[[1,[0,0.35,0.5],[]],[1,[0,-0.45,0.5],[]],[1,[0,-1.25,0.5],[]],[1,[0,-2.05,0.5],[]],[1,[0,-2.85,0.5],[]],[1,[0,-3.65,0.5],[]]]],
   //Peterbilt
   ["\d3s_peterbilt_579\579",[[1,[0,0.6,0.5],[]],[1,[0,-0.2,0.5],[]],[1,[0,-1,0.5],[]],[1,[0,-1.8,0.5],[]],[1,[0,-2.6,0.5],[]],[1,[0,-3.4,0.5],[]],[1,[0,-4.2,0.5],[]]]],
   //
   
   //

];
//all vehicles with jnl loading nodes where the nodes are not located in the open, this can be because its inside the vehicle or it has a cover over the loading plane.
A3A_logistics_coveredVehicles append [""];
