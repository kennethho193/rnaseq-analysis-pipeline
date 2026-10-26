#!/usr/bin/env nextflow

nextflow.enable.types = true

process CONCAT_CTS{
    label 'process_low'
    container 'ghcr.io/bu-cds-bf528/pandas:latest'

    input:
    verse_files: List<Path>

    output:
    file("counts_matrix.csv")

    script:
    """
    concat_cts.py -i ${verse_files} -o counts_matrix.csv
    """

    stub:
    """
    touch counts_matrix.csv
    """
}