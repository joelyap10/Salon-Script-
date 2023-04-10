#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ Salon ~~~~~\n"

MAIN_MENU(){
  if [[ $1 ]]
then
  echo -e "\n$1"
  fi


  #get avaiable services
  AVAILABLE_SERVICES=$($PSQL "SELECT * from services")
  #display available sercvices
  echo -e "\nHere are our available services:"
  echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR NAME
  do 
  echo "$SERVICE_ID) $NAME"
  done
  # ask for which service
    echo -e "\nWhich service would you like?"
    read SERVICE_ID_SELECTED
# if input is not a number
    if [[ ! $SERVICE_ID_SELECTED =~ ^[1-3]+$ ]]
    then
# send to main menu
      MAIN_MENU "That is not a valid service number."
      else
      # get customer info
        echo -e "\nWhat's your phone number?"
        read CUSTOMER_PHONE

        CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
        # if customer doesn't exist
        if [[ -z $CUSTOMER_NAME ]]
        then
# get new customer name
          echo -e "\nWhat's your name?"
          read CUSTOMER_NAME
          # insert new customer
          
          INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") 
          fi
           echo -e "\n Hello $CUSTOMER_NAME"
#get appointment time 

echo -e "\nWhat time would you like to book your appointment?"
read SERVICE_TIME
FORMATTED_SERVICE_TIME=$(echo $SERVICE_TIME | sed -r 's/:/\:/g')
#get customer ID
 CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
#insert appointment
INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
#get appointment info
SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
echo -e "\nI have put you down for a $(echo $SERVICE_NAME | sed -r 's/^ *| *$//g') at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."
      fi

}




MAIN_MENU
