# step 1 index the genome

rule bwa_index:
        input:
                ref=config['assemblies']+"/{genome}.filtered.fna"
        output:
                done=config['results_loc']+"/index/{genome}.index.completed"
        priority:
            50
        shell: "bwa index {input.ref} && touch {output.done}"

