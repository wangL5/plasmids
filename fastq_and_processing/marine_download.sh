#!/bin/csh
#SBATCH --job-name=marine_dl
#SBATCH --time=48:00:00
wget -r -np -e robots=off https://frl.publisso.de/data/frl:6425521/marine/short_read/
