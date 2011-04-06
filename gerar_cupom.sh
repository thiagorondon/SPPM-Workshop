#!/bin/sh


NUM=${1-1}
DISCOUNT=${2-100}

until [ $NUM -le 0 ] ; do
	CUPOM=$(cat /dev/urandom|tr -dc "A-Z0-9"|fold -w 10|head -n1)
	sqlite3 sppw.db "INSERT INTO cupom VALUES ('$CUPOM', '', '$DISCOUNT')";
	echo "Inserindo $CUPOM com desconto de $DISCOUNT reais."
	NUM=$[$NUM-1]
done

