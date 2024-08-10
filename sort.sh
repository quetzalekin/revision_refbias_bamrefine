#!/bin/bash -l
#SBATCH -p bonobo
#SBATCH -n 10
#SBATCH -t 10-00:00:00
#SBATCH -J sort
#SBATCH -o slurm-%j-%N-%u.out
#SBATCH -e slurm-%J-%N-%u.err

samtools sort cov10_sim5.all.gr.bam --threads 10 -o  cov10_sim5.all.gr.sorted.bam
