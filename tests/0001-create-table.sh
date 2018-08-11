#!/usr/bin/env bash

if [ -f $1 ]
then
  CLIENTPATH=$1
else

if [ -f $(pwd)/../../cmake-build-debug/dbms/programs/clickhouse ]
then
    CLIENTPATH=$(pwd)"/../../cmake-build-debug/dbms/programs/clickhouse client"
elif [ -f $(pwd)/../../build/dbms/programs/clickhouse ]
then
    CLIENTPATH=$(pwd)"/../../build/dbms/programs/clickhouse client"
elif [ $(which clickhouse-client) ]
then
    CLIENTPATH="clickhouse-client"
else
    echo "Cannot locate clickhouse-client"
    echo "Usage : ./0001-create-table.sh <path/to/clickhouse-client>"
    exit 3
fi

fi

echo "============================================================="
echo "---------------------  Test Starting  -----------------------"
echo "============================================================="
echo "Using Client Path : $CLIENTPATH"
echo "============================================================="
echo " -- Step 1 : Create Table -----"
echo "============================================================="

CT_TALBE_SQL=" CREATE TABLE wikistat \
(\
    date Date,\
    time DateTime,\
    project String,\
    subproject String,\
    path String,\
    hits UInt64,\
    size UInt64\
) ENGINE = MergeTree(date, (path, time), 8192);"

CT_TALBE_SQL_2=" CREATE TABLE wikistat2 \
(\
    date Date,\
    time DateTime,\
    project String,\
    subproject String,\
    path String,\
    hits UInt64,\
    size UInt64\
) ENGINE = MergeTree(date, (path, time), 8192);"
echo "Create Table test.wikistat : $CT_TABLE_SQL"
$CLIENTPATH --database=test --query=$CT_TABLE_SQL
echo " ---  %%%  ---"
echo " ---  %%%  ---"
echo " ---  %%%  ---"
echo " ---  %%%  ---"
echo " ---  %%%  ---"
echo " ---  %%%  ---"
echo "Create Table test.wikistat2 : $CT_TABLE_SQL_2"
$CLIENTPATH --database=test --query=$CT_TABLE_SQL_2