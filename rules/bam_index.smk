# run bwa mem on combination of input read and assembly

rule samtools_index:
        input:
            bam=config['results_loc']+"/bams/{sample}.{genome}.sorted.removeDups.bam"
        output:
            index=config['results_loc']+"/bams/{sample}.{genome}.sorted.removeDups.bam.bai",
        shell:  "samtools index {input.bam} && touch {output.index}"
