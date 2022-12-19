
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
        os.path.join(FLAGS, "nanoreceptor.txt")
    threads:
        1
    resources:
        mem_mb=SmallJobMem,
        time=SmallTime
    shell:
        """
        touch {output[0]}
        """


