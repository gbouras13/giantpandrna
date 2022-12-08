# giantpandrna

ONT Long-read cDNA quanitification pipeline using Bambu

Assumes DCS109 (default) or PCS109 kits used to generate libraries.

```
git clone "https://github.com/gbouras13/giantpandrna.git"
cd giantpandrna/
pip install -e .
giantpandrna --help
giantpandrna install --help
giantpandrna run --help
```






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

First, you need to specify a species and an output directory to download the transcriptome to.

For now species are limited to rat and human. They are taken from ensembl release 108.

```
giantpandrna install --species Rat --referenceDir RatDB
```

After that has finished, run the pipeline, specifying the species and reference directory:

```
giantpandrna run --input <input.csv> --output <output_dir> --threads <threads>  --species Rat --referenceDir RatDB
```

I would highly highly recommend running hybracter using a Snakemake profile. Please see this blog [post](https://fame.flinders.edu.au/blog/2021/08/02/snakemake-profiles-updated) for more details. I have included an example slurm profile in the profile directory, but check out this [link](https://github.com/Snakemake-Profiles) for more detail on other HPC job scheduler profiles. 

```
giantpandrna run --input <input.csv> --output <output_dir> --threads <threads>  --species Rat --referenceDir RatDB--profile profiles/giantpandrna
```