#!/bin/bash -e
#SBATCH --account=uoa03626
#SBATCH --partition=milan
#SBATCH --job-name=xxxxx # job name (shows up in the queue)
#SBATCH --time=7-0:0      # Walltime (HH:MM:SS)
#SBATCH --mem=20G          # Memory in MB
#SBATCH --cpus-per-task=2
#SBATCH --mail-user=teng.li@auckland.ac.nz

module purge
module load SAMtools/1.13-GCC-9.2.0

#export PATH=$PATH:/scale_wlg_persistent/filesets/project/uoa03421/tools/MonoVar/external/samtools

samtools mpileup -B -d 1000 -q 40 -Q 30 -f ../hs37d5/hs37d5.fa -b xxxxx.bam.list -o xxxxx.bam.mpileup

awk 'BEGIN { FS="\t"; OFS="\t" } { $2=$2 "\t" $2 } 1' xxxxx.bam.mpileup |bedtools intersect -a stdin -b ../xgen-exome_100bp.bed -wa -u|cut -f1,2,4- > xxxxx.bam.onlyT.target.mpileup
wait
rm xxxxx.bam.mpileup

