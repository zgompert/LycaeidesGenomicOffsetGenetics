#!/bin/sh 
#SBATCH --time=120:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=18
#SBATCH --account=wolf-kp
#SBATCH --partition=wolf-kp
#SBATCH --job-name=entropy
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=zach.gompert@usu.edu

module purge
module load gcc/8.5.0 hdf5/1.10.7

## entropy 1.2
#~/bin/entropy

cd /uufs/chpc.utah.edu/common/home/gompert-group4/projects/lyc_genomic_offset/PopGenom

perl forkEntropy.pl
