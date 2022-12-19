
rule bambu:
    input:
        bams = expand(os.path.join(ALIGN,"{sample}_sorted.bam"), sample = SAMPLES)
    output:
        os.path.join(BAMBU,"se.rds")
    params:
        os.path.join(ReferenceDir,FastaGunzipped),
        os.path.join(ReferenceDir,GtfGunzipped)
    threads:
        BigJobCpu
    resources:
        mem_mb=BigJobMem,
        time=BigTime
    conda:
        os.path.join('..', 'envs','quantify.yaml')
    script:
        "../scripts/bambu.R"






