#!/bin/bash

set -Eeuo pipefail

for file in tst/*.s; do
  echo "Running test $file"
  exe=${file%.s}
  $exe | diff --color -y - $exe.out.txt
  if [ $? -ne 0 ]; then
    echo "Test $file failed"
    exit 1
  fi
done
