#!/bin/bash -e

mkdir -p monovar_overlap_sciphi

for i in sciphi_target_onlyT/*.vcf;do
	
	id=`basename ${i%%_sciphi.onlyT.target.vcf}` 
	name=`basename $i`
	bgzip -c $i > $i.gz
	bgzip -c monovar_onlyT/$id.monovar.onlyt.vcf > monovar_onlyT/$id.monovar.onlyt.vcf.gz
	bcftools index $i.gz
	bcftools index monovar_onlyT/$id.monovar.onlyt.vcf.gz
	echo $id
	bcftools isec -c all $i.gz monovar_onlyT/$id.monovar.onlyt.vcf.gz -p monovar_overlap_sciphi/$id 
	cp monovar_overlap_sciphi/$id/0003.vcf monovar_overlap_sciphi/$id.monovar_overlap_sciphi.onlyT.target.vcf

done
