CHR=`samtools view -H ../HFVFMDMXX_plate1/17004p1B02_S14_001.markdup.realigned.bam | grep ^@SQ | cut -f 2 | sed -n -e 's/^.*://p'|head -25`

for i in $CHR;do

	echo -e "/scale_wlg_persistent/filesets/project/uoa03421/tools/MonoVar/external/samtools/samtools mpileup -BQ0 -d10000 -f ../../hs37d5/hs37d5.fa -q 40 -b 17004.bam.list -r $i |~/.conda/envs/monovar/lib/monovar/monovar.py -p 0.002 -a 0.2 -t 0.05 -m 4 -f ../../hs37d5/hs37d5.fa -b 17004.bam.list -o 17004.monovar.$i.vcf" > 17004/17004.$i.sh

done
