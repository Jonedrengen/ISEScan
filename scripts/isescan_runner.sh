#!/bin/bash

function extract_config_key() {
    local key="$1"
    local config_file="$2"
    grep "^$key=" "$config_file" | awk -F'=' '{print $2}'

    if [[ -z "$value" ]]; then
        echo "Error: Key '$key' not found in config file '$config_file'."
        exit 1
    fi
}

#input
input_folder="$1"
sample_list="$2"
output_dir="$3"
config_file="$4"

#unpack config
conda_source_path=$(extract_config_key "conda_source_path" "$config_file")
conda_env_name=$(extract_config_key "conda_env_name" "$config_file")

#initialize conda
. "$conda_source_path"
conda activate "$conda_env_name"

while IFS= read -r sample; 
do
    echo "Processing sample: $sample"
    input_file="$input_folder/$sample"
    output_sample_dir="$output_dir/$sample"

    # Create output directory for the sample
    mkdir -p "$output_sample_dir"

    # Run ISEScan on the sample
    isescan.py -i "$input_file" -o "$output_sample_dir"

done < "$sample_list"

