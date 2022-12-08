
rule nanoreceptor:
    input:
        os.path.join(FINAL_PYCHOPPER_DCS109,"{sample}_pychopper.fastq")
    output:
         os.path.join(NANORECEPTOR,"{sample}", "{sample}")
    params:
        os.path.join(NANORECEPTOR,"{sample}")
    threads:
        BigJobCpu
    resources:
        mem_mb=BigJobMem,
        time=BigTime
    conda:
        os.path.join('..', 'envs','quantify.yaml')
    shell:
        """
        nanoreceptor.py -i {input[0]} -o {params[0]} -t {threads} -p {wildcards.sample}
        """






