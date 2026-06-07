#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=number_guess -t --no-align -c"
echo -e "/e~~~~~Welcome to Guessing Game~~~~~\n"
echo "Enter your username:"
read INPUT
IFS='|' read NAME NBR BEST < <($PSQL "select * from guesser where name='$INPUT'")
if [[ -z $NAME ]]
then
echo -e "\nWelcome, $INPUT! It looks like this is your first time here."
$PSQL "insert into guesser(name) values('$INPUT');" >2
NAME=$INPUT
else
echo -e "\nWelcome back, $NAME! You have played $NBR games, and your best game took $BEST guesses."
fi
NUM=$(( RANDOM % 1000 + 1 ))
echo -e "\nGuess the secret number between 1 and 1000:"
SCORE=1
read INPUT
while [[ $INPUT -ne $NUM ]]
do
if [[ ! $INPUT =~ [0-9]+ ]]
then
echo -e "\nThat is not an integer, guess again:" 
elif [[ $NUM -lt $INPUT ]]
then
echo -e "\nIt's lower than that, guess again:"
else
echo -e "\nIt's higher than that, guess again:"
fi
SCORE=$(( SCORE + 1 ))
read INPUT
done
echo -e "\nYou guessed it in $SCORE tries. The secret number was $NUM. Nice job!"
$PSQL "update guesser set nbr_games=$(( NBR + 1 )) , best_game=coalesce(least(best_game,$SCORE),$SCORE) where name='$NAME';" >2
