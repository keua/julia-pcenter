# julia-pcenter
This repository contains Daskin and Elloumi formulations to solve the p-center problem using Julia

## Tests

`JULIA_HOME="/home/ec2-user/julia/bin"`

## Easy

```$JULIA_HOME/julia pcenter_solver.jl -f="Instances/easy/instance10_1_1.dat" -m="daskin" -l=1 | tee daskin-10_1_1.log```

Bulk

> run-easy.sh [JULIA_HOME] [INSTANCES_HOME] [METHOD(daskin|elloumi)]

Daskin: `./run-easy.sh /home/ec2-user/julia/bin Instances/easy daskin`
Elloumi: `./run-easy.sh /home/ec2-user/julia/bin Instances/easy elloumi`

## Hard

Individual

```$JULIA_HOME/julia pcenter_solver.jl -f="Instances/hard/instance1.dat" -m="elloumi" -l=1 | tee daskin-hard1.log```

Bulk

> run-hard.sh [JULIA_HOME] [INSTANCES_HOME] [METHOD(daskin|elloumi)] [START(1-10)] [END(1-10)] 

Daskin: `./run-hard.sh /home/ec2-user/julia/bin Instances/hard daskin 1 5`
Elloumi: `./run-hard.sh /home/ec2-user/julia/bin Instances/hard elloumi 1 5`