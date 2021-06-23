rule fastqc_quality_control_raw_data:
    """
    Quality control of lane-wise fastq files (FASTQC).
    """
    input:
       get_fastq
    output:
        R1="%s/QC/RAW/{rawsamples}_R1_001_fastqc.zip" % (config["project-folder"]),
        R2="%s/QC/RAW/{rawsamples}_R2_001_fastqc.zip" % (config["project-folder"])
    log:
        R1="%s/logs/FASTQC/fastqc_raw_R1.{rawsamples}.log" % (config["project-folder"]),
        R2="%s/logs/FASTQC/fastqc_raw_R2.{rawsamples}.log" % (config["project-folder"])
    benchmark:
        "%s/benchmark/FASTQC/fastqc_raw.{rawsamples}.benchmark.tsv" % (config["project-folder"])
    threads: 20
    params:
        outfolder="%s/QC/RAW/" % (config["project-folder"])
    conda:"envs/gbs.yaml"
    singularity: config["singularity"]["gbs"]
    shell:"""
        mkdir -p {params.outfolder};
        fastqc -t {threads} -o {params.outfolder} --extract {input.R1} &> {log.R1};
        fastqc -t {threads} -o {params.outfolder} --extract {input.R2} &> {log.R2};
    """