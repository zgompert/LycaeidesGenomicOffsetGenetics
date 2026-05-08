#!/bin/sh 
#SBATCH --time=48:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=5
#SBATCH --account=gompert
#SBATCH --partition=kingspeak
#SBATCH --job-name=eems
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=zach.gompert@usu.edu

cd /uufs/chpc.utah.edu/common/home/gompert-group2/projects/ldub_ibd
perl RunEemsFork.pl params*ini

early()
{
 echo ' '
 echo ' ############ WARNING:  EARLY TERMINATION ############# '
 echo ' '
}
exit
