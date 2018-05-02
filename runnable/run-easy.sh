#!/bin/bash
JULIA_HOME=$1
INST_HOME=$2
method=$3
for ((i=1;i<3;i++))
{
    for ((j=1;j<4;j++))
    {
        for ((k=1;k<6;k++))
        {
            filename=$i"0_"

            if [ $i == 1 ];then
                if [ $j == 3 ];then
                    filename=$filename"5_";
                else 
                    filename=$filename$j"_"; 
                fi
            elif [ $i == 2 ];then
                if [ $j == 1 ];then
                    filename=$filename"2_";
                elif [ $j == 2 ];then
                    filename=$filename"4_";
                elif [ $j == 3 ];then
                    filename=$filename"10_";
                fi
            fi
            id=$filename$k
            filename="instance"$filename$k".dat"
            echo "Running file: "$filename
            $JULIA_HOME/julia pcentersolver.jl -f="$INST_HOME/$filename" -m=$method -l=1 | tee logs/$method"-"$id.log
        }
    }
}
exit 0