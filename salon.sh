#! /bin/bash

PSQL="psql --username=freecodecamp dbname=salon -t --no-align -c"

# Start salon program
echo -e "\n~~~~ My Salon ~~~~\n"

# get the services
SERVICES=$($PSQL "SELECT * FROM services")

while true; do
  for S in $SERVICES
    do
    echo "$S" | awk -F'|' '{print $1 ") " $2}'
  done

  # get the user's choice
  read SERVICE_ID_SELECTED
  CHECKCHOICE=$($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  
  if [[ -z $CHECKCHOICE ]] # if choice not in list
    then # ask again
    echo -e "\nI could not find that service. What would you like today?"
    continue
  fi
  break
done

# get phone
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE
# check if phone in DB
CHECKPHONE=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
# if phone not in DB 
if [[ -z $CHECKPHONE ]]
  then
  # ask for name
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME
  # Create new customer in DB
  INSERTNEWCUSTOMER=$($PSQL "INSERT INTO customers (name, phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
fi

# ask for time with name of cutomer
# get customer name from DB
CUSTOMER=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
echo -e "\nWhat time would you like your color, $CUSTOMER?"
# create a var for time
read SERVICE_TIME

# send datas to DB
# retrieve the customer ID
CUSTOMERID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

# insert datas into appointments table
INSERTAPPOINTMENT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES($CUSTOMERID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

# retrieve service chosen by the customer
CHOSENSERVICE=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

# display service, time and name of customer
echo -e "\nI have put you down for a $CHOSENSERVICE at $SERVICE_TIME, $CUSTOMER_NAME."