#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Clear all tables
echo $($PSQL "TRUNCATE games, teams")
# Insert Data from games.csv to teams and games tables

# While (line in text file is not empty)
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
  then
    # Output values to test
    echo $WINNER $OPPONENT

    # Get winner_id and opponent_id from the names and the teams table (team_id)
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    # if winner_id does not exist
    if [[ -z $WINNER_ID ]]
    then
      # Insert the team into the teams table
      INSERTED_TEAM=$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER')")
      if [[ $INSERTED_TEAM = "INSERT 0 1" ]]
      then
        echo "$WINNER inserted into the teams table."
        # Get the winner_id
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
      fi
    fi
    # if opponent_id does not exist
    if [[ -z $OPPONENT_ID ]]
    then
      # Insert the team into the teams table
      INSERTED_TEAM=$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')")
      if [[ $INSERTED_TEAM = "INSERT 0 1" ]]
      then
        echo "$OPPONENT inserted into the teams table."
        # Get opponent_id
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
      fi
    fi
  
    # Insert the rest of the data into the games table
    INSERTED_GAME=$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id,winner_goals,opponent_goals) VALUES ($YEAR, '$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
    if [[ INSERTED_GAME = "INSERT 0 1" ]]
    then 
      echo "Game Inserted: Year: $Year, $WINNER Vs. $OPPONENT ($WINNER_GOALS,$OPPONENT_GOALS)"
    fi
  fi
done
  
    
