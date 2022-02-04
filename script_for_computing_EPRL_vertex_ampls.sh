#!/bin/bash
#SBATCH -A def-vidotto
#SBATCH --ntasks=80
#SBATCH --cpus-per-task=10
#SBATCH --mem-per-cpu=4G
#SBATCH --time=3-0:00:00
#SBATCH --job-name=vertex_ampl
#SBATCH --output=vertex_ampl.log
#SBATCH --error=vertex_ampl.err
#SBATCH --mail-type=BEGIN,FAIL,END
#SBATCH --mail-user=pfrisoni@uwo.ca


echo "Running on: $SLURM_NODELIST"
echo

# start commands

BASEDIR=/home/frisus95/projects/def-vidotto/frisus95/sl2cfoam_next
DATADIR=/home/frisus95/projects/def-vidotto/frisus95/sl2cfoam_next/data_sl2cfoam

export LD_LIBRARY_PATH="${BASEDIR}/lib":$LD_LIBRARY_PATH

# number of OpenMP threads
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

IMMIRZI=0.1

SHELLSMin=16
SHELLSMax=25
CURRENTSHELLS=$SHELLSMin

TCURRENTSPIN=2

while [ $CURRENTSHELLS -le $SHELLSMax ]
do

TJS=$(( TCURRENTSPIN ))

SHELLS=$(( CURRENTSHELLS ))

for TJBULK in 0 2 4 6
do

now=$(date)
echo
echo "Starting Lorentzian fulltensor [ IMMIRZI = ${IMMIRZI} TWICESPIN = ${TJS} TWICEJBULK = ${TJBULK}, shells = ${SHELLS} ]... (now: $now)"

$BASEDIR/bin/vertex-fulltensor -V -h -m 2000 $DATADIR $IMMIRZI $TJS,$TJS,$TJS,$TJS,$TJS,$TJS,$TJS,$TJBULK,$TJS,$TJS $SHELLS

now=$(date)
echo "... done (now: $now)"
echo

# jbulk cycle
done

let CURRENTSHELLS=CURRENTSHELLS+1

# shell cycle
done

echo
echo "All completed."
