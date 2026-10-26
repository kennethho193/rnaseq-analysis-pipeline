#!/usr/bin/env python
#Combine per-sample VERSE .exon.txt count files into one genes x samples counts matrix.

import argparse
import os
import pandas as pd

#Command-line arguments: one or more VERSE count files in, one CSV out
parser = argparse.ArgumentParser()
#nargs="+" accepts one or more filenames and stores them as a list in args.input
parser.add_argument("-i", "--input", help="VERSE .exon.txt count files", dest="input", nargs="+", required=True)
parser.add_argument("-o", "--output", help="output counts matrix", dest="output", required=True)
args = parser.parse_args()

#Read each sample's counts into its own one-column DataFrame
counts = []
for path in args.input:
    #Sample name is the filename up to the first "." (control_rep1.exon.txt -> control_rep1)
    sample = os.path.basename(path).split(".")[0]
    #VERSE output is tab-separated; gene IDs (first column) become the row index
    df = pd.read_csv(path, sep="\t", index_col=0)
    #Rename the "count" column to the sample name so each column is labeled
    df.columns = [sample]
    counts.append(df)

#Join samples side by side (axis=1); rows are matched by gene ID, not by position
matrix = pd.concat(counts, axis=1)
matrix.to_csv(args.output)