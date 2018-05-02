# julia-pcenter
This repository contains Daskin and Elloumi formulations to solve the p-center problem using Julia

## How to run it

### Folder structure

```
├── julia-pcenter
│   ├── runnable
│   │   ├── instances
│   │   │   ├── *.dat
│   │   ├── logs
│   │   │   ├── *.log
│   │   ├── pcentersolver.jl
│   ├── README.md

```

### Run from terminal
go to the runnable folder (`cd runnable`) and execute the following commands:

Set the julia home env variable: ( the path depends on where you installed Julia )
```bash
julia="/usr/local/julia/bin/julia"
```
Then you can use the following options to run it:

```bash
$julia pcentersolver.jl -f="Instances/xxxxx.dat" 
                        -m=daskin|elloumi 
                        -l=0|1|2|3
                        -r=bi|fi|vnd 
                        -t=3600
                        -th=2
 ```
> `-f` means the instance file  
> `-l` the log level you want to run on  
> `-r` the ratigo gap you want to accept  
> `-t` the timeout for the execution  
> `-th` the number of threads you want to run with   

## Tests

### Machine where the testes were done.
- Compute optimized AWS EC2 mc5.xlarge
- Intel Xeon Platinum 8124M 2 cores
- Clock speed 3 GHz
- 8GB RAM
- The Amazon Linux AMI OS
- julia version 0.6.2

## Easy

```bash
run-easy.sh [JULIA_HOME] [INSTANCES_HOME] [METHOD(daskin|elloumi)]
```
Daskin: 
```bash
./run-easy.sh /usr/local/julia/bin Instances/easy daskin
```  
Elloumi:
```bash
./run-easy.sh /usr/local/julia/bin Instances/easy elloumi
```

## Hard

```bash
run-hard.sh [JULIA_HOME] [INSTANCES_HOME] [METHOD(daskin|elloumi)] [START(1-10)] [END(1-10)] 
```
Daskin: 
```bash
./run-hard.sh /usr/local/julia/bin Instances/hard daskin 1 10
```  
Elloumi:
```bash
./run-hard.sh /usr/local/julia/bin Instances/hard elloumi 1 10
```