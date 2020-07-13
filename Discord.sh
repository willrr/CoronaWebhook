#!/bin/bash

if [ -z $DISCORD_WEBHOOK ]; then
	echo "$DISCORD_WEBHOOK not set, cannot continue"
	exit 1
fi

node /home/willrr/app.js

function fetchData {
	query=$1
	values=$2
	nth=$3
	curl -s 'http://localhost:8086/query?pretty=true' --data-urlencode "db=covid19" --data-urlencode "q=${query}" | jq ".results[0].series[0].values[${values}] | nth(${nth})"
}

function postToDiscord {
	msg=$1
	curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"${msg}\"}" "${DISCORD_WEBHOOK}"
}

function attempt {
	attemptno=$1
	if [ -z "$1" ]; then
		attemptno=0
	fi
	node /home/willrr/app.js
	con=$(fetchData 'SELECT sum("Confirmed") FROM "covid19"."autogen"."CoronaNew" WHERE "country"="United Kingdom" AND time >= now() - 2d GROUP BY time(24h) fill(null) ORDER BY time DESC' 0 1)
	if [ "${con}" = null ]; then
		if [ $attemptno -ge 3 ]; then
			postToDiscord "There has been too much necromancy today, giving up until tomorrow."
			return
		fi
		postToDiscord "Necromancy has occured, retrying in 2 hours."
		sleep 2h
		attemptno=$((attemptno+1))
		attempt ${attemptno}
		return
	fi
	temp=$(fetchData 'SELECT sum("Confirmed") FROM "covid19"."autogen"."CoronaNew" WHERE "country"="United Kingdom" AND time >= now() - 2d GROUP BY time(24h) fill(null) ORDER BY time DESC' 0 0)
	con2=$(fetchData 'SELECT sum("Confirmed") FROM "covid19"."autogen"."CoronaNew" WHERE "country"="United Kingdom" AND time >= now() - 3d GROUP BY time(24h) fill(null) ORDER BY time DESC' 1 1)
	con3=$(fetchData 'SELECT sum("Confirmed") FROM "covid19"."autogen"."CoronaNew" WHERE "country"="United Kingdom" AND time >= now() - 9d GROUP BY time(24h) fill(null) ORDER BY time DESC' 7 1)
	death=$(fetchData 'SELECT sum("Deaths") FROM "covid19"."autogen"."CoronaNew" WHERE "country"="United Kingdom" AND time >= now() - 2d GROUP BY time(24h) fill(null) ORDER BY time DESC' 0 1)
	death2=$(fetchData 'SELECT sum("Deaths") FROM "covid19"."autogen"."CoronaNew" WHERE "country"="United Kingdom" AND time >= now() - 3d GROUP BY time(24h) fill(null) ORDER BY time DESC' 1 1)
	death3=$(fetchData 'SELECT sum("Deaths") FROM "covid19"."autogen"."CoronaNew" WHERE "country"="United Kingdom" AND time >= now() - 9d GROUP BY time(24h) fill(null) ORDER BY time DESC' 7 1)
	tim="${temp%}"
	tim="${tim#}"
	
	conInc="$(($con-$con2))"
	deathInc="$(($death-$death2))"
	
	conInc2="$(($con-$con3))"
	deathInc2="$(($death-$death3))"
	
	conPer=`ps -ef | grep "port 10 -" | grep -v "grep port 10 -" | awk -v t1="$con2" -v t2="$con" 'BEGIN{print (t2-t1)/((t2+t1)/2) * 100}'`
	deathPer=`ps -ef | grep "port 10 -" | grep -v "grep port 10 -" | awk -v t1="$death2" -v t2="$death" 'BEGIN{print (t2-t1)/((t2+t1)/2) * 100}'`
	
	conPer2=`ps -ef | grep "port 10 -" | grep -v "grep port 10 -" | awk -v t1="$con3" -v t2="$con" 'BEGIN{print (t2-t1)/((t2+t1)/2) * 100}'`
	deathPer2=`ps -ef | grep "port 10 -" | grep -v "grep port 10 -" | awk -v t1="$death3" -v t2="$death" 'BEGIN{print (t2-t1)/((t2+t1)/2) * 100}'`
	
	postToDiscord "The Latest UK Data is: Total contracted: ${con}. Deaths: ${death}. Last updated: ${tim}"
	postToDiscord "Cases since yesterday: ${conInc} (Percentage Increase: ${conPer}%). Cases since 7 days ago: ${conInc2} (Percentage Increase: ${conPer2}%)."
	postToDiscord "Deaths since yesterday: ${deathInc} (Percentage Increase: ${deathPer}%). Deaths since 7 days ago: ${deathInc2} (Percentage Increase: ${deathPer2}%)."
}

attempt 0
