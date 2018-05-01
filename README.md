# julia-pcenter
This repository contains Daskin and Elloumi formulations to solve the p-center problem using Julia

## Tests

`JULIA_HOME="/home/ec2-user/julia/bin"`

## Easy

```$JULIA_HOME/julia pcenter_solver.jl -f="Instances/easy/instance10_1_1.dat" -m="daskin" -l=1 | tee daskin-10_1_1.log```

Bulk

> run-easy.sh [JULIA_HOME] [INSTANCES_HOME] [METHOD(daskin|elloumi)]

Example: `./run-hard.sh /usr/local/julia/bin Instances/easy daskin`

## Hard

Individual

```$JULIA_HOME/julia pcenter_solver.jl -f="Instances/hard/instance1.dat" -m="elloumi" -l=1 | tee daskin-10_1_1.log```

Bulk

> run-hard.sh [JULIA_HOME] [INSTANCES_HOME] [METHOD(daskin|elloumi)] [LIMIT(1-10)] 

Example: `./run-hard.sh /usr/local/julia/bin Instances/hard daskin 1`