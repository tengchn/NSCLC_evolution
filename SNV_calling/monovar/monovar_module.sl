#!/bin/bash -e
#SBATCH --account=uoa03626
#SBATCH --partition=milan
#SBATCH --job-name=xxxxx # job name (shows up in the queue)
#SBATCH --time=7-0:0      # Walltime (HH:MM:SS)
#SBATCH --mem=50G          # Memory in MB
#SBATCH --cpus-per-task=10
#SBATCH --mail-user=teng.li@auckland.ac.nz

module purge
module load Python/2.7.18-gimkl-2020a

export PATH=$PATH:/scale_wlg_persistent/filesets/project/uoa03421/tools/MonoVar/external/samtools

samtools mpileup -BQ0 -d10000 -f ../hs37d5/hs37d5.fa -q 40 -b ../xxxxx.bam.list |~/.conda/envs/monovar/lib/monovar/monovar.py -p 0.002 -a 0.2 -t 0.05 -m 10 -f ../hs37d5/hs37d5.fa -b ../xxxxx.bam.list -o xxxxx.monovar.onlyt.vcf


