#!/bin/bash -l
#SBATCH -p chimp
#SBATCH -n 15
#SBATCH -t 5-00:00:00
#SBATCH -J vg_autoindex
#SBATCH -o slurm-%j-%N-%u.out
#SBATCH -e slurm-%J-%N-%u.err

/usr/local/sw/vg/bin/vg autoindex --workflow giraffe -r /mnt/NEOGENE1/projects/refbias_2020/giraffe/SBG.Graph.B37.V7.dev2.chr1.fa /mnt/NEOGENE1/projects/refbias_2020/giraffe/SBG.Graph.B37.V7.dev2.chr1.recode.vcf -p /mnt/NEOGENE1/projects/refbias_2020/giraffe/SBG.Graph.B37.V7.dev2.chr1.pangenome

