
rule nanoplot:
    input:
        get_input_lr_fastqs
    output:
        dir = directory(os.path.join(NANOPLOT, "{sample}")) 
    threads:
        MediumJobCpu
    resources:
        mem_mb=BigJobMem,
        time=MediumTime
    conda:
        os.path.join('..', 'envs','nanoplot.yaml')
    shell:
        'NanoPlot --prefix pass --fastq {input} -t {threads} -o {output.dir}'

rule nanoplot_aggr:
    """aggregate qc"""
    input:
        expand( os.path.join(NANOPLOT, "{sample}"), sample = SAMPLES)
    output:
        os.path.join(FLAGS, "nanoplot_aggr.txt")
    threads:
        1
    shell:
        """
        touch {output[0]}
        """


rule pychopper:
    input:
        get_input_lr_fastqs
    output:
        os.path.join(PYCHOPPER,"{sample}_input.fastq"),
        os.path.join(PYCHOPPER,"{sample}_pychop_report.pdf"),
        os.path.join(PYCHOPPER,"{sample}_pychop_unclassified.fastq"),
        os.path.join(PYCHOPPER,"{sample}_pychop_rescued.fastq"),
        os.path.join(PYCHOPPER,"{sample}_pychop_full_length_output.fastq"),
        os.path.join(PYCHOPPER,"{sample}_stats.txt")
    threads:
        MediumJobCpu
    resources:
        mem_mb=BigJobMem,
        time=BigTime
    params:
        Kit
    conda:
        os.path.join('..', 'envs','pychopper.yaml')
    shell:
        '''
        gunzip -c {input[0]} > {output[0]}
        pychopper -r {output[1]} -u {output[2]} -w {output[3]} -S {output[5]} -k {params[0]}  -t {threads} {output[0]} {output[4]}
        '''

# rescue if dcs109
rule pychopper_rescue:
    input:
        os.path.join(PYCHOPPER,"{sample}_pychop_unclassified.fastq")
    output:
        os.path.join(PYCHOPPER_RESCUE,"{sample}_pychop_report.pdf"),
        os.path.join(PYCHOPPER_RESCUE,"{sample}_pychop_unclassified.fastq"),
        os.path.join(PYCHOPPER_RESCUE,"{sample}_pychop_rescued.fastq"),
        os.path.join(PYCHOPPER_RESCUE,"{sample}_pychop_full_length_output.fastq")
    threads:
        MediumJobCpu
    resources:
        mem_mb=BigJobMem,
        time=BigTime
    conda:
        os.path.join('..', 'envs','pychopper.yaml')
    shell:
        '''
        pychopper -r {output[0]} -u {output[1]} -w {output[2]} -x DCS109 -t {threads} {input[0]} {output[3]}
        '''

rule pychopper_dcs109_concat:
    input:
        os.path.join(PYCHOPPER,"{sample}_pychop_full_length_output.fastq"),
        os.path.join(PYCHOPPER,"{sample}_pychop_rescued.fastq"),
        os.path.join(PYCHOPPER_RESCUE,"{sample}_pychop_rescued.fastq"),
        os.path.join(PYCHOPPER_RESCUE,"{sample}_pychop_full_length_output.fastq")
    output:
        os.path.join(FINAL_PYCHOPPER_DCS109,"{sample}_pychopper.fastq")
    threads:
        1
    resources:
        mem_mb=SmallJobMem,
        time=SmallTime
    shell:
        '''
        cat {input[0]} {input[1]} {input[2]} {input[3]} > {output[0]}
        '''

rule pychopper_pcs109_pcs111_concat:
    input:
        os.path.join(PYCHOPPER,"{sample}_pychop_full_length_output.fastq"),
        os.path.join(PYCHOPPER,"{sample}_pychop_rescued.fastq")
    output:
        os.path.join(FINAL_PYCHOPPER_PCS109_PCS111,"{sample}_pychopper.fastq")
    threads:
        1
    resources:
        mem_mb=SmallJobMem,
        time=SmallTime
    shell:
        '''
        cat {input[0]} {input[1]}  > {output[0]}
        '''


#### aggregation rule
rule qc_aggr_dcs109:
    """aggregate qc"""
    input:
        expand( os.path.join(FINAL_PYCHOPPER_DCS109,"{sample}_pychopper.fastq"), sample = SAMPLES)
    output:
        os.path.join(FLAGS, "qc_dcs109.txt")
    threads:
        1
    shell:
        """
        touch {output[0]}
        """

#### aggregation rule
rule qc_aggr_pcs109:
    """aggregate qc"""
    input:
        expand( os.path.join(FINAL_PYCHOPPER_PCS109_PCS111,"{sample}_pychopper.fastq"), sample = SAMPLES)
    output:
        os.path.join(FLAGS, "qc_pcs109_pcs111.txt")
    threads:
        1
    shell:
        """
        touch {output[0]}
        """

