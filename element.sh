#!/bin/bash
if [[ -z $1 ]]
  then 
  echo "Please provide an element as an argument."
else
  OUTPUT () {
    NUM=$1
    IFS='|' read NUM  MASS  MELT  BOIL T < <(echo "$($PSQL "select * from properties where atomic_number=$NUM")" )  
    TYPE=$($PSQL "select type from types inner join properties using(type_id) where atomic_number=$NUM") 
    IFS='|' read NAME SYM < <(echo "$($PSQL "select name,symbol from elements where atomic_number=$NUM")") 
    echo "The element with atomic number $NUM is $NAME ($SYM). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  }
  PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
  if [[ $1 =~ [0-9]+ ]]
    then
    NUM=$($PSQL "select atomic_number from elements where atomic_number=$1;")
    if [[ -z $NUM ]]
      then
      echo "I could not find that element in the database."
    else
      OUTPUT $NUM
    fi
  else
    NUM=$($PSQL "select atomic_number from elements where symbol='$1';")
    if [[ -z $NUM  ]]
      then
      NUM=$($PSQL "select atomic_number from elements where name='$1';")
      if [[ -z $NUM ]]
        then
        echo "I could not find that element in the database."
      else
        OUTPUT $NUM
      fi
    else
      OUTPUT $NUM
    fi  
  fi
fi
