#!/bin/bash

#SBATCH --time=1-23:00:00
#SBATCH --job-name=dr
#SBATCH --mem=5000
#SBATCH --partition=nomosix
#SBATCH --array=1-260%100
#SBATCH --output=~/scRNAseqDRComparison/out/dr%a.out
#SBATCH --error=~/scRNAseqDRComparison/err/dr%a.err
#SBATCH --workdir=~/scRNAseqDRComparison

bash

module purge
module load R/3.5.0-foss-2016b-avx2
module load miniconda/4.5.12
module load zlib/1.2.8-GCCcore-5.4.0
module load MPFR
source activate python
export LD_LIBRARY_PATH=/gpfs/ysm/project/sag86/conda_envs/python/lib:$LD_LIBRARY_PATH
export PATH=/gpfs/ysm/project/sag86/conda_envs/python/bin:$PATH
mkdir -p ~/scRNAseqDRComparison/results/

let k=0

for id in 1; do
for ((im=1; im<=13; im++)); do
for ((ip=1; ip<=4; ip++)); do
for ((irpt=1; irpt<=5; irpt++)); do
  let k=${k}+1
  if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then
  Rscript --verbose ./code/run_drmethods.R ${id} ${im} ${ip} ${irpt}
  fi	
done
done
done
done
