#!/usr/bin/env nextflow

nextflow.enable.types = true

process PARSE_GTF {
    label 'process_low'
    container 'ghcr.io/bu-cds-bf528/biopython:latest'

    input:
    gtf: Path

    output:
    file("geneIDs.txt")

    script:
    """
    parse_gtf.py -i $gtf -o geneIDs.txt
    """

    stub:
    """
    touch geneIDs.txt
    """
}