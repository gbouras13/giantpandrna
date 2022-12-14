"""
Snakefile for downloading transcriptomes 
"""
import os

# load default config
configfile: os.path.join(workflow.basedir, '../', 'config', 'config.yaml')

# config
ReferenceDir = config["referenceDir"]
Species = config['species']

# snakemake params 
BigJobMem = config["BigJobMem"]
BigJobCpu = config["BigJobCpu"]
SmallJobMem = config["SmallJobMem"]
SmallJobCpu = config["SmallJobCpu"]

SmallTime = config["SmallTime"]
BigTime = config["BigTime"]
MediumTime = config["MediumTime"]
MassiveTime = config["MassiveTime"]


# needs to be created before (should exist)
if not os.path.exists(os.path.join(ReferenceDir)):
  os.makedirs(os.path.join(ReferenceDir))

# primary assembly not top level
# https://github.com/lh3/minimap2/issues/37

if Species == 'Rat':
    Fasta = 'Rattus_norvegicus.mRatBN7.2.dna.toplevel.fa.gz'
    FastaUrl = 'ftp://ftp.ensembl.org/pub/release-108/fasta/rattus_norvegicus/dna/Rattus_norvegicus.mRatBN7.2.dna.toplevel.fa.gz'
    FastaGunzipped = 'Rattus_norvegicus.mRatBN7.2.dna.toplevel.fa'
    FastaGunzippedIndex = 'Rattus_norvegicus.mRatBN7.2.dna.toplevel.fa.fai'
    Gtf = 'Rattus_norvegicus.mRatBN7.2.108.gtf.gz'
    GtfUrl = 'ftp://ftp.ensembl.org/pub/release-108/gtf/rattus_norvegicus/Rattus_norvegicus.mRatBN7.2.108.gtf.gz'
    GtfGunzipped = 'Rattus_norvegicus.mRatBN7.2.108.gtf'
elif Species == 'Human':
    Fasta = 'Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz'
    FastaUrl = 'ftp://ftp.ensembl.org/pub/release-108/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz'
    FastaGunzipped = 'Homo_sapiens.GRCh38.dna.primary_assembly.fa'
    FastaGunzippedIndex = 'Homo_sapiens.GRCh38.dna.primary_assembly.fa.fai'
    Gtf = 'Homo_sapiens.GRCh38.108.gtf.gz'
    GtfUrl = 'ftp://ftp.ensembl.org/pub/release-108/gtf/homo_sapiens/Homo_sapiens.GRCh38.108.gtf.gz'
    GtfGunzipped = 'Homo_sapiens.GRCh38.108.gtf'


rule all:
    input:
        os.path.join(ReferenceDir,'download_fasta.dlflag'),
        os.path.join(ReferenceDir,'download_gtf.dlflag'),
        os.path.join(ReferenceDir, 'unzip.dlflag'),
        os.path.join(ReferenceDir, FastaGunzippedIndex)


rule download_fasta:
    """Rule to Download  fasta."""
    params:
        FastaUrl
    output:
        os.path.join(ReferenceDir,'download_fasta.dlflag'),
        os.path.join(ReferenceDir, Fasta)
    threads:
        1
    resources:
        mem_mb=SmallJobMem,
        time=BigTime
    shell:
        """
        wget -c {params[0]} -O {output[1]}
        touch {output[0]}
        """

rule download_gtf:
    """Rule to Download rat gtf."""
    params:
        GtfUrl
    output:
        os.path.join(ReferenceDir,'download_gtf.dlflag'),
        os.path.join(ReferenceDir, Gtf)
    threads:
        1
    resources:
        mem_mb=SmallJobMem,
        time=BigTime
    shell:
        """
        wget -c {params[0]} -O {output[1]}
        touch {output[0]}
        """

rule gunzip:
    """gunzip files."""
    input:
        os.path.join(ReferenceDir, Fasta),
        os.path.join(ReferenceDir, Gtf)
    output:
        os.path.join(ReferenceDir, FastaGunzipped),
        os.path.join(ReferenceDir, GtfGunzipped),
        os.path.join(ReferenceDir, 'unzip.dlflag')
    threads:
        1
    resources:
        mem_mb=SmallJobMem,
        time=BigTime
    shell:
        """
        gunzip {input[0]}
        gunzip {input[1]}
        touch {output[2]}
        """

rule index_fasta:
    """index fasta for bambu"""
    input:
        os.path.join(ReferenceDir, FastaGunzipped)
    output:
        os.path.join(ReferenceDir, FastaGunzippedIndex)
    threads:
        1
    resources:
        mem_mb=SmallJobMem,
        time=MediumTime
    conda:
        os.path.join('envs','align.yaml')
    shell:
        "samtools faidx {input[0]}"