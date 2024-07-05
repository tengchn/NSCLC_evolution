for i in ../*.bam.list;do
	cat $i |awk -F "/" '{if($NF!~"N") print $NF"\t""CT"}' > ${i%%bam.list}cellnames.txt
done
