BEGIN{
FS=":"
}

{
ID=$1
NAME=$2
TOTAL=$3
PRICE=$4
FK=$5
printf("INSERT INTO %s.%s VALUES("$1",\""$2"\","$3","$4","$5");"),DATABASE,T2
}
