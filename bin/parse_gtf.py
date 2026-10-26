#!/usr/bin/env python

import argparse
import re

parser = argparse.ArgumentParser()
parser.add_argument("-i", "--input", help="GTF file", dest="input", required=True)
parser.add_argument("-o", "--output", help="output gene ID to gene name mapping", dest="output", required=True)
args = parser.parse_args()

gene_id_pattern = re.compile(r'gene_id "([^"]+)"')
gene_name_pattern = re.compile(r'gene_name "([^"]+)"')

with open(args.input, "r") as gtf, open(args.output, "w") as out:
    out.write("gene_id\tgene_name\n")
    for line in gtf:
        if line.startswith("#"):
            continue
        fields = line.rstrip("\n").split("\t")
        if fields[2] != "gene":
            continue
        gene_id = gene_id_pattern.search(fields[8]).group(1)
        gene_name_match = gene_name_pattern.search(fields[8])
        gene_name = gene_name_match.group(1) if gene_name_match else gene_id
        out.write(f"{gene_id}\t{gene_name}\n")