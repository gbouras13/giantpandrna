rule minimap_porechop:
    input:
        os.path.join(PORECHOP,"{sample}_porechopped.fastq.gz")
    output:
        os.path.join(ALIGN_PORECHOP,"{sample}.bam")
    threads:
        3
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

rule bam_sort_porechop:
    input:
        os.path.join(ALIGN_PORECHOP,"{sample}.bam")
    output:
        os.path.join(ALIGN_PORECHOP,"{sample}_sorted.bam")
    threads:
        BigJobCpu
    resources:
        mem_mb=BigJobMem,
        time=MediumTime
    conda:
        os.path.join('..', 'envs','align.yaml')
    shell:
        '''
        samtools sort -@ {threads} {input[0]} -o {output[0]}
        '''

rule bam_stats:
    input:
        os.path.join(ALIGN_PORECHOP,"{sample}_sorted.bam")
    output:
        os.path.join(BAM_STATS,"{sample}_porechop_bam.stats")
    threads:
        BigJobCpu
    resources:
        mem_mb=SmallJobMem,
        time=MediumTime
    conda:
        os.path.join('..', 'envs','align.yaml')
    shell:
        '''
        samtools stats -@ {threads} {input[0]} | grep ^SN | cut -f 2- > {output[0]} 
        '''

#### aggregation rule
rule align_aggr_porechop:
    """aggregate qc porechop"""
    input:
        expand(os.path.join(ALIGN_PORECHOP,"{sample}_sorted.bam"), sample = SAMPLES),
        expand(os.path.join(BAM_STATS,"{sample}_porechop_bam.stats"), sample = SAMPLES)
    output:
        os.path.join(FLAGS, "align_porechop.txt")
    threads:
        1
    shell:
        """
        touch {output[0]}
        """



