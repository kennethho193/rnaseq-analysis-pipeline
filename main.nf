#!/usr/bin/env nextflow

nextflow.enable.types = true


// use include to make your module processes available here
include {FASTQC} from './modules/fastqc'
include {PARSE_GTF} from './modules/parse_gtf'
include {STAR_INDEX} from './modules/star_index'
include {STAR_ALIGN} from './modules/star_align'
include {MULTIQC} from './modules/multiqc'

workflow {
    main:

    read_pairs_ch = channel.fromPath(params.subset_reads).splitCsv(header: true).map { row -> record(name: row.name, r1: file(row.r1), r2: file(row.r2)) }
    fastq_ch = read_pairs_ch.flatMap { sample -> [record(name: sample.name, fastq: sample.r1), record(name: sample.name, fastq: sample.r2)] }

    fastqc_out = FASTQC(fastq_ch)

    parse_gtf_ch = PARSE_GTF(file(params.gtf))
    star_index_ch = STAR_INDEX(record(fasta: file(params.genome), gtf: file(params.gtf)))
    star_align_ch = STAR_ALIGN(read_pairs_ch, star_index_ch)

    multiqc_ch = fastqc_out.map {qc -> qc.zip }.mix(star_align_ch.map {aln -> aln.log}).collect()
    multiqc_out = MULTIQC(multiqc_ch)

    //publish:
}

output {



}