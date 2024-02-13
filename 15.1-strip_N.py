#!/usr/bin/env python

#This script removes leading and trailing Ns od sequences
#It also removes sequences with less than 100 bp
#In case input is anlignment, it additionally removes gaps and returns sequences
#Input path is the first argument and output the second


from Bio import SeqIO
from Bio.Seq import Seq
from Bio.Alphabet.IUPAC import IUPACAmbiguousDNA
import sys, numpy

infile=sys.argv[1]
outfile=sys.argv[2]

records = list()

for rec in SeqIO.parse(infile, 'fasta', IUPACAmbiguousDNA()):
	rec.seq = Seq(str(rec.seq).replace('-','').strip('n'), IUPACAmbiguousDNA()) #remove gaps and leading or trailing Ns
	if len(rec.seq) >= 100: #only keep if 100 bp or larger
	    records.append(rec)

#overwrite alignment with clean sequences
SeqIO.write(records, outfile, 'fasta')

#return 3rd quartile of sequence sizes as stdout to use un UPP
sys.stdout.write('Median sequence size:' +
    str(int(numpy.quantile([len(rec.seq) for rec in records],q=0.5))) +
    '\n')
