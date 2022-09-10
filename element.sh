#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t -c"
PARAM1=$1;

function MAIN_MENU() {
  P1=$1

  if [[ -z $P1 ]]
  then
    echo "Please provide an element as an argument."
    exit
  fi

  if [[ $P1 == ?(-)+([0-9]) ]]
  then
    ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number = '$P1'")
  else
    ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE symbol = '$P1' OR name = '$P1'")
  fi

  if [[ ! -z $ELEMENT ]]
  then
    echo "$ELEMENT" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS BAR TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    done
  else
    echo "I could not find that element in the database."
  fi

}

MAIN_MENU $PARAM1