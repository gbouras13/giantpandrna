
rule nanoreceptor_pychopper:
    input:
        os.path.join(FINAL_PYCHOPPER_DCS109,"{sample}_pychopper.fastq")
    output:
        os.path.join(NANORECEPTOR_PYCHOPPER,"{sample}", "{sample}_ig_summary.csv")
    params:
        os.path.join(NANORECEPTOR_PYCHOPPER,"{sample}")
    threads:
        BigJobCpu
    resources:
        mem_mb=BigJobMem,
        time=BigTime
    conda:
        os.path.join('..', 'envs','nanoreceptor.yaml')
    shell:
        """
        nanoreceptor.py -i {input[0]} -o {params[0]} -t {threads} -p {wildcards.sample}
        """


#### aggregation rule
rule pychopper_nanoreceptor_aggr:
    """aggregate pychopper nanoreceptor"""
    input:
        expand(os.path.join(NANORECEPTOR_PYCHOPPER,"{sample}", "{sample}_ig_summary.csv"), sample = SAMPLES)
    output:
        os.path.join(FLAGS, "pychopperNanoreceptor.txt")
    threads:
        1
    resources:
        mem_mb=SmallJobMem,
        time=SmallTime
    shell:
        """
        touch {output[0]}
        """

rule nanoreceptor_raw:
    input:
        get_input_lr_fastqs
    output:
        os.path.join(NANORECEPTOR_RAW,"{sample}", "{sample}_ig_summary.csv")
    params:
        os.path.join(NANORECEPTOR_RAW,"{sample}")
    threads:
        BigJobCpu
    resources:
        mem_mb=BigJobMem,
        time=BigTime
    conda:
        os.path.join('..', 'envs','nanoreceptor.yaml')
    shell:
        """
        nanoreceptor.py -i {input[0]} -o {params[0]} -t {threads} -p {wildcards.sample}
        """


#### aggregation rule
rule raw_nanoreceptor_aggr:
    """aggregate raw nanorecept"""
    input:
        expand(os.path.join(NANORECEPTOR_RAW,"{sample}", "{sample}_ig_summary.csv"), sample = SAMPLES)
    output:
        os.path.join(FLAGS, "rawNanoreceptor.txt")
    threads:
        1
    resources:
        mem_mb=SmallJobMem,
        time=SmallTime
    shell:
        """
        touch {output[0]}
        """


