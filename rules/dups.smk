# run bwa mem on combination of input read and assembly

rule remove_dups:
        input:
            sorted=config['results_loc']+"/bams/{sample}.{genome}.sorted.bam"
        output:
            dup_removed=config['results_loc']+"/bams/{sample}.{genome}.sorted.removeDups.bam",
            metrics=config['results_loc']+"/bams/{sample}.{genome}.sorted.metrics"
        threads:
            6
        log:    config['results_loc']+"/logs/picard/{sample}.{genome}.log"
        shell:  "picard MarkDuplicates TMP_DIR=$(pwd)/tmp VALIDATION_STRINGENCY=LENIENT MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=1000 "
                "AS=TRUE REMOVE_DUPLICATES=TRUE METRICS_FILE={output.metrics} INPUT={input.sorted} OUTPUT={output.dup_removed} 2> {log}"
