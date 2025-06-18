#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c"



SERVICES_MENU(){
  MENSAGEM="$($PSQL "SELECT * FROM services ORDER BY service_id")"

  echo "$MENSAGEM" | while IFS="|" read -r SERVICE_ID NAME
  do
    echo "$SERVICE_ID) $NAME"
  done
}

SERVICES_MENU
read USER_SERVICE_PICKED
if [[ ! $USER_SERVICE_PICKED =~ ^[0-9]*$ ]]
then
  SERVICES_MENU
else
  echo $USER_SERVICE_PICKED
fi