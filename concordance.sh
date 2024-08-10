#!/bin/bash -l
#SBATCH -p chimp
#SBATCH -n 4
#SBATCH -t 5-00:00:00
#SBATCH -J concordance
#SBATCH -o slurm-%j-%N-%u.out
#SBATCH -e slurm-%J-%N-%u.err

vcf=$1
indir=$2
outdir=$3 
#softwares
GATK=/usr/local/sw/gatk-4.4.0.0/gatk

filebase=$(basename $vcf .vcf)

# simulation
ref=/mnt/NEOGENE1/projects/refbias_2020/mapping/gargamel/masked/nov22/chr1.fa
pos=/mnt/NEOGENE1/projects/refbias_2020/gargamel/chr1/chr1_06A010111_bial_minus_indels.vcf

sleep 5s

$GATK Concordance \
   -R $ref \
   -eval ${indir}/${vcf} \
   --truth $pos \
   --summary ${outdir}/${filebase}.concordance.tsv   

sleep 5s
