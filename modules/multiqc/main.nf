#!/usr/bin/env nextflow

nextflow.enable.types = true

process MULTIQC {
    label 'process_low'
    container 'ghcr.io/bu-cds-bf528/multiqc:latest'

    input:
    multiqc_files: List<Path>

    output:
    file("multiqc_report.html")

    script:
    """
    multiqc .
    """

    stub:
    """
    touch multiqc_report.html
    """
}