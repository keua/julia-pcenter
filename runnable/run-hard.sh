#!/bin/bash
JULIA_HOME=$1
INST_HOME=$2
method=$3
start=$4
end=$5
for ((i=$start;i<$end+1;i++))
{
    id=$i"hard"
    filename="instance"$i".dat"
    echo "Running file: "$filename
    $JULIA_HOME/julia pcentersolver.jl -f="$INST_HOME/$filename" -m=$method -l=1 | tee logs/$method"-"$id.log
}
exit 0