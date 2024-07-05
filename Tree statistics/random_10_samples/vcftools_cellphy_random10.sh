#!/bin/bash -e

for i in ../*.vcf.list;do

	id=`echo $(basename $i)|cut -d "." -f1` 
	cat $i|sort|sed -n '1p' > $id.list
	cat $i|sort|sed '1d'|shuf -n 10 --random-source=<(yes 12345) >>$id.list

	vcftools --vcf ../$id.*.newname.vcf --keep $id.list --recode --stdout > $id.random10.vcf

#	~/tools/cellphy/cellphy_orig.sh SEARCH -m GT16+FO -t 18 -y -z $id.random10.vcf
	~/tools/cellphy/cellphy_orig.sh RAXML --msa $id.random10.vcf --search --model GT16+FO --seed 12345 --threads 18 --tree pars{50},rand{50} --force perf_threads
done
