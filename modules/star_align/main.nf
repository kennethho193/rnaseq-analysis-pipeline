#!/usr/bin/env nextflow

nextflow.enable.types = true

record StarAlign {
    name: String
    r1: Path
    r2: Path
}

process STAR_ALIGN {
    label 'process_high'
    container 'ghcr.io/bu-cds-bf528/star:latest'

    input:
    sample: StarAlign
    index: Path

    output:
    record(name: sample.name, bam: file("*.Aligned.out.bam"), log: file("*.log.final.out"))

    script:
    """
    STAR --runThreadN $task.cpus --genomeDir $index --readFilesIn $sample.r1 $sample.r2 --readFilesCommand zcat --outFileNamePrefix ${sample.name}. --outSAMtype BAM Unsorted
    """

    stub:
    """
    touch ${sample.name}.Aligned.out.bam
    touch ${sample.name}.log.final.out
    """

}