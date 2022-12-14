# giantpandrna

ONT Long-read cDNA quanitification pipeline using Bambu

Assumes DCS109 (default) or PCS109 kits used to generate libraries. Will add direct RNA when I get some data :)

```
git clone "https://github.com/gbouras13/giantpandrna.git"
cd giantpandrna/
pip install -e .
giantpandrna --help
giantpandrna install --help
giantpandrna run --help
```


Pipeline Steps
========

For each sample (steps 1-4):

1. Runs pychopper on the  input reads (qc.smk)
2. If you have DCS109, runs pychopper resuce mode to rescue more unclassified reads (qc.smk), then aggreagates all full length and rescued reads (qc.smk). You may want these high quality reads downstream for other application. 
3. Maps all input (not QC'd) reads using minimap2 against your chosen transcriptome (align.smk).
4. Sorts bam and calculates statistics (align.smk).
5. Runs [nanoreceptor](https://github.com/gbouras13/NanoReceptor) on the input reads to identify immunoglobulin counts in each sample.

Once 4. has finished for all samples:

6. Runs [bambu](https://github.com/GoekeLab/bambu) on all input aligned bams.


Input
=======

* giantpandrna requires an input csv file with 2 columns
* Each row is a sample
* Column 1 is the sample name, column 2 is the long read ONT fastq file in  *fastq.gz format.
* No headers

e.g.


sample1,sample1_long_read.fastq.gz

sample2,sample2_long_read.fastq.gz


Usage
=======

First, you need to specify a species and an output directory to install the transcriptome database using `giantpandrna install`.


For now species are limited to Rat and Human. They are taken from ensembl release 108.

```
giantpandrna install --species Rat --referenceDir RatDB
```

After that has finished, run the pipeline, specifying the species and reference directory:

```
giantpandrna run --input <input.csv> --output <output_dir> --threads <threads>  --species Rat --referenceDir RatDB --kit DCS109
```

I would highly highly recommend running giantpandrna using a Snakemake profile. Please see this blog [post](https://fame.flinders.edu.au/blog/2021/08/02/snakemake-profiles-updated) for more details. I have included an example slurm profile in the profile directory, but check out this [link](https://github.com/Snakemake-Profiles) for more detail on other HPC job scheduler profiles. 

```
giantpandrna run --input <input.csv> --output <output_dir> --threads <threads>  --species Rat --referenceDir RatDB --profile profiles/giantpandrna
```

```
Usage: giantpandrna run [OPTIONS] [SNAKE_ARGS]...

  Run giantpandrna

Options:
  --input TEXT                  Input file/directory  [required]
  --species [Rat|Human]         Species  [default: Rat]
  --kit [DCS109|PCS109]         Kit  [default: DCS109]
  --referenceDir TEXT           Reference Directory for Transcriptomes
                                [default: Database]
  --output PATH                 Output directory  [default: giantpandrna.out]
  --configfile TEXT             Custom config file [default:
                                (outputDir)/config.yaml]
  --threads INTEGER             Number of threads to use  [default: 1]
  --use-conda / --no-use-conda  Use conda for Snakemake rules  [default: use-
                                conda]
  --conda-prefix PATH           Custom conda env directory
  --snake-default TEXT          Customise Snakemake runtime args  [default:
                                --rerun-incomplete, --printshellcmds,
                                --nolock, --show-failed-logs]
  -h, --help                    Show this message and exit.
```