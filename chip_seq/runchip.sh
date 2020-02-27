#!/bin/sh
mkdir ~/CMM262/midterm/tagdir
for f in ~/CMM262/midterm/chipseq/*.bam; 
do fname=`basename $f -chr7.bam`;
makeTagDirectory ~/CMM262/midterm/tagdir/$fname -genome hg19 -checkGC $f;  
done

for dir in ~/CMM262/midterm/tagdir/*; 
do makeUCSCfile $dir -o auto; 
done

# generate directories for HMs, TFs, control and annotated peaks

mkdir ~/CMM262/midterm/tagdir/hms/
mkdir ~/CMM262/midterm/tagdir/tfs/
mkdir ~/CMM262/midterm/tagdir/ctr/
mkdir ~/CMM262/midterm/ann/
mkdir ~/CMM262/midterm/bed/
mv ~/CMM262/midterm/tagdir/*H*M* ~/CMM262/midterm/tagdir/hms/
mv ~/CMM262/midterm/tagdir/*control* ~/CMM262/midterm/tagdir/ctr/
mv ~/CMM262/midterm/tagdir/* ~/CMM262/midterm/tagdir/tf/

for dir in ~/CMM262/midterm/tagdir/hms/*; 
do findPeaks $dir -i ~/CMM262/midterm/tagdir/ctr/* -style histone -o auto; 
done

for dir in ~/CMM262/midterm/tagdir/hms/*;
do dname=${dir##*/}; pos2bed.pl $dir/regions.txt > ~/CMM262/midterm/bed/$dname.bed;
done

for dir in ~/CMM262/midterm/tagdir/tfs/*; 
do findPeaks $dir -i ~/CMM262/midterm/tagdir/ctr/* -style factor -o auto;
done

for dir in ~/CMM262/midterm/tagdir/tfs/*;
do dname=${dir##*/}; pos2bed.pl $dir/peaks.txt > ~/CMM262/midterm/bed/$dname.bed;
done

for dir in ~/CMM262/midterm/tagdir/hms/*; 
do dname=${dir##*/}; annotatePeaks.pl $dir/regions.txt hg19 > ~/CMM262/midterm/ann/$dname.ann.txt;
done

# annotation
for dir in ~/CMM262/midterm/tagdir/tfs/*; 
do dname=${dir##*/}; 
annotatePeaks.pl $dir/peaks.txt hg19 > ~/CMM262/midterm/ann/$dname.ann.txt; 
done


for dir in ~/CMM262/midterm/tagdir/tfs/*; 
do dname=${dir##*/}; 
mkdir ~/CMM262/midterm/tagdir/motifs/$dname; findMotifsGenome.pl $dir/peaks.txt hg19 ~/CMM262/midterm/tagdir/motifs/$dname -mask -size 100 -p 10; 
done
