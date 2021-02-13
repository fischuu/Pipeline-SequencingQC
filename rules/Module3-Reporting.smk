# vim: set filetype=sh :

rule R_finalReport:
    """
    Create the final report (R).
    """
    input:
        script=config["report-script"],
        lines=expand("%s/data/{groups}.linesPerFile" % (config["report-folder"]), groups=groups)
    output:
        "%s/Pipeline-SequencingQC-finalReport.html" % (config["project-folder"])
    log:
        "%s/logs/R/finalReport.log" % (config["project-folder"])
    benchmark:
        "%s/benchmark/R/finalReport.benchmark.tsv" % (config["project-folder"])
    singularity:
        "docker://fischuu/r-gbs:3.6.3-0.2"
    params:
       projFolder=config["project-folder"],
       pipeFolder=config["pipeline-folder"],
       pipeConfig=config["pipeline-config"]
    shell:"""
       R -e "projFolder <- '{params.projFolder}'; \
             pipelineFolder <- '{params.pipeFolder}'; \
             pipelineConfig <- '{params.pipeConfig}'; \
             snakemake <- TRUE;\
             rmarkdown::render('{input.script}',output_file='{output}')" &> {log}
    """