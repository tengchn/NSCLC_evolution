#!/bin/bash -e
#SBATCH --account=uoa03626
#SBATCH --partition=milan
#SBATCH --job-name=xxxxx_sciphi # job name (shows up in the queue)
#SBATCH --time=7-0:0      # Walltime (HH:MM:SS)
#SBATCH --mem=50G          # Memory in MB
#SBATCH --cpus-per-task=10
#SBATCH --mail-user=teng.li@auckland.ac.nz

module purge
module load Python/2.7.18-gimkl-2020a

~/.conda/envs/sciphi/bin/sciphi --in xxxxx.cellnames.txt --seed 12345 xxxxx.bam.onlyT.target.mpileup -o xxxxx_sciphi.onlyT.target

