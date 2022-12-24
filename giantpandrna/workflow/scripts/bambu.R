options(
    BIOCONDUCTOR_CONFIG_FILE = "file:///hpcfs/users/a1667917/bioconductor/config.yaml"
)

library(bambu)

bam_files <- snakemake@input[["bams"]]

fa.file <- snakemake@params[[1]]

gtf.file <- snakemake@params[[2]]

bambuAnnotations <- prepareAnnotations(gtf.file)

#### need to index the fasta first with samtools faidx 

test <- bambu(reads = bam_files, annotations = bambuAnnotations, genome = fa.file, ncore = snakemake@threads, lowMemory = TRUE)

saveRDS(test, file = snakemake@output[[1]])


