#!/usr/bin/env python

import os
import argparse
import re
import glob

parser = argparse.ArgumentParser(description="script to find and remove bam files based on sample ID")

parser.add_argument('--sample', required=True, help='sample ID', action='store')
#parser.add_argument('--dry', required=True, default=True, type=bool, choices=[True, False], help='print matching files but do not delete', action='store_false')
parser.add_argument('--execute', required=False, default=False, help='remove the matching files instead of performing dry-run', action='store_true')  

args=parser.parse_args()

sample = args.sample


expression1 = '.*/' + sample + '.*[0-9]+.bam'
expression2 = '.*/' + sample + '.*[0-9]+.sorted.bam'

pattern1 = re.compile(expression1)
pattern2 = re.compile(expression2)

if args.execute == False:

    for filename in glob.glob('resultsall/bams/*.bam'):
        #print(filename)
        if pattern1.match(filename) or pattern2.match(filename):
            print("Matched: " + filename)

else:

    for filename in glob.glob('resultsall/bams/*.bam'):
        #print(filename)
        if pattern1.match(filename) or pattern2.match(filename):
            print("Deleting: " + filename)
            try:
                os.remove(filename)
            except EnvironmentError:
                print("You don't have permission to delete that!")
                pass


