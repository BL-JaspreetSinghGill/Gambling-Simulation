#!/bin/bash -x

#GAMBLER SIMULATION : USE CASE 1 -> AS A GAMBLER, START WITH A STAKE OF $100 EVERY DAY AND BET $1 EVERY GAME.

EACH_DAY_STAKE=100;
BET_PRICE=1;
IS_WON=1;
LIMIT=10;

counter=0;

gamble () {
	if [ $((RANDOM%2)) -eq $IS_WON ]
	then
		echo "YOU WON " $BET_PRICE;
	else
		echo "YOU LOST "$BET_PRICE;
	fi;
}

gamblerMain () {
	while [ $counter -lt $LIMIT ]
	do
		gamble;
		(( counter++ ));
	done;
}

gamblerMain;
