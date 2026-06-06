#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon -t -c"
echo -e "\n~~~~~~ MY SALON ~~~~~"
SELECT=$($PSQL "select service_id,name from services;")
NUM=$(echo "$SELECT"|wc -l)
SERVICE_ID_SELECTED=0
until [[ $SERVICE_ID_SELECTED -le $NUM && $SERVICE_ID_SELECTED -gt 0 ]]
do
echo -e "Welcome to My Salon, how can I help you?\n"
echo "$SELECT" |while IFS=' ' read  ID BAR NAME
do
echo "$ID) $NAME"
done
read SERVICE_ID_SELECTED
done
OPTION_MESS=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED;")
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE
NAME=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE';")
if [[ -z $NAME ]]
then
echo -e "\n I dont't have a record for that phone number, what's your name?"
read CUSTOMER_NAME
$PSQL "insert into customers(name,phone) values('$CUSTOMER_NAME','$CUSTOMER_PHONE');" >2
NAME=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE';")
else
CUSTOMER_NAME=$($PSQL "select name from customers where customer_id=$NAME;")
fi
echo -e "\nWhat time whould you like your $OPTION_MESS, $CUSTOMER_NAME?"
read SERVICE_TIME
$PSQL "insert into appointments(time,customer_id,service_id) values('$SERVICE_TIME',$NAME,$SERVICE_ID_SELECTED);" >2
echo -e "\nI have put you down for a $OPTION_MESS at $SERVICE_TIME, $CUSTOMER_NAME.\n"
