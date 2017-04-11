rundir=`dirname $0`
cd $rundir
until [ -e @root ]
do
  s=$(basename `pwd`)"/$s"
  cd ..
done
echo \*\*\*\*\* DosPath: $s \*\*\*\*\*

/Applications/DOSBox.app/Contents/MacOS/DOSBox -c "c:" -c "cd $s" -c "run.bat" -exit; exit;