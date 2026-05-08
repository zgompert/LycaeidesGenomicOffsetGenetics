#!/usr/bin/sh

module purge
module load gcc/8.5.0 hdf5/1.10.7

## extract genotypes
estpost.entropy -o g_lyc_goff.txt -p gprob -s 0 -w 0  out_k*hdf5

## extract admixture proportions
estpost.entropy -o q2_lyc_goff.txt -p q -s 0 out_k2_ch*hdf5
estpost.entropy -o q3_lyc_goff.txt -p q -s 0 out_k3_ch*hdf5
