#!/bin/bash
for i in 16011 17004 17005 17008 17011 17012 17017 17028 17029 17030 18001;do

	cat pileup_module.sl |sed "s|xxxxx|$i|g" > $i.mpileup.sl
	sbatch $i.mpileup.sl


done     

