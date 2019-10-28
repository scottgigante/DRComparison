#!/bin/bash

#SBATCH --time=3-24:00:00
#SBATCH --job-name=zifa
#SBATCH --mem=16000
#SBATCH --array=1-20
#SBATCH --ntasks=1 --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --constraint=avx2
#SBATCH --mail-user=scott.gigante@yale.edu
#SBATCH --mail-type=ALL
#SBATCH --output=/ysm-gpfs/home/sag86/slurm_logs/slurm_%x_%j.out

cd ~/scRNAseqDRComparison/code

module purge
module load R/3.5.0-foss-2016b-avx2
module load miniconda/4.5.12
module load zlib/1.2.8-GCCcore-5.4.0
source activate python
export LD_LIBRARY_PATH=/gpfs/ysm/project/sag86/conda_envs/python/lib:$LD_LIBRARY_PATH
export PATH=/gpfs/ysm/project/sag86/conda_envs/python/bin:$PATH
mkdir -p ~/scRNAseqDRComparison/results/

let k=0

for idata in 'Baron'; do
for ip in 8 20 38 58; do
for ((irpt=1; irpt<=5; irpt++)); do
  GFILE=../data/sce_${idata}_ZIFA.txt
  CODEPATH=../algorithm/ZIFA
  let k=${k}+1
  if [ ${k} -eq ${SLURM_ARRAY_TASK_ID} ]; then
  cd ${CODEPATH}
  if [ ! -d "~/scRNAseqDRComparison/results/${idata}/res.${idata}.nPC${ip}.rpt${irpt}.ZIFA.txt" ]; then
  python block_ZIFA_commd.py --normcounts_file ${GFILE} --num_pc ${ip} --out ~/scRNAseqDRComparison/results/${idata}/res.${idata}.nPC${ip}.rpt${irpt}.ZIFA.txt
  fi
  fi	
done
done
done
