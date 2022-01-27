#!/bin/bash
version=1.0

if [ $# != 1 ]; then
    echo "need take valgrind log file!"
    echo "exmple:"
    # 这里的话, 后缀不是很重要
    echo "$0 xxx.valgrind"
fi

VALGRIND_STATIS_FILE=valgrind_statis_file
STATIS_UNINITIALISED_FILE=valgrind_uninitiased_statis.txt

DST_FOLDER=$VALGRIND_STATIS_FILE
DST_FOLDER="_"$(date +%Y%m%d%H%M%S)
DST_FILE=$DST_FOLDER/$STATIS_UNINITIALISED_FILE

mkdir $DST_FOLDER

echo 'uninitialised count:' >> $DST_FILE
cat $1 | grep uninitialised | wc -l >> $DST_FILE

echo 'uninitialised depth info:' >> $DST_FILE
cat $1 | grep 15876 | grep -A 10 'uninitialised' >> $DST_FILE