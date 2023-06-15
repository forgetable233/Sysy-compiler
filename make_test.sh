#!/usr/bin/env bash

cd build || exit
make -j8

# shellcheck disable=SC2034
FOLDER="../tests/"
TAR_FOLDER="../tests/success/"
# shellcheck disable=SC1073
echo "$FOLDER"
for file in "$FOLDER"*.sy; do
  if [ -f "$file" ]; then
    echo "$file"
    ./minic "${file}"
    return_code=$?
    if [ ${return_code} -eq 255 ]; then
        echo "${file}"
    fi
    if [ ${return_code} -eq 0 ]; then
        mv "${file}" "${TAR_FOLDER}"
    fi
  fi
done
#echo "${1}"
#./minic "${1}"
#return_code=$?
#echo ${return_code}
cd ..
mv build/*.ll  outs/
