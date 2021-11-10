rule get_depth:
        output:
            depth=config['results_loc']+"/bams/{genome}.mean_depth.txt"
        params:
            genome="{genome}",
            path=config['results_loc']+"/bams/"
        shell:
            "ls {params.path}*{params.genome}.sorted.removeDups.bam | parallel --verbose samtools depth -a {{}} | awk '{{sum+=$3}} END {{ print sum/NR}}' > {output.depth}"
