# echo
if [ $1 ] then
    DB_NAME=$1
else
    echo "Usage : <db_name> <table_name> <path-to-client>"
    exit 1
fi

if [ $2 ] then
    TABLE_NAME=$2
else
    echo "Usage : <db_name> <table_name> <path-to-client>"
    exit 2
fi

if [ $3 ] then
    CLIENTPATH=$3
else
    echo "Usage : <db_name> <table_name> <path-to-client>"
    exit 2
fi


if [ -e data.csv ]
then
    ls -l data.csv
    echo " data.csv ready."
else
    echo "Please prepare data.csv to insert to the test table"
    exit 3
fi

# arg1=start, arg2=end, format: %s.%N
function getTiming() {
    start=$1
    end=$2
    start_s=$(echo $start | cut -d '.' -f 1)
    start_ns=$(echo $start | cut -d '.' -f 2)
    end_s=$(echo $end | cut -d '.' -f 1)
    end_ns=$(echo $end | cut -d '.' -f 2)
# for debug..
#    echo $start
#    echo $end
    time=$(( ( 10#$end_s - 10#$start_s ) * 1000 + ( 10#$end_ns / 1000000 - 10#$start_ns / 1000000 ) ))
    echo "$time ms"
}

echo "---------------------  CMD Line:   ---------------------"
echo "cat data.csv | $CLIENTPATH --database=$DB_NAME --query=INSERT INTO $TABLE_NAME FORMAT CSV"
echo "--------------------------------------------------------"

echo "--------------------------------------------------------"
echo "Starting Whole loading process"
echo "--------------------------------------------------------"

globalstart=$(date +%s.%N)
for i in {1..10}; do
    start=$(date +%s.%N)
    cat data.csv | $CLIENTPATH --database=$DB_NAME --query="INSERT INTO $TABLE_NAME FORMAT CSV";
    end=$(date +%s.%N)
    getTiming $start $end
done
echo "--------------------------------------------------------"
echo " --- Overall : "
getTiming $globalstart $end

#echo -ne "1, 'some text', '2016-08-14 00:00:00'\n2, 'some more text', '2016-08-14 00:00:01'" | clickhouse-client --database=test --query="INSERT INTO test FORMAT CSV";
#cat <<_EOF | clickhouse-client --database=test --query="INSERT INTO test FORMAT CSV";
#3, 'some text', '2016-08-14 00:00:00'
#4, 'some more text', '2016-08-14 00:00:01'
#_EOF