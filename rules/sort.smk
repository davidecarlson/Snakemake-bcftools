# run bwa mem on combination of input read and assembly

rule samtools_sort:
        input:
            unsorted=config['results_loc']+"/bams/{sample}.{genome}.bam"
        output:
            sorted=temp(config['results_loc']+"/bams/{sample}.{genome}.sorted.bam")
        threads:
            6
        log:    config['results_loc']+"/logs/samtools/{sample}.{genome}.log"
        shell:  "samtools sort --threads {threads} -o {output.sorted} {input.unsorted} 2> {log}"
