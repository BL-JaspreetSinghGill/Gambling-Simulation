#!/bin/bash -x

#GAMBLER SIMULATION : USE CASE 3 -> AS A CALCULATIVE GAMBLER IF WON OR LOST 50% OF THE STAKE, WOULD RESIGN FOR THE DAY.

EACH_DAY_STAKE=100;
BET_PRICE=1;
IS_WON=1;
EACH_DAY_LOSS_LIMIT=$(( $EACH_DAY_STAKE-$(( $EACH_DAY_STAKE*50/100)) ));
EACH_DAY_WIN_LIMIT=$(( $EACH_DAY_STAKE+$(( $EACH_DAY_STAKE*50/100)) ));

userAmount=$EACH_DAY_STAKE;

gamble () {
	if [ $((RANDOM%2)) -eq $IS_WON ]
	then
		echo "YOU WON " $BET_PRICE;
		userAmount=$(( $userAmount+$BET_PRICE ));
	else
		echo "YOU LOST "$BET_PRICE;
		userAmount=$(( $userAmount-$BET_PRICE ));
	fi;

	echo "USER CURRENT BALANCE : " $userAmount;
}

eachDayResult () {
	if [ $userAmount -eq $EACH_DAY_LOSS_LIMIT  ]
	then
		echo "YOU LOST!!! LIMIT REACHED";
	else
		echo "YOU WON!!! GOAL ACHIEVED";
	fi;
}

gamblerMain () {
	while [[ $userAmount -gt $EACH_DAY_LOSS_LIMIT && $userAmount -lt $EACH_DAY_WIN_LIMIT ]]
	do
		gamble;
	done;
	eachDayResult;

	echo "USER FINAL BALANCE : " $userAmount;
}

gamblerMain;
