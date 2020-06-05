#!/bin/bash

echo 'running tests...'

ulimit -s unlimited
wordsfile=/usr/share/dict/words
baseaddr=0x440000000000 # System specific - see README.txt
./_build/default/test_ancient_dict_write.exe $wordsfile dictionary.data $baseaddr
./_build/default/test_ancient_dict_verify.exe $wordsfile dictionary.data
./_build/default/test_ancient_dict_read.exe dictionary.data <<EOF
dog
cat
q
EOF
