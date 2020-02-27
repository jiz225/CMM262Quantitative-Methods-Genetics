#!/bin/bash
#PBS -N chip_seq
#PBS -o chip_seq.sh.out
#PBS -e chip_seq.sh.err
#PBS -l nodes=1:ppn=2,walltime=5:00:00
#PBS -q hotel
#PBS -M jiz225@ucsd.edu
#PBS -m abe

bash run_chip.sh