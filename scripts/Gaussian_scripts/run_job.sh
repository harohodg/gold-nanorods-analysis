#!/bin/bash
#SBATCH --mem=2G             # memory, roughly 2 times %mem defined in the input name.com file
#SBATCH --time=0-3:00        # expected run time (DD-HH:MM)
#SBATCH --cpus-per-task=16   # No. of cpus for the job as defined by %nprocs in the name.com file

module load gaussian/g09.e01
\time --verbose g09 LC-BP86_8states.com
