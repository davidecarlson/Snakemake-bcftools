# run bwa mem on combination of input read and assembly

rule bwa_mem:
        input:
            index=rules.bwa_index.output.done,
            ref=config['assemblies']+"/{genome}.filtered.fna",
            fwd=config['fastqs']+"/{sample}_clean_R1.fq",
            rev=config['fastqs']+"/{sample}_clean_R2.fq"
        output:
            bam=temp(config['results_loc']+"/bams/{sample}.{genome}.bam")
        threads:
            6
        params:
            rg=r"@RG\tID:{sample}\tSM:{sample}"
        log:    config['results_loc']+"/logs/bwa/{sample}.{genome}.log"
        shell:  "bwa mem -R '{params.rg}' -t {threads} {input.ref} {input.fwd} {input.rev} | samtools view -bS - > {output.bam} 2> {log}"
