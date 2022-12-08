"""
Snakefile for downloading transcriptomes 
"""
import os

# load default config
configfile: os.path.join(workflow.basedir, '../', 'config', 'config.yaml')


ReferenceDir = config["referenceDir"]
Species = config['species']


# needs to be created before (should exist)
if not os.path.exists(os.path.join(ReferenceDir)):
  os.makedirs(os.path.join(ReferenceDir))

if SPECIES == 'Rat':
    Fasta = 'Rattus_norvegicus.mRatBN7.2.dna.toplevel.fa.gz'
    FastaUrl = 'ftp://ftp.ensembl.org/pub/release-108/fasta/rattus_norvegicus/dna/Rattus_norvegicus.mRatBN7.2.dna.toplevel.fa.gz'
    FastaGunzipped = 'Rattus_norvegicus.mRatBN7.2.dna.toplevel.fa'
    FastaGunzippedIndex = 'Rattus_norvegicus.mRatBN7.2.dna.toplevel.fa.fai'
    Gtf = 'Rattus_norvegicus.mRatBN7.2.108.gtf.gz'
    GtfUrl = 'ftp://ftp.ensembl.org/pub/release-108/gtf/rattus_norvegicus/Rattus_norvegicus.mRatBN7.2.108.gtf.gz'
    GtfGunzipped = 'Rattus_norvegicus.mRatBN7.2.108.gtf'
elif SPECIES == 'Human':
    Fasta = 'Homo_sapiens.GRCh38.dna.toplevel.fa.gz'
    FastaUrl = 'ftp://ftp.ensembl.org/pub/release-108/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.toplevel.fa.gz'
    FastaGunzipped = 'Homo_sapiens.GRCh38.dna.toplevel.fa'
    FastaGunzippedIndex = 'Homo_sapiens.GRCh38.dna.toplevel.fa.fai'
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
    shell:
        """
        wget -c {params[0]} -O {output[1]}
        touch {output[0]}
        """

rule gunzip_fasta:
    """Rule to Download rat fasta."""
    input:
        os.path.join(ReferenceDir, Fasta)
    output:
        os.path.join(ReferenceDir, FastaGunzipped)
    threads:
        1
    shell:
        """
        gunzip {input[0]}
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