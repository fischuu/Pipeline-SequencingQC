#run snakemake on the cluster
#
#$1 is target file 

module load bioconda/3
source activate Snakemake

#snakemake -s /scratch/project_2001881/Pipeline-SequencingQC/Pipeline-SequencingQC.smk \
#          --configfile /scratch/project_2001881/Pipeline-SequencingQC/Pipeline-SequencingQC_config.yaml \
#          --forceall --rulegraph | dot -Tpdf > rulegraph.pdf

snakemake -s /scratch/project_2001881/Pipeline-SequencingQC/Pipeline-SequencingQC.smk \
          -j 200 \
          --latency-wait 60 \
          --use-singularity \
          --singularity-args "-B /scratch:/scratch,/projappl:/projappl" \
          --configfile /scratch/project_2001881/Pipeline-SequencingQC/Pipeline-SequencingQC_config.yaml \
          --cluster-config /scratch/project_2001881/Pipeline-SequencingQC/Pipeline-SequencingQC_server-config.yaml \
          --cluster "sbatch -t {cluster.time} --account={cluster.account} --gres=nvme:{cluster.nvme} --job-name={cluster.job-name} --tasks-per-node={cluster.ntasks} --cpus-per-task={cluster.cpus-per-task} --mem-per-cpu={cluster.mem-per-cpu} -p {cluster.partition} -D {cluster.working-directory}" --quiet $1 
