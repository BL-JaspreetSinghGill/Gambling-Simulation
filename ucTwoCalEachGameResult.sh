#!/bin/bash -x

#GAMBLER SIMULATION : USE CASE 2 -> AS A GAMBLER MAKE $1 BET SO EITHER WIN OR LOOSE $1.

EACH_DAY_STAKE=100;
BET_PRICE=1;
IS_WON=1;
LIMIT=10;

userAmount=$EACH_DAY_STAKE;

counter=0;

gamble () {
	if [ $((RANDOM%2)) -eq $IS_WON ]
	then
		echo "YOU WON " $BET_PRICE;
		userAmount=$(( $userAmount+$BET_PRICE ));
	else
		echo "YOU LOST "$BET_PRICE;
		userAmount=$(( $userAmount-$BET_PRICE ));
	fi;
}

gamblerMain () {
	while [ $counter -lt $LIMIT ]
	do
		gamble;
		(( counter++ ));
	done;

	echo "USER BALANCE : " $userAmount;
}

gamblerMain;
