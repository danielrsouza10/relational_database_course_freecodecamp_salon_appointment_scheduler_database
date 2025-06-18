#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

SERVICES_MENU(){

  if [[ $1 ]]
  then 
    echo $1
  fi

  MENSAGEM="$($PSQL "SELECT * FROM services ORDER BY service_id")"
  echo -e "\nList of services provide for this Salon\n"

  echo "$MENSAGEM" | while IFS="|" read -r SERVICE_ID NAME
  do
    echo "$SERVICE_ID) $NAME"
  done

  echo "Select a service"
  read SERVICE_ID_SELECTED

  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]*$ ]]
  then
    SERVICES_MENU
  else
    USER_PICKED_RESULT="$($PSQL "SELECT service_id FROM services WHERE service_id='$SERVICE_ID_SELECTED'")"
    if [[ -z $USER_PICKED_RESULT ]]
    then
      SERVICES_MENU "Inexistent option. Please select a service"
    else
      CUSTOMERS_MENU $SERVICE_ID_SELECTED
    fi
  fi
}

CUSTOMERS_MENU(){
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_ID="$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")"

  if [[ -z $CUSTOMER_ID ]]
  then
    echo -e "What's your name?"
    read CUSTOMER_NAME
    INSERT_NEW_CUSTOMER_RESULT="$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")"
    CUSTOMER_ID="$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")"
    APPOINTMENT_MENU $SERVICE_ID_SELECTED $CUSTOMER_ID
  else
    APPOINTMENT_MENU $SERVICE_ID_SELECTED $CUSTOMER_ID
  fi
}

APPOINTMENT_MENU(){
  CUSTOMER_NAME="$($PSQL "SELECT name FROM customers WHERE customer_id = $2")"
  echo -e "\nHello, $CUSTOMER_NAME!"
  echo -e "\nWhat time do you wanna set your appointment?"
  read SERVICE_TIME

  APPOINTMENT_RESULT="$($PSQL "INSERT INTO appointments(service_id, customer_id, time) VALUES($1, $2, '$SERVICE_TIME')")"
  SERVICE_NAME="$($PSQL "SELECT name FROM services WHERE service_id=$1")"
  CUSTOMER_NAME="$($PSQL "SELECT name FROM customers WHERE customer_id=$2")"
  echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

}

MAIN_NENU(){
  SERVICES_MENU $1
}

MAIN_NENU "SALON-HAIR"