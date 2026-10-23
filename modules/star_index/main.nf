#!/usr/bin/env nextflow

nextflow.enable.types = true

record StarIdx {
    fasta: Path
    gtf: Path
}

process STAR_INDEX {
    label 'process_high'
    container 'ghcr.io/bu-cds-bf528/star:latest'

    input:
    genome: StarIdx

    output:
    file("star_index")

    script:
    """
    mkdir star_index
    STAR --runThreadN $task.cpus --runMode genomeGenerate --genomeDir star_index --genomeFastaFiles $genome.fasta --sjdbGTFfile $genome.gtf
    """

    stub:
    """
    mkdir star_index
    """

}