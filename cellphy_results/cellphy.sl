#!/bin/bash -e
#SBATCH --account=uoaxxxxx
#SBATCH --partition=milan
#SBATCH --job-name=Cellphy # job name (shows up in the queue)
#SBATCH --time=7-0:0      # Walltime (HH:MM:SS)
#SBATCH --mem=10G          # Memory in MB
#SBATCH --cpus-per-task=20
#SBATCH --mail-user=teng.li@auckland.ac.nz
#SBATCH --array=0-10

module purge

files=( *.vcf )

~/project/tools/cellphy/cellphy.sh RAXML --msa ${files[SLURM_ARRAY_TASK_ID]} --all --model GT16+FO --seed 12345 --threads 20 --tree pars{50},rand{50} --bs-tree autoMRE{200} --bs-metric fbp,tbe --force perf_threads
