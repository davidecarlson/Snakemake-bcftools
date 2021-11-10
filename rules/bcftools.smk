# call variants with bcftools mpileup + call, filter quality scores lower than 20 and abnormally high depth (> 200)
# should evaluate these filters

rule bcftools_call:
        input:
            ref=config['assemblies']+"/{genome}.filtered.fna",
            bam=expand(config['results_loc']+"/bams/{sample}.{genome}.sorted.removeDups.bam", sample=SAMPLES, genome=GENOMES),
            bai=expand(config['results_loc']+"/bams/{sample}.{genome}.sorted.removeDups.bam.bai", sample=SAMPLES, genome=GENOMES),
        output:
            list=config['results_loc']+"/bams/{genome}.bamlist.txt",
            vcf=config['results_loc']+"/vcfs/all_samples.{genome}.vcf"
        threads:
            2
        params:
            genome="{genome}",
            path=config['results_loc']+"/bams/"
        log:
            "results/logs/bcftools/all_samples.{genome}.log"  
        shell:
            "find /datahome/Ircinia/metagenomeSNP/resultsall/bams -name \"*{params.genome}.sorted.removeDups.bam\" > {output.list} && "
            "bcftools mpileup -f {input.ref} -Ou --bam-list {output.list} --threads {threads} | "
            "bcftools call --threads {threads} -Ou -mv --ploidy 1 | "
            "bcftools filter -s LowQual -e \"%QUAL<20\" -o {output.vcf} 2> {log}"
