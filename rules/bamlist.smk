rule create_bamlist:
        input:
            check=rules.samtools_index.output.index
        params:
            genome="{genome}"
        output:
            list=config['results_loc']+"/bams/{genome}.bamlist.txt"
        shell:
            "find /datahome/Ircinia/metagenomeSNP/results/bams -name '*{params.genome}*sorted.removeDups.bam' > {output.list} "
