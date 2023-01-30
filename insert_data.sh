#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")

# read csv and split the line by , and assign to these variable
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
# remove first line
	if [[ $YEAR != "year" ]]
	then
	# get two teams id using select 
	WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
	OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

		# if winner not found
		if [[ -z $WINNER_ID ]]
		then
		# insert winner
		INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
			#show process ok
			if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
			then
				echo Insert one team, $WINNER
			fi
		fi

		# if opponent not found
		if [[ -z $OPPONENT_ID ]]
		then
		# insert opponent
		INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
			#show process ok
			if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
			then
				echo Insert one team, $OPPONENT
			fi
		fi

		# insert row  and show process ok 
		WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
		OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
		INSERT_DATA_RESULT=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR, '$ROUND', $WIN_ID, $OPP_ID,$WINNER_GOALS, $OPPONENT_GOALS)")

	fi
done
