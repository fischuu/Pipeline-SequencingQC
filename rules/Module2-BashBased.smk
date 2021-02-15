rule count_lines_per_subproject:
    """
    Create the fasta index for the reference genome
    """
    input:
        "%s_results-bcl/fastq/{groups}" % (config["project-folder"])
    output: 
       lines="%s/data/{groups}.linesPerFile" % (config["report-folder"])
    log:
        "%s/logs/Module2/{groups}.Clps.log" % (config["project-folder"])
    benchmark:
        "%s/benchmark/Module2/{groups}.Clps.benchmark.tsv" % (config["project-folder"])
    params: pipeFolder=config["pipeline-folder"]
    shell:"""
       cd {input}
       {params.pipeFolder}/scripts/wcz {output} &> {log}
  	"""   