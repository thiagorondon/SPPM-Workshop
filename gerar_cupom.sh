#!/bin/sh


NUM=${1-1}

until [ $NUM -le 0 ] ; do
	CUPOM=$(cat /dev/urandom|tr -dc "A-Z0-9"|fold -w 10|head -n1)
	sqlite3 sppw.db "INSERT INTO cupom VALUES ('$CUPOM', '')";
	echo "Inserindo $CUPOM"
	NUM=$[$NUM-1]
done

