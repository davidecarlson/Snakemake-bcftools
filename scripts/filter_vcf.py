#!/usr/bin/env python

import os
from cyvcf2 import VCF
import statistics as stats
import math
import subprocess
import multiprocessing
import glob
import argparse


parser = argparse.ArgumentParser(description="Parallelized vcf filtering with bcftools")

parser.add_argument('--outdir', required=True, help='Output directory where filtered VCFS will be written', action='store')
parser.add_argument('--threads', type=int, required=False, default=1, help='Number of threads to use. Default is 1', action='store')

args=parser.parse_args()

#make the output directory if it doesn't already exist

outdir = args.outdir

if not os.path.exists(outdir):
        os.makedirs(outdir)

def filter_dp(vcf_file):
    id = vcf_file.split('.')[1]
    output = outdir + '/all_samples.' + id + '.filtered.vcf'
    depth= []
    # get list of depth scores
    for variant in VCF(vcf_file):
        depth.append(variant.INFO.get('DP'))    
    # get depth cutoff based on Li 2014
    cutoff = stats.mean(depth) + 3*math.sqrt(stats.mean(depth))
    filter_expr = 'DP > ' + str(cutoff)
    # use bcftools to apply filters
    subprocess.run(args=['bcftools', 'filter', '-g3', '-e', filter_expr,
    '-s', 'postFilter', '-Ov', '-o', output, vcf_file])
     

variants = glob.glob('resultsall/vcfs/*.vcf')

# Parallelize vcf filtering with multiprocessing

p = multiprocessing.Pool(processes=args.threads)

for vcf in variants:
    print("Applying filters to " + vcf)
    p.apply_async(filter_dp, [vcf])

p.close()
p.join() # Wait for all child processes to close.
   
