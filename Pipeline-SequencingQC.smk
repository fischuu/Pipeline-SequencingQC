# vim: set filetype=sh :
import pandas as pd
from snakemake.utils import validate, min_version

import os

##### Pipeline - SequencingQC                    #####
##### Daniel Fischer (daniel.fischer@luke.fi)    #####
##### Natural Resources Institute Finland (Luke) #####
##### Version: 0.1.3                             #####
version = "0.1.3"

##### set minimum snakemake version #####
min_version("5.24")

##### Complete the input configuration
config["bcl-folder"]=config["project-folder"]+"_results-bcl"
config["report-script"]=config["pipeline-folder"]+"/scripts/workflow-report.Rmd"
config["pipeline-config"]=config["pipeline-folder"]+"/Pipeline-SequencingQC_config.yaml"
config["report-folder"]=config["project-folder"]+"_QC-report"

##### load config and sample sheets #####
groups=next(os.walk(config["bcl-folder"]+"/fastq"))[1]

##### Define the used singularity containers #####
config["singularity"] = {}
config["singularity"]["r-gbs"]="docker://fischuu/r-gbs:3.6.3-0.2"

##### Print the welcome screen #####
print("#################################################################################")
print("##### Welcome to the SequenceQC pipeline")
print("##### version: "+version)
print("#####")
print("##### Pipeline configuration")
print("##### --------------------------------")
print("##### project-folder  : "+config["project-folder"])
print("##### report-folder   : "+config["report-folder"])
print("##### bcl-folder      : "+config["bcl-folder"])
print("##### pipeline-folder : "+config["pipeline-folder"])
print("##### pipeline-config : "+config["pipeline-config"])
print("#####")
print("##### Singularity configuration")
print("##### --------------------------------")
print("##### r-gbs: "+config["singularity"]["r-gbs"])
print("#####")
print("##### Runtime-configurations")
print("##### --------------------------------")
print("##### Expected reads per sample : " + str(config["expected_reads_per_sample"]))
print("#####")
print("##### Derived runtime parameters")
print("##### --------------------------------")
print("##### Identified subgroups : "+'[%s]' % ', '.join(map(str, groups)))
print("#################################################################################")
print("")
#report-folder

##### run complete pipeline #####
rule all:
    input:
        expand("%s/data/{groups}.linesPerFile" % (config["report-folder"]), groups=groups),
        "%s/Pipeline-SequencingQC-finalReport.html" % (config["project-folder"])
 
### setup report #####
report: "report/workflow.rst"

##### load rules #####
include: "rules/Module1-FastQCandMultiQC.smk"
include: "rules/Module2-BashBased.smk"
include: "rules/Module3-Reporting.smk"
