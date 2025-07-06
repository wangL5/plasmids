#!/bin/bash
#SBATCH --job-name=test_conda

### the point of this script is to test activating the plasmids environment in a non-interactive slurm setting

#ensure mamba is initialized
eval "$(conda shell.bash hook)"
conda activate plasmids

#print environment details
which python
which fastp
conda info
conda list
