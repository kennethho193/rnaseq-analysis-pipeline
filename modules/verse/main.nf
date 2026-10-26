#!/usr/bin/env nextflow

nextflow.enable.types = true

record Verse {
    name: String
    bam: Path
    log: Path
}

process VERSE {
    label 'process_medium'
    container 'ghcr.io/bu-cds-bf528/verse:latest'

    input:
    sample: Verse
    gtf: Path
    
    output:
    file("*.exon.txt")

    script:
    """
    verse -S -a ${gtf} -o ${sample.name} ${sample.bam}
    """

    stub:
    """
    touch ${sample.name}.exon.txt
    """

}