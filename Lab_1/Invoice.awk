BEGIN{
FS=":"
}

{
ID=$1
DATE=$2
NAME=$3
TOTAL=$4
printf("INSERT INTO %s.%s VALUES("ID",\""DATE"\",\""NAME"\","TOTAL");"),DATABASE,T1
}
