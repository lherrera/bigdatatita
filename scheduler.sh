#!/bin/bash

function usage {
    echo "USAGE: "
    echo "    ./scheduler.sh <transcripts folder> <max concurrent jobs>"
}

# Argument checking
transcripts_folder=$1

if [ -z "$1" ]; then
    echo "Please provide a folder from which take transcripts"
    echo ""
    usage
    exit 1
fi

if [ ! -d "$transcripts_folder" ]; then
    echo "Please provide a valid folder from which take transcripts"
    echo ""
    usage
    exit 1
fi
maxprocs=$2
if [ -z "$2" ]; then
    maxprocs=5
fi

# Scheduling
proc=0
seed=`uuidgen`
seed="doctorwho"

# Cycle trough transcripts and start jobs
for transcript in $transcripts_folder/*; do
    ( container="${seed}.$proc"
    echo "[PROC] ${proc} [MAP] transcript: ${transcript} => container: ${container}"
    cat $transcript | docker run --rm -i --name "${container}" map-extract  >> "tmp/result.${container}.txt"
    ) &
    (( proc++%maxprocs==0 )) && wait;
done
echo "" > results.txt
for results in tmp/*; do
	cat $results >> results.txt
	rm $results
done

