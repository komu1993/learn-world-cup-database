#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

echo $($PSQL "TRUNCATE teams,games")
# Do not change code above this line. Use the PSQL variable above to query your database.
#get team id
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNERGOALS OPPONENTGOALS
do
if [[ $WINNER != 'winner' ]]
then
echo $WINNER
TEAM_ID=$($PSQL "select team_id from teams where name='$WINNER'")
OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
#if not found
if [[ -z $TEAM_ID ]]
then
#insert data
INSERT_TEAM_RESULT=$($PSQL "insert into teams(name) values('$WINNER')")
#if inserted get new team id
if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
      fi
#get team id
TEAM_ID=$($PSQL "select team_id from teams where name='$WINNER'")

fi
if [[ -z $OPPONENT_ID ]]
then
#insert data
INSERT_TEAM_RESULT=$($PSQL "insert into teams(name) values('$OPPONENT')")
#if inserted get new team id
if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
      fi
#get team id
TEAM_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")

fi

fi
done

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNERGOALS OPPONENTGOALS
do
if [[ $WINNER != 'winner' ]]
then
TEAM_ID=$($PSQL "select team_id from teams where name='$WINNER'")
OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
echo $TEAM_ID $OPPONENT_ID $ROUND
if [[ !(-z $TEAM_ID && -z $OPPONENT_ID) ]]
then
INSERT_GAME_RESULT=$($PSQL "insert into games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) values($YEAR,'$ROUND',$TEAM_ID,$OPPONENT_ID,$WINNERGOALS,$OPPONENTGOALS)")
fi
fi
done