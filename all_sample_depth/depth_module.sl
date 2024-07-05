#!/bin/bash -e
#SBATCH --account=uoa03626
#SBATCH --partition=hugemem
#SBATCH --job-name=xxxxx # job name (shows up in the queue)
#SBATCH --time=0-3:0      # Walltime (HH:MM:SS)
#SBATCH --mem=200G          # Memory in MB
#SBATCH --cpus-per-task=2
#SBATCH --mail-user=teng.li@auckland.ac.nz

module purge
module load SAMtools/1.13-GCC-9.2.0 BCFtools/1.15.1-GCC-11.3.0 BEDTools/2.30.0-GCC-11.3.0

bedtools coverage -hist -a xgen-exome.bed -b bamfile | grep ^all > xxxxx.hist.all.txt
duplicate=`samtools view -c -f 1024 bamfile`
total=`samtools view -c bamfile` 
ratio=`echo "scale=3;$duplicate/$total*100" | bc`

echo -e xxxxx'\t'$duplicate'\t'$total'\t'$ratio"%" >> all_duplicate_ratio.txt




