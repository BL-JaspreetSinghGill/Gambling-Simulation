#!/bin/bash -x

#GAMBLER SIMULATION : USE CASE 4 -> AFTER 20 DAYS OF PLAYING EVERYDAY GET THE TOTAL AMOUNT WON OR LOST.

EACH_DAY_STAKE=100;
BET_PRICE=1;
IS_WON=1;
EACH_DAY_LOSS_LIMIT=$(( $EACH_DAY_STAKE-$(( $EACH_DAY_STAKE*50/100)) ));
EACH_DAY_WIN_LIMIT=$(( $EACH_DAY_STAKE+$(( $EACH_DAY_STAKE*50/100)) ));
DAYS=20;

userTotalAmount=0

assignEachDayStakeValue () {
	userEachDayAmount=$EACH_DAY_STAKE;
}

gamble () {
	if [ $((RANDOM%2)) -eq $IS_WON ]
	then
		#echo "YOU WON " $BET_PRICE;
		userEachDayAmount=$(( $userEachDayAmount+$BET_PRICE ));
	else
		#echo "YOU LOST "$BET_PRICE;
		userEachDayAmount=$(( $userEachDayAmount-$BET_PRICE ));
	fi;

	#echo "USER CURRENT BALANCE : " $userEachDayAmount;
}

eachDayResult () {
	if [ $userEachDayAmount -eq $EACH_DAY_LOSS_LIMIT ]
	then
		echo "YOU LOST!!! LIMIT REACHED";
	else
		echo "YOU WON!!!! GOAL ACHIEVED";
	fi;

	userTotalAmount=$(( $userTotalAmount+$userEachDayAmount ));
}

perDayGambling () {
	while [[ $userEachDayAmount -gt $EACH_DAY_LOSS_LIMIT && $userEachDayAmount -lt $EACH_DAY_WIN_LIMIT ]]
	do
		gamble;
	done;

	eachDayResult;
}

getUserExpectedAmount () {
	days=$(( $(( 50*$DAYS ))/100 ));
	userExpectedAmount=$(( $(( $days*$EACH_DAY_WIN_LIMIT ))+$(( $days*$EACH_DAY_LOSS_LIMIT )) ));
}

gamblingMonthResult () {
	if [ $userTotalAmount -eq $userExpectedAmount ]
	then
		echo "USER WON THIS MONTH!!! BY ACHIEVING THE EXPECTED AMOUNT";
	elif [ $userTotalAmount -gt $userExpectedAmount ]
	then
		difference=$(( $userTotalAmount-$userExpectedAmount ));
		echo "USER WON THIS MONTH!!! BY " $difference;
	else
		difference=$(( $userExpectedAmount-$userTotalAmount ));
		echo "USER LOST THIS MONTH!! BY " $difference;
	fi;
}

gamblerMain () {
	for (( i=0; i<$DAYS;i++ ))
	do
		assignEachDayStakeValue;
		perDayGambling;
	done;

	getUserExpectedAmount;
	echo "EXPECTED AMOUNT FOR THIS MONTH : " $userExpectedAmount;
	echo "USER TOTAL BALANCE : " $userTotalAmount;
	gamblingMonthResult;
}

gamblerMain;
