#!/usr/bin/env bash

cd build || exit
make -j8

FOLDER="../tests/"
TAR_FOLDER="../tests/success/"
EXEC_FOLDER="../outs/exec/"
LL_FOLDER="../outs/ll/"
ASM_FOLDER="../outs/asm/"

echo "$FOLDER"
for file in "$FOLDER"*.sy; do
  if [ -f "$file" ]; then
    ./minic "${file}"
    return_code=$?
    if [ ${return_code} -eq 255 ]; then
        echo "${file}"
    fi
    if [ ${return_code} -eq 0 ]; then
#        mv "${file}" "${TAR_FOLDER}"
        file_name_sy=${file:9}
        file_name=${file_name_sy:0:${#file_names_sy}-2}
        llc -filetype=asm "${LL_FOLDER}${file_name}ll" -o "${ASM_FOLDER}${file_name}s"
    fi
  fi
done
#echo "${1}"
#./minic "${1}"
#return_code=$?
#echo ${return_code}
cd ..
#mv build/*.ll  outs/
