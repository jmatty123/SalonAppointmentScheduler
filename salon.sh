#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --no-align --tuples-only -c"
echo -e "\n~~~ Welcome to the Salon ~~~\n"

MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "\nWhich service would you like an appointment for?\n"
  SERVICES=$($PSQL "SELECT service_id,name FROM services ORDER BY service_id;")
  FORMATTED_SERVICES= echo "$SERVICES" | sed 's/|/) /'
  echo $FORMATTED_SERVICES | while read SERVICE_ID SERVICE
  do
  echo $SERVICE_ID $SERVICE
  done

  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) APPT_MENU ;;
    2) APPT_MENU ;;
    3) APPT_MENU ;;
    *) MAIN_MENU "!! Please enter the ID number for one of the listed services. !!"
  esac
}

APPT_MENU(){
  echo -e "\nPlease enter your phone number:"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE';")
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nWe dont have a record for you, could I take a name for your appointment?"
    read CUSTOMER_NAME
  fi    
  INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME');")
  
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE';")
  
  echo -e "\nWhat time would you like your appointment to be?"
  read SERVICE_TIME
  
  INSERT_APPT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME');")
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED;")
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}
MAIN_MENU
