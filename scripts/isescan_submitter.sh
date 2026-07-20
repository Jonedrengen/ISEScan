#!/bin/bash
#SBATCH -J ISESCAN_submitter
#SBATCH --error=ISESCAN_submitter_%j.err
#SBATCH --output=ISESCAN_submitter_%j.out
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G
#SBATCH --time=01:00:00
#SBATCH --partition=standard

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "script location: ${BASH_SOURCE[0]}"

function usage() {
    echo "Usage: $0 -i <input_folder> -o <output_dir> -s <sample_list> -e [extension] -m [mode]"
    echo "  -i: Path to the input folder containing fasta files"
    echo "  -o: Path to the output directory where results will be stored"
    echo "  -s: Path to the sample list file (one sample per line)"
    echo "  -e: File extension of the fasta files (default: fasta), note: do not include the dot"
    echo "  -m: Mode of operation (default: default, options: default, Docker)"
    echo "  -c: Path to the config file (default: scripts/config.env)"
    exit 1
}
function validate_input() {
    #This function validates input and fills in default values for optionals


    #check if essential args filled
    if [[ -z "$input_folder" || -z "$output_dir" || -z "$sample_list" ]]; then
        echo "Error: Missing required arguments."
        usage
    fi

    # check for existence of innput folder and sample list file
    if [[ ! -d "$input_folder" ]]; then
        echo "Error: Input folder '$input_folder' does not exist."
        exit 1
    fi

    if [[ ! -f "$sample_list" ]]; then
        echo "Error: Sample list file '$sample_list' does not exist."
        exit 1
    fi

    #check for defaults
    if [[ -z "$extension" ]]; then
        echo "No file extension provided. Defaulting to 'fasta'."
        extension="fasta"
    fi

    if [[ -z "$mode" ]]; then
        echo "No mode provided. Defaulting to 'default'."
        mode="default"
        echo "setting script_dir to SLURM compatible path"
        script_dir=$(grep "^script_dir=" "$config_file" | awk -F'=' '{print $2}')
    fi

    if [[ -z "$config_file" ]]; then
        echo "No config file provided. Defaulting to 'scripts/config.env'."
        echo "feel free to edit the config file"
        config_file="scripts/config.env"
    fi

}


# get input args
while getopts "i:o:s:e:m:c:" opt; do
    case $opt in
        i) input_folder="$OPTARG" ;;
        o) output_dir="$OPTARG" ;;
        s) sample_list="$OPTARG" ;;
        e) extension="$OPTARG" ;;
        m) mode="$OPTARG" ;;
        c) config_file="$OPTARG" ;;
        *) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
    esac
done

#validate input and fill in default values for optionals
validate_input

#filesystem
mkdir -p "$output_dir"
mkdir -p "$output_dir/logs"
mkdir -p "$output_dir/compiled_results"

#runner
if [[ "$mode" == "default" ]]; then
    echo "Running in default mode"
    bash "$script_dir/isescan_runner.sh" "$input_folder" "$sample_list" "$output_dir" "$config_file"
elif [[ "$mode" == "Docker" ]]; then
    echo "Running in Docker mode"
    bash "$script_dir/isescan_docker_runner.sh" "$input_folder" "$sample_list" "$output_dir" "$extension"
else
    echo "Unknown mode: $mode. Exiting."
    exit 1
fi

# aggregate results


