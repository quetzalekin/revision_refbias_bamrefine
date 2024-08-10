#!/bin/bash -l
#SBATCH -p chimp
#SBATCH -n 1
#SBATCH -t 5-00:00:00
#SBATCH -J trim
#SBATCH -o slurm-%j-%N-%u.out
#SBATCH -e slurm-%J-%N-%u.err

bamfile=$1 
indir=$2
outdir=$3 
filebase=$(basename $bamfile .bam)

bamUtil=/usr/local/sw/bamUtil-1.0.15/bam
$bamUtil trimBam ${indir}/${bamfile} ${outdir}/${filebase}.trimBAM.bam 10
