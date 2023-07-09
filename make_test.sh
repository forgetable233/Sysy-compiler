#!/usr/bin/env bash

cd build || exit
make -j8

FOLDER="../tests/"
TAR_FOLDER="../tests/success/"
EXEC_FOLDER="../outs/exec/"
LL_FOLDER="../outs/ll/"
ASM_FOLDER="../outs/asm/"
LINK_LIB="../lib/sylib.a"

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
      llc -filetype=obj "${LL_FOLDER}${file_name}ll" -o "${ASM_FOLDER}${file_name}o"
    fi
  fi
done

for file in "$ASM_FOLDER"*.o; do
  #  echo ${file}
  file_name_o=${file:12}
  file_name=${file_name_o:0:${#file_name_o}-2}
  clang -o "${EXEC_FOLDER}${file_name}" "${file}" -L "${LINK_LIB}"
done

for file in "${EXEC_FOLDER}"*; do
  in_file=${FOLDER}${file:13:${#file}}.in
  # shellcheck disable=SC2086
  if [ -f ${in_file} ]; then
    echo "find"
    ./${file} <${in_file}
  else
    ./${file}
  fi
  return_code=$?
  echo "${return_code}"
done
#echo "${1}"
#./minic "${1}"
#return_code=$?
#echo ${return_code}
cd ..
#mv build/*.ll  outs/
