#!/bin/bash -l
#SBATCH -p chimp
#SBATCH -n 4
#SBATCH -t 5-00:00:00
#SBATCH -J gatk60
#SBATCH -o slurm-%j-%N-%u.out
#SBATCH -e slurm-%J-%N-%u.err

bamfile=$1 ##/mnt/NEOGENE1/projects/refbias_2020/genotyping/gatk/bam
indir=$2
outdir=$3 ##/mnt/NEOGENE1/projects/refbias_2020/genotyping/gatk/refine

#softwares
GATK=/usr/local/sw/gatk-4.4.0.0/gatk
bcftools=/usr/local/sw/bcftools-1.18/bcftools

filebase=$(basename $bamfile .bam)

# simulation
ref=/mnt/NEOGENE1/projects/refbias_2020/mapping/gargamel/masked/nov22/chr1.fa
pos=/mnt/NEOGENE1/projects/refbias_2020/gargamel/chr1/chr1_06A010111_bial_minus_indels.vcf

# real data
#ref=/mnt/NEOGENE3/share/ref/genomes/hsa/hs37d5.fa
#pos=/mnt/NEOGENE1/projects/refbias_2020/masked_ref/afr.auto.vcf.gz

sleep 5s
$GATK HaplotypeCaller \
        -R ${ref} \
        -I ${indir}/${filebase}.bam \
        -O ${outdir}/${filebase}.Q60.vcf.gz \
        --alleles ${pos} \
        -L ${pos} \
        --min-base-quality-score 30 \
        --minimum-mapping-quality 60 \
        --output-mode EMIT_ALL_CONFIDENT_SITES

sleep 5s

${bcftools} index ${outdir}/${filebase}.Q60.vcf.gz
${bcftools} query -f '%CHROM  %POS  %REF  %ALT  GT:[ %GT]\n' ${outdir}/${filebase}.Q60.vcf.gz > ${outdir}/${filebase}.Q60.vcf.gz.query
