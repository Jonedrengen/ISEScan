#!/bin/bash
#SBATCH -J ISESCAN_Runner
#SBATCH --error=ISESCAN_submitter_%j.err
#SBATCH --output=ISESCAN_submitter_%j.out
#SBATCH --cpus-per-task=6
#SBATCH --mem=16G
#SBATCH --time=01:00:00
#SBATCH --partition=standard

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
threads=${SLURM_CPUS_PER_TASK:-1}

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
    isescan.py --seqfile "$input_file" --output "$output_sample_dir" --nthread "$threads"

done < "$sample_list"

