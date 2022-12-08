# rule porechop:
#     input:
#         os.path.join(READS, "{sample}.fastq.gz")
#     output:
#         os.path.join(TMP,"{sample}_porechopped.fastq.gz")
#     threads:
#         BigJobCpu
#     resources:
#         mem_mb=BigJobMem,
#         time=MediumTime
#     conda:
#         os.path.join('..', 'envs','porechop.yaml')
#     shell:
#         '''
#         porechop -i {input} -o {output} --threads {threads}
#         '''

rule nanoplot:
    input:
        get_input_lr_fastqs
    output:
        dir = directory(os.path.join(NANOPLOT, "{sample}")) 
    threads:
        BigJobCpu
    resources:
        mem_mb=BigJobMem,
        time=MediumTime
    conda:
        os.path.join('..', 'envs','nanoplot.yaml')
    shell:
        'NanoPlot --prefix pass --fastq {input} -t {threads} -o {output.dir}'


rule pychopper:
    input:
        get_input_lr_fastqs
    output:
        os.path.join(PYCHOPPER,"{sample}_input.fastq"),
        os.path.join(PYCHOPPER,"{sample}_pychop_report.pdf"),
        os.path.join(PYCHOPPER,"{sample}_pychop_unclassified.fastq"),
        os.path.join(PYCHOPPER,"{sample}_pychop_rescued.fastq"),
        os.path.join(PYCHOPPER,"{sample}_pychop_full_length_output.fastq")
    threads:
        BigJobCpu
    resources:
        mem_mb=BigJobMem
    conda:
        os.path.join('..', 'envs','pychopper.yaml')
    shell:
        '''
        gunzip -c {input[0]} > {output[0]}
        pychopper -r {output[1]} -u {output[2]} -w {output[3]}  -t {threads} {output[0]} {output[4]}
        '''

#### aggregation rule
rule qc_aggr:
    """aggregate qc"""
    input:
        expand( os.path.join(PYCHOPPER,"{sample}_pychop_full_length_output.fastq"), sample = SAMPLES)
    output:
        os.path.join(FLAGS, "qc.txt")
    threads:
        1
    shell:
        """
        touch {output[0]}
        """

