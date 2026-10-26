#!/usr/bin/env nextflow

nextflow.enable.types = true


// use include to make your module processes available here
include {FASTQC} from './modules/fastqc'
include {PARSE_GTF} from './modules/parse_gtf'
include {STAR_INDEX} from './modules/star_index'
include {STAR_ALIGN} from './modules/star_align'
include {MULTIQC} from './modules/multiqc'
include {VERSE} from './modules/verse'
include {CONCAT_CTS} from './modules/concat_cts'

workflow {
    main:

    read_pairs_ch = channel.fromPath(params.full_reads).splitCsv(header: true).map { row -> record(name: row.name, r1: file(row.r1), r2: file(row.r2)) }
    fastq_ch = read_pairs_ch.flatMap { sample -> [record(name: sample.name, fastq: sample.r1), record(name: sample.name, fastq: sample.r2)] }

    fastqc_out = FASTQC(fastq_ch)

    parse_gtf_ch = PARSE_GTF(file(params.gtf))
    star_index_ch = STAR_INDEX(record(fasta: file(params.genome), gtf: file(params.gtf)))
    star_align_ch = STAR_ALIGN(read_pairs_ch, star_index_ch)

    multiqc_ch = fastqc_out.map {qc -> qc.zip }.mix(star_align_ch.map {aln -> aln.log}).collect()
    multiqc_out = MULTIQC(multiqc_ch)

    verse_ch = VERSE(star_align_ch, file(params.gtf))
    concat_cts_ch = CONCAT_CTS(verse_ch.collect())

    publish:
    multiqc_report = multiqc_out
    counts_matrix = concat_cts_ch
    gene_map = parse_gtf_ch
}

output {

    multiqc_report {
        path {"multiqc/"}
    }

    counts_matrix {
        path {"counts/"}
    }

    gene_map {
        path {"counts/"}
    }

}