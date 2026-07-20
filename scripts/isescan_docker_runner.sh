#!/bin/bash

function run_docker() {

    local input_folder="$1"
    local output_dir="$2"
    local sample="$3"


    docker run --rm \
    -v "$input_folder:/data/input" \
    -v "$output_dir:/data/output" \
    jonedrengen/isescan:latest \
    --seqfile /data/input/"$sample" \
    --output /data/output/"${sample%%.${exstension}}" \
    --nthread 4
}

#input
input_folder="$1"
sample_list="$2"
output_dir="$3"
exstension="$4"

while IFS= read -r sample;
do
    echo "Processing sample: $sample"
    output_sample_dir="$output_dir/processing_files"
    # Run ISEScan on the sample
    run_docker "$input_folder" "${output_sample_dir}" "${sample}"
done < "$sample_list"
