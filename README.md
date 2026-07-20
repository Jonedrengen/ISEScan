# ISEScan

This is a module to run the ISEScan tool.

Original ISEScan project: https://github.com/xiezhq/ISEScan

Insertion sequence elements (IS elements) are small mobile DNA segments that can move around bacterial genomes. They often encode a transposase, the enzyme that helps them “jump,” and they can disrupt genes or help rearrange genomes.

ISEScan is a tool that automatically finds IS elements in prokaryotic genomes. In the proposal (Maliha Aziz), it is listed with ISfinder as a tool for identifying IS elements during biological characterization of candidate MGEs.

## Usage

### Pull this repository

Clone the repository:

```sh
git clone https://github.com/Jonedrengen/ISEScan.git
cd ISEScan
```

If you already have the repository, update it with:

```sh
git pull ISEScan main
```

If your remote is named `origin` instead, use:

```sh
git pull origin main
```

### Pull the Docker image

```sh
docker pull jonedrengen/isescan:latest
```

### Build the Docker image locally

Run this from the repository root:

```sh
docker build --platform linux/amd64 -t jonedrengen/isescan:latest scripts
```

### Run ISEScan

Show the ISEScan help:

```sh
docker run --rm jonedrengen/isescan:latest --help
```

Run ISEScan on one FASTA file:

```sh
mkdir -p results

docker run --rm \
  -v "$PWD/data:/input:ro" \
  -v "$PWD/results:/output" \
  jonedrengen/isescan:latest \
  --seqfile /input/sample.fasta \
  --output /output 
```

Replace `sample.fasta` with the name of your FASTA file. Put input FASTA files in `data/`; results will be written to `results/`.

### Run the wrapper script

The repository also includes `scripts/isescan.sh`, which is intended to run ISEScan with an input folder, sample list, and output folder:

```sh
bash scripts/isescan.sh \
  -i data \
  -s sample_list.txt \
  -o results \
  -m LOCAL
```

The sample list should contain one FASTA filename per line.
