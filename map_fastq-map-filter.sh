#!/bin/bash -l
#SBATCH -p chimp
#SBATCH -n 10
#SBATCH -t 5-00:00:00
#SBATCH -J mapfilt
#SBATCH -o slurm-%j-%N-%u.out
#SBATCH -e slurm-%J-%N-%u.err

# modified by dilek - 14 Apr 2019 - mapping part
# modified by kivilcim - 06 Nov 2020 - mapping part

mergedname=$1
ref=$2
alndir=$3 # directory for output
cores=$4
indir=$5

# prerequisites
# samtools Version: 1.9 (using htslib 1.9)
bwa=/usr/local/sw/bwa-0.7.15/bwa
scriptdir=/mnt/NEOGENE1/script/adna_swPipe
MTname=MT
Xchr=X
Ychr=Y
####
#filebase=$(basename $mergedname .fastq.gz)
#refbase=$(basename $ref .fa)
filebase=$(basename $mergedname .bam)
refbase=$(basename $ref .fa)
####

####
# to create temporary folder
sample="$( cut -d '.' -f 1,2 <<< "${mergedname}" )"; samplename=${sample##*/}; echo "$samplename"

TMPDIR=tmp_${samplename}
mkdir ${TMPDIR} -p
echo ${TMPDIR}
####
#### FilterUniqueSAMCons
samtools view -F 4 -h ${indir}/${filebase}.bam \
        | python2 ${scriptdir}/FilterUniqueSAMCons_rand.py | samtools view -h -Su -@ ${cores} - \
        > ${alndir}/mapped/${filebase}.${refbase}.cons.bam  #To remove bias _rand.py
echo "cons done"
sleep 5s
flock -x ${alndir}/mapped/${filebase}.${refbase}.cons.bam samtools index ${alndir}/mapped/${filebase}.${refbase}.cons.bam
echo "cons index done"
####
#### Percidentity threshold
samtools calmd -@ ${cores} ${alndir}/mapped/${filebase}.${refbase}.cons.bam ${ref} \
        | python2 ${scriptdir}/percidentity_threshold.py 0.9 35 ${TMPDIR}/short.txt \
        | samtools view -bS - > ${alndir}/${filebase}.${refbase}.cons.90perc.bam
echo "90perc done"
sleep 5s
flock -x ${alndir}/${filebase}.${refbase}.cons.90perc.bam samtools index ${alndir}/${filebase}.${refbase}.cons.90perc.bam
echo "90perc index done"
echo "mapping done"
