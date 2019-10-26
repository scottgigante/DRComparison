#!/bin/bash

#SBATCH --time=1-23:00:00
#SBATCH --job-name=dr
#SBATCH --array=1-260%100
#SBATCH --ntasks=1 --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=16000
#SBATCH --constraint=avx2
#SBATCH --mail-user=scott.gigante@yale.edu
#SBATCH --mail-type=ALL
#SBATCH --output=/ysm-gpfs/home/sag86/slurm_logs/slurm_%x_%j.out

cd ~/scRNAseqDRComparison

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
