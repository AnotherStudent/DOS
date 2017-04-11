#!/bin/bash

rundir=`dirname $0`
cd $rundir
until [ -e @root ]
do
  s=$(basename `pwd`)"/$s"
  cd ..
done
echo \*\*\*\*\* DosPath: $s \*\*\*\*\*

DOSBox.app/Contents/MacOS/DOSBox -conf "DOSBox Preferences" -c "c:" -c "cd $s" -c "debug.bat"
