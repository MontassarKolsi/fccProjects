#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi
$PSQL "truncate table teams,games"
# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read Y R W O WG OW 
do
if [[ $Y == year ]]
then
continue
fi
$PSQL "insert into teams(name) values('$W')"
$PSQL "insert into teams(name) values('$O')" 
done


cat games.csv | while IFS="," read Y R W O WG OG 
do
if [[ $Y == year ]]
then
continue
fi
WID=$($PSQL "select team_id from teams where name='$W'")
OID=$($PSQL "select team_id from teams where name='$O'")
$PSQL "insert into games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) values($Y,'$R',$WID,$OID,$WG,$OG)"
done
