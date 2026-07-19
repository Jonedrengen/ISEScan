#!/bin/bash
#SBATCH -J ISESCAN_submitter
#SBATCH --error=ISESCAN_submitter_%j.err
#SBATCH --output=ISESCAN_submitter_%j.out
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G
#SBATCH --time=01:00:00
#SBATCH --partition=project

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "script location: ${BASH_SOURCE[0]}"

function usage {
    echo "Usage essential: $0 -i <input_folder> -s <sample_list> -o <output_dir>"
    echo "  -i: Path to the input folder containing FASTA files"
    echo "  -s: Path to the sample list file (one FASTA filename per line; optional)"
    echo "  -o: Path to the output directory where results will be stored"
    echo
    echo "Usage optional"
    echo "  -m: Mode of operation ('SLURM' or 'LOCAL'),        default = 'SLURM'"
    echo "  -j: Jobname,                                       default = 'isescan_runner'"
    echo "  -c: config                                         default = scripts/config.env"
    echo
    echo "avoid spaces, dots, and special characters in sample names to prevent issues with file handling"
}

function config_key_grapper {
    local key="$1"
    local default_value="${2:-}"
    local value=""

    if [[ -f "$config" ]]; then
        value="$(grep -E "^${key}=" "$config" | tail -1 | awk -F'=' '{print $2}' | xargs)"
    fi

    if [[ -n "$value" ]]; then
        echo "$value"
    else
        echo "no config value found for $key, exiting"
        exit 1
    fi
}

while getopts "i:s:o:m:j:c:" opt; do
  case $opt in
    i) input_folder="$OPTARG" ;;
    s) sample_list="$OPTARG" ;;
    o) output_dir="$OPTARG" ;;
    m) mode="$OPTARG" ;;
    j) jobname="$OPTARG" ;;
    c) config="$OPTARG";;
    \?) echo "Invalid option -$OPTARG" >&2 ;;
  esac
done

