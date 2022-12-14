searchdir='/computer_architecture/ACA2/resource'
systolicdir='/computer_architecture/systolic.txt'
if [ -f "/computer_architecture/ACA2/GEN_CYCLE" ];
then
    echo "compute systolic in ACA2/resource"
else
    echo "make /computer_architecture/ACA2"
    make -C /computer_architecture/ACA2/ clean
    make -C /computer_architecture/ACA2/
fi
cp $systolicdir $searchdir/systolic.txt
rm -rf /computer_architecture/result/*

for file in $searchdir/*_summary.txt
do 
    echo $file
    model_name="${file#/*/*/*/}" # get model_name
    echo $model_name
    /computer_architecture/ACA2/GEN_CYCLE $searchdir/systolic.txt $file > "/computer_architecture/result/cycle_$model_name"
done
