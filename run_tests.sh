#!/bin/bash

for file in tst/*.s; do
  echo "Running test $file"
  exe=${file%.s}
  $exe | diff --color -y - $exe.out.txt
done
