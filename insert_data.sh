#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.


GET_TEAM_ID() {
  return $($PSQL "SELECT team_id FROM teams WHERE name='$1'")
}


INSERT_TEAM_RETURN_ID() {
  TEAM_NAME=$1
  GET_TEAM_ID "$TEAM_NAME"
  TEAM_ID=$?

  if [[ $TEAM_ID -eq 0 ]]
  then
    RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$TEAM_NAME')")

    if [[ $RESULT == "INSERT 0 1" ]]
    then
			echo Team $TEAM_NAME was inserted to the db.
		fi

    GET_TEAM_ID "$TEAM_NAME"
    TEAM_ID=$?

  fi

  return $TEAM_ID

}


cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    INSERT_TEAM_RETURN_ID "$WINNER"
    WINNER_ID=$?

    INSERT_TEAM_RETURN_ID "$OPPONENT"
    OPPONENT_ID=$?

    RES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")

      if [[ $RES == "INSERT 0 1" ]]
		  then
			  echo "New game inserted!"
		  fi
  fi
done


