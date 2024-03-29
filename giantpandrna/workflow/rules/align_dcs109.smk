
rule minimap_DCS109:
    input:
        os.path.join(FINAL_PYCHOPPER_DCS109,"{sample}_pychopper.fastq")
    output:
        os.path.join(ALIGN,"{sample}.bam")
    threads:
        MediumJobCpu
    resources:
        mem_mb=MassiveJobMem,
        time=BigTime
    params:
        os.path.join(ReferenceDir,FastaGunzipped)
    conda:
        os.path.join('..', 'envs','align.yaml')
    shell:
        '''
        minimap2 -ax splice -t {threads} {params[0]} {input[0]} | samtools view -@ {threads} -S -b > {output[0]}
        '''

rule bam_sort:
    input:
        os.path.join(ALIGN,"{sample}.bam")
    output:
        os.path.join(ALIGN,"{sample}_sorted.bam")
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
        os.path.join(ALIGN,"{sample}_sorted.bam")
    output:
        os.path.join(BAM_STATS,"{sample}_bam.stats")
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
rule align_aggr:
    """aggregate qc"""
    input:
        expand(os.path.join(ALIGN,"{sample}_sorted.bam"), sample = SAMPLES),
        expand(os.path.join(BAM_STATS,"{sample}_bam.stats"), sample = SAMPLES)
    output:
        os.path.join(FLAGS, "align.txt")
    threads:
        1
    shell:
        """
        touch {output[0]}
        """



