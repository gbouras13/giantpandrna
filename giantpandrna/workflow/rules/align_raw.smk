rule minimap_raw:
    input:
        get_input_lr_fastqs
    output:
        os.path.join(ALIGN_RAW,"{sample}.bam")
    threads:
        BigJobCpu
    resources:
        mem_mb=BigJobMem,
        time=BigTime
    params:
        os.path.join(ReferenceDir,FastaGunzipped)
    conda:
        os.path.join('..', 'envs','align.yaml')
    shell:
        '''
        minimap2 -ax splice -t {threads} {params[0]} {input[0]} | samtools view -@ {threads} -S -b > {output[0]}
        '''

rule bam_sort_raw:
    input:
        os.path.join(ALIGN_RAW,"{sample}.bam")
    output:
        os.path.join(ALIGN_RAW,"{sample}_sorted.bam")
    threads:
        BigJobCpu
    resources:
        mem_mb=BigJobMem,
        time=BigTime
    conda:
        os.path.join('..', 'envs','align.yaml')
    shell:
        '''
        samtools sort -@ {threads} {input[0]} -o {output[0]}
        '''

rule bam_stats_raw:
    input:
        os.path.join(ALIGN_RAW,"{sample}_sorted.bam")
    output:
        os.path.join(BAM_STATS,"{sample}_raw_bam.stats")
    threads:
        BigJobCpu
    resources:
        mem_mb=SmallJobMem,
        time=BigTime
    conda:
        os.path.join('..', 'envs','align.yaml')
    shell:
        '''
        samtools stats -@ {threads} {input[0]} | grep ^SN | cut -f 2- > {output[0]} 
        '''

#### aggregation rule
rule align_aggr_raw:
    """aggregate qc raw"""
    input:
        expand(os.path.join(ALIGN_RAW,"{sample}_sorted.bam"), sample = SAMPLES),
        expand(os.path.join(BAM_STATS,"{sample}_raw_bam.stats"), sample = SAMPLES)
    output:
        os.path.join(FLAGS, "align_raw.txt")
    threads:
        1
    resources:
        mem_mb=SmallJobMem,
        time=SmallTime
    shell:
        """
        touch {output[0]}
        """



