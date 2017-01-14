#!/bin/bash
if [[ $# -eq 0 ]] ; then
    echo '[path] [[CV_FACTOR]] [[SAMPLE_SIZE]]'
    exit 1
fi

LOCATION=$1

CV_FACTOR=${2:-0.08}
SAMPLE_SIZE=${3:-8}
CV_SAMPLE_SIZE=$((SAMPLE_SIZE/2))

echo "Creating $LOCATION"

mkdir -p $LOCATION
cd $LOCATION


echo "Removing generated dirs"

rm test -rf
rm train -rf
rm valid -rf
rm sample -rf

if [ ! -f train.zip ]; then
echo "Download dataset"
kg download
fi

echo "Extract test & train"
unzip -q test.zip
unzip -q train.zip

mkdir valid
mkdir -p sample/train
mkdir -p sample/valid


echo "Creating classes"
#ls train/*.jpg | awk '{print gensub(/^.*\/([^\.]*)\..*$/,"\\1","g",$1)}' | uniq
#                 awk '{print gensub(/^.*\/([^\.]*)\..*$/,"\\1","g",$1)}' | uniq
#for p in `ls $LOCATION/train/*.jpg | awk '{print gensub(/^.*\/([^\.]*)\..*$/,"\\1","g",$1)}'`; do
#    echo $p
#done

for prefix in `ls $LOCATION/train/*.jpg | awk '{print gensub(/^.*\/([^\.]*)\..*$/,"\\\1","g",$1)}' | uniq` ; do
	if [ ! -z "$prefix" ]; then
	    DIR=${prefix}s
	    echo "Working in $DIR ($prefix)"
	    mkdir train/$DIR sample/train/$DIR
	    mkdir valid/$DIR sample/valid/$DIR
	    mv "train/$prefix."*".jpg" "train/$DIR"
	    TOTAL=`find train/$DIR -type f | wc -l`
	    TOPd=`echo "$TOTAL * $CV_FACTOR" | bc`
	    TOP=`printf '%.0f' $TOPd`
	    echo "Moving $TOP from $TOTAL to valid"
	    ls train/$DIR | sort -R | head -n $TOP | xargs -I@ sh -c "mv train/$DIR/@ valid/$DIR/@"
	    ls train/$DIR | sort -R | head -n $SAMPLE_SIZE | xargs -I@ sh -c "cp train/$DIR/@ sample/train/$DIR/@"
	    ls valid/$DIR | sort -R | head -n $CV_SAMPLE_SIZE | xargs -I@ sh -c "cp valid/$DIR/@ sample/valid/$DIR/@"
	fi
done


#ls train/*.jpg | awk '{gsub(/\..*$/,"", $1);print}' | uniq | xargs -d"\n" -I"{}" mkdir {}s

#ls train/*.jpg | awk '{print $1 " "gensub(/\/([^\.]*)\./,"/\\1s/", "g",$1)}'  | xargs -n2 mv
#ls train/*.jpg | awk '{gsub(/\..*$/,"", $1);print}' | uniq | xargs -I"{}" sh -c 'mv {}.*.jpg {}s'

#for d in train/* ; do
#    TOTAL=`ls $d | sort -R | wc -l`
#    TOPd=`echo "$TOTAL * $SAMPLE_FACTOR" | bc`
#    TOP=`printf '%.0f' $TOPd`
#    echo $TOP
#    ls $d | sort -R | head -n $TOP | xargs
#done

#rm test.zip
#rm train.zip 



