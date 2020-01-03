#!/bin/bash -x

#GAMBLER SIMULATION : USE CASE 6 -> LUCKIEST (WON MAXIMUM) AND UNLUCKIEST (LOST MAXIMUM) DAY.

EACH_DAY_STAKE=100;
BET_PRICE=1;
IS_WON=1;
EACH_DAY_LOSS_LIMIT=$(( $EACH_DAY_STAKE-$(( $EACH_DAY_STAKE*50/100)) ));
EACH_DAY_WIN_LIMIT=$(( $EACH_DAY_STAKE+$(( $EACH_DAY_STAKE*50/100)) ));
DAYS=20;
MONTH=2;

userMonthBalance=0;
userTotalBalance=0;
goalAmount=0;
luckyDay=1;
unluckyDay=1;
minValue=10000;
maxValue=-1;

assignEachDayStakeValue () {
	userEachDayAmount=$EACH_DAY_STAKE;
}

gamble () {
	if [ $((RANDOM%2)) -eq $IS_WON ]
	then
		userEachDayAmount=$(( $userEachDayAmount+$BET_PRICE ));
		(( winCounter++ ));
	else
		userEachDayAmount=$(( $userEachDayAmount-$BET_PRICE ));
		(( lossCounter++ ));
	fi;
}

eachDayResult () {
	if [ $userEachDayAmount -eq $EACH_DAY_LOSS_LIMIT ]
	then
		echo "YOU LOST!!! LIMIT REACHED";
	else
		echo "YOU WON!!!! GOAL ACHIEVED";
	fi;

	userMonthBalance=$(( $userMonthBalance+$userEachDayAmount ));
}

checkLuckyUnLuckyDay () {
	if [ $lossCounter -lt $minValue ]
	then
		minValue=$lossCounter;
		unluckyDay="$(( $j+1 ))"":""$(( $i+1 ))";
	fi;

	if [ $winCounter -gt $maxValue ]
	then
		maxValue=$winCounter;
		luckyDay="$(( $j+1 ))"":""$(( $i+1 ))";
	fi;
}

perDayGambling () {
	winCounter=0;
	lossCounter=0;

	while [[ $userEachDayAmount -gt $EACH_DAY_LOSS_LIMIT && $userEachDayAmount -lt $EACH_DAY_WIN_LIMIT ]]
	do
		gamble;
	done;

	checkLuckyUnLuckyDay;
	eachDayResult;
}

getUserExpectedAmount () {
	days=$(( $(( 50*$DAYS ))/100 ));
	userExpectedAmount=$(( $(( $days*$EACH_DAY_WIN_LIMIT ))+$(( $days*$EACH_DAY_LOSS_LIMIT )) ));
}

getGambleExpectedAmount () {
	goalAmount=$(( $userExpectedAmount*$MONTH ));
}

getGamblingResult () {
	userCurrentBalance=$1;
	userExpectedAmount=$2;
	equalMessage=$3;
	wonMessage=$4;
	lostMessage=$5;

	if [ $userCurrentBalance -eq $userExpectedAmount ]
	then
		echo $equalMessage;
	elif [ $userCurrentBalance -gt $userExpectedAmount ]
	then
		difference=$(( $userCurrentBalance-$userExpectedAmount ));
		echo $wonMessage $difference;
	else
		difference=$(( $userExpectedAmount-$userCurrentBalance ));
		echo $lostMessage $difference;
	fi;
}

perMonthGambling () {
	for (( i=0; i<$DAYS;i++ ))
	do
		assignEachDayStakeValue;
		perDayGambling;
	done;

	getUserExpectedAmount;
	echo "EXPECTED AMOUNT FOR THIS MONTH : " $userExpectedAmount;
	echo "USER MONTHLY BALANCE : " $userMonthBalance;
	equalMessage="USER WON THIS MONTH BY ACHIEVING THE EXPECTED AMOUNT";
	wonMessage="USER WON THIS MONTH!!! BY ";
	lostMessage="USER LOST THIS MONTH!! BY ";
	getGamblingResult $userMonthBalance $userExpectedAmount "$equalMessage" "$wonMessage" "$lostMessage";
}

getUserTotalBalance () {
	userTotalBalance=$(( $userTotalBalance+$userMonthBalance ));
}

gamblerMain () {
	for (( j=0; j<$MONTH; j++ ))
	do
		echo "--------------------MONTH $(($j+1))--------------------";
		userMonthBalance=0;
		perMonthGambling;
		getUserTotalBalance;
	done;

	echo "--------------------GAMBLE RESULT--------------------";
	getGambleExpectedAmount;
	echo "GAMBLE GOAL AMOUNT : " $goalAmount;
	echo "USER TOTAL BALANCE : " $userTotalBalance;

	equalMessage="USER WON THE GAMBLE BY ACHIEVING THE EXPECTED AMOUNT";
	wonMessage="USER WON THE GAMBLE!!! BY ";
	lostMessage="USER LOST THE GAMBLE!! BY ";
	getGamblingResult $userTotalBalance $goalAmount "$equalMessage" "$wonMessage" "$lostMessage";

	echo "UNLUCKIEST DAY : " $unluckyDay "WITH LOSS OF " $minValue;
	echo "LUCKIEST DAY : " $luckyDay "WITH WIN OF " $maxValue;
}

gamblerMain;
