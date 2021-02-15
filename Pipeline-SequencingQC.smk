# vim: set filetype=sh :
import pandas as pd
from snakemake.utils import validate, min_version

import os

##### Pipeline - SequencingQC                    #####
##### Daniel Fischer (daniel.fischer@luke.fi)    #####
##### Natural Resources Institute Finland (Luke) #####
##### Version: 0.1                               #####

##### set minimum snakemake version #####
min_version("5.24")

##### load config and sample sheets #####

print("Set the different demultiplex groups:")
groups=next(os.walk(config["bcl-folder"]+"/fastq"))[1]
print('[%s]' % ', '.join(map(str, groups)))

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
