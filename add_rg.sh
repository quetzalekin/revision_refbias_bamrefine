#!/bin/bash -l
#SBATCH -p chimp
#SBATCH -n 10
#SBATCH -t 5-00:00:00
#SBATCH -J rg
#SBATCH -o slurm-%j-%N-%u.out
#SBATCH -e slurm-%J-%N-%u.err

bamfile=$1 ##/mnt/NEOGENE1/projects/refbias_2020/genotyping/gatk/bam

#softwares
picard=/usr/local/sw/picard/build/libs/picard.jar

filebase=$(basename $bamfile .bam)

sleep 5s

java -jar $picard AddOrReplaceReadGroups \
       I=${filebase}.bam \
       O=${filebase}.rg.bam \
       SORT_ORDER=coordinate \
       RGID=foo \
       RGLB=bar \
       RGPU=foo \
       RGPL=illumina \
       RGSM=${bamfile} \
       CREATE_INDEX=True
echo "raid done"
sleep 5s
flock -x ${filebase}.rg.bam samtools index ${filebase}.rg.bam
echo "raid index done"

