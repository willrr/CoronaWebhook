#!/bin/bash

## discord webhook
url='https://discordapp.com/api/webhooks/'

node /home/willrr/app.js

con="$(curl -s 'http://localhost:8086/query?pretty=true' --data-urlencode "db=covid19" --data-urlencode "q=SELECT sum(\"Confirmed\") FROM \"covid19\".\"autogen\".\"Corona\" WHERE \"country\"='United Kingdom' AND \"state\"='N/A' AND time >= now() - 2d GROUP BY time(24h) fill(null) ORDER BY time DESC" | jq '.results[0].series[0].values[0] | nth(1)')"

loops=0
if [ "$con" = null ]
then
##	echo "Null"
	temp="$(curl -s 'http://localhost:8086/query?pretty=true' --data-urlencode "db=covid19" --data-urlencode "q=SELECT sum(\"Confirmed\") FROM \"covid19\".\"autogen\".\"CoronaNew\" WHERE \"country\"='United Kingdom' AND time >= now() - 2d GROUP BY time(24h) fill(null) ORDER BY time DESC" | jq '.results[0].series[0].values[1] | nth(0)')"
	con="$(curl -s 'http://localhost:8086/query?pretty=true' --data-urlencode "db=covid19" --data-urlencode "q=SELECT sum(\"Confirmed\") FROM \"covid19\".\"autogen\".\"CoronaNew\" WHERE \"country\"='United Kingdom' AND time >= now() - 2d GROUP BY time(24h) fill(null) ORDER BY time DESC" | jq '.results[0].series[0].values[1] | nth(1)')"
	con2="$(curl -s 'http://localhost:8086/query?pretty=true' --data-urlencode "db=covid19" --data-urlencode "q=SELECT sum(\"Confirmed\") FROM \"covid19\".\"autogen\".\"CoronaNew\" WHERE \"country\"='United Kingdom' AND time >= now() - 3d GROUP BY time(24h) fill(null) ORDER BY time DESC" | jq '.results[0].series[0].values[2] | nth(1)')"
	con3="$(curl -s 'http://localhost:8086/query?pretty=true' --data-urlencode "db=covid19" --data-urlencode "q=SELECT sum(\"Confirmed\") FROM \"covid19\".\"autogen\".\"CoronaNew\" WHERE \"country\"='United Kingdom' AND time >= now() - 9d GROUP BY time(24h) fill(null) ORDER BY time DESC" | jq '.results[0].series[0].values[8] | nth(1)')"
	death="$(curl -s 'http://localhost:8086/query?pretty=true' --data-urlencode "db=covid19" --data-urlencode "q=SELECT sum(\"Deaths\") FROM \"covid19\".\"autogen\".\"CoronaNew\" WHERE \"country\"='United Kingdom' AND time >= now() - 2d GROUP BY time(24h) fill(null) ORDER BY time DESC" | jq '.results[0].series[0].values[1] | nth(1)')"
	death2="$(curl -s 'http://localhost:8086/query?pretty=true' --data-urlencode "db=covid19" --data-urlencode "q=SELECT sum(\"Deaths\") FROM \"covid19\".\"autogen\".\"CoronaNew\" WHERE \"country\"='United Kingdom' AND time >= now() - 3d GROUP BY time(24h) fill(null) ORDER BY time DESC" | jq '.results[0].series[0].values[2] | nth(1)')"
	death3="$(curl -s 'http://localhost:8086/query?pretty=true' --data-urlencode "db=covid19" --data-urlencode "q=SELECT sum(\"Deaths\") FROM \"covid19\".\"autogen\".\"CoronaNew\" WHERE \"country\"='United Kingdom' AND time >= now() - 9d GROUP BY time(24h) fill(null) ORDER BY time DESC" | jq '.results[0].series[0].values[8] | nth(1)')"
#	rec="$(curl -s 'http://localhost:8086/query?pretty=true' --data-urlencode "db=covid19" --data-urlencode "q=SELECT sum(\"Recovered\") FROM \"covid19\".\"autogen\".\"Corona\" WHERE \"country\"='United Kingdom' AND \"state\"='N/A' AND time >= now() - 2d GROUP BY time(24h) fill(null) ORDER BY time DESC" | jq '.results[0].series[0].values[1] | nth(1)')"
else
##	echo "Not Null"
	temp="$(curl -s 'http://localhost:8086/query?pretty=true' --data-urlencode "db=covid19" --data-urlencode "q=SELECT sum(\"Confirmed\") FROM \"covid19\".\"autogen\".\"CoronaNew\" WHERE \"country\"='United Kingdom' AND time >= now() - 2d GROUP BY time(24h) fill(null) ORDER BY time DESC" | jq '.results[0].series[0].values[0] | nth(0)')"
	con="$(curl -s 'http://localhost:8086/query?pretty=true' --data-urlencode "db=covid19" --data-urlencode "q=SELECT sum(\"Confirmed\") FROM \"covid19\".\"autogen\".\"CoronaNew\" WHERE \"country\"='United Kingdom' AND time >= now() - 2d GROUP BY time(24h) fill(null) ORDER BY time DESC" | jq '.results[0].series[0].values[0] | nth(1)')"
	con2="$(curl -s 'http://localhost:8086/query?pretty=true' --data-urlencode "db=covid19" --data-urlencode "q=SELECT sum(\"Confirmed\") FROM \"covid19\".\"autogen\".\"CoronaNew\" WHERE \"country\"='United Kingdom' AND time >= now() - 3d GROUP BY time(24h) fill(null) ORDER BY time DESC" | jq '.results[0].series[0].values[1] | nth(1)')"
	con3="$(curl -s 'http://localhost:8086/query?pretty=true' --data-urlencode "db=covid19" --data-urlencode "q=SELECT sum(\"Confirmed\") FROM \"covid19\".\"autogen\".\"CoronaNew\" WHERE \"country\"='United Kingdom' AND time >= now() - 9d GROUP BY time(24h) fill(null) ORDER BY time DESC" | jq '.results[0].series[0].values[7] | nth(1)')"
	death="$(curl -s 'http://localhost:8086/query?pretty=true' --data-urlencode "db=covid19" --data-urlencode "q=SELECT sum(\"Deaths\") FROM \"covid19\".\"autogen\".\"CoronaNew\" WHERE \"country\"='United Kingdom' AND time >= now() - 2d GROUP BY time(24h) fill(null) ORDER BY time DESC" | jq '.results[0].series[0].values[0] | nth(1)')"
	death2="$(curl -s 'http://localhost:8086/query?pretty=true' --data-urlencode "db=covid19" --data-urlencode "q=SELECT sum(\"Deaths\") FROM \"covid19\".\"autogen\".\"CoronaNew\" WHERE \"country\"='United Kingdom' AND time >= now() - 3d GROUP BY time(24h) fill(null) ORDER BY time DESC" | jq '.results[0].series[0].values[1] | nth(1)')"
	death3="$(curl -s 'http://localhost:8086/query?pretty=true' --data-urlencode "db=covid19" --data-urlencode "q=SELECT sum(\"Deaths\") FROM \"covid19\".\"autogen\".\"CoronaNew\" WHERE \"country\"='United Kingdom' AND time >= now() - 9d GROUP BY time(24h) fill(null) ORDER BY time DESC" | jq '.results[0].series[0].values[7] | nth(1)')"
#	rec="$(curl -s 'http://localhost:8086/query?pretty=true' --data-urlencode "db=covid19" --data-urlencode "q=SELECT sum(\"Recovered\") FROM \"covid19\".\"autogen\".\"Corona\" WHERE \"country\"='United Kingdom' AND \"state\"='N/A' AND time >= now() - 2d GROUP BY time(24h) fill(null) ORDER BY time DESC" | jq '.results[0].series[0].values[0] | nth(1)')"
fi

while (( con == null && loops < 3)); do
	loops=$((loops+1))
	msg="Necromancy has occured, retrying in 2 hours."
	msg_content=\"$msg\"
	##echo "$msg_content"
	curl -H "Content-Type: application/json" -X POST -d "{\"content\": $msg_content}" $url
	sleep 2h
	node /home/willrr/app.js
	temp="$(curl -s 'http://localhost:8086/query?pretty=true' --data-urlencode "db=covid19" --data-urlencode "q=SELECT sum(\"Confirmed\") FROM \"covid19\".\"autogen\".\"CoronaNew\" WHERE \"country\"='United Kingdom' AND time >= now() - 2d GROUP BY time(24h) fill(null) ORDER BY time DESC" | jq '.results[0].series[0].values[0] | nth(0)')"
	con="$(curl -s 'http://localhost:8086/query?pretty=true' --data-urlencode "db=covid19" --data-urlencode "q=SELECT sum(\"Confirmed\") FROM \"covid19\".\"autogen\".\"CoronaNew\" WHERE \"country\"='United Kingdom' AND time >= now() - 2d GROUP BY time(24h) fill(null) ORDER BY time DESC" | jq '.results[0].series[0].values[0] | nth(1)')"
	con2="$(curl -s 'http://localhost:8086/query?pretty=true' --data-urlencode "db=covid19" --data-urlencode "q=SELECT sum(\"Confirmed\") FROM \"covid19\".\"autogen\".\"CoronaNew\" WHERE \"country\"='United Kingdom' AND time >= now() - 3d GROUP BY time(24h) fill(null) ORDER BY time DESC" | jq '.results[0].series[0].values[1] | nth(1)')"
	con3="$(curl -s 'http://localhost:8086/query?pretty=true' --data-urlencode "db=covid19" --data-urlencode "q=SELECT sum(\"Confirmed\") FROM \"covid19\".\"autogen\".\"CoronaNew\" WHERE \"country\"='United Kingdom' AND time >= now() - 9d GROUP BY time(24h) fill(null) ORDER BY time DESC" | jq '.results[0].series[0].values[7] | nth(1)')"
	death="$(curl -s 'http://localhost:8086/query?pretty=true' --data-urlencode "db=covid19" --data-urlencode "q=SELECT sum(\"Deaths\") FROM \"covid19\".\"autogen\".\"CoronaNew\" WHERE \"country\"='United Kingdom' AND time >= now() - 2d GROUP BY time(24h) fill(null) ORDER BY time DESC" | jq '.results[0].series[0].values[0] | nth(1)')"
	death2="$(curl -s 'http://localhost:8086/query?pretty=true' --data-urlencode "db=covid19" --data-urlencode "q=SELECT sum(\"Deaths\") FROM \"covid19\".\"autogen\".\"CoronaNew\" WHERE \"country\"='United Kingdom' AND time >= now() - 3d GROUP BY time(24h) fill(null) ORDER BY time DESC" | jq '.results[0].series[0].values[1] | nth(1)')"
	death3="$(curl -s 'http://localhost:8086/query?pretty=true' --data-urlencode "db=covid19" --data-urlencode "q=SELECT sum(\"Deaths\") FROM \"covid19\".\"autogen\".\"CoronaNew\" WHERE \"country\"='United Kingdom' AND time >= now() - 9d GROUP BY time(24h) fill(null) ORDER BY time DESC" | jq '.results[0].series[0].values[7] | nth(1)')"
	if [ "$con" = null ]
	then
	temp="$(curl -s 'http://localhost:8086/query?pretty=true' --data-urlencode "db=covid19" --data-urlencode "q=SELECT sum(\"Confirmed\") FROM \"covid19\".\"autogen\".\"CoronaNew\" WHERE \"country\"='United Kingdom' AND time >= now() - 2d GROUP BY time(24h) fill(null) ORDER BY time DESC" | jq '.results[0].series[0].values[1] | nth(0)')"
	con="$(curl -s 'http://localhost:8086/query?pretty=true' --data-urlencode "db=covid19" --data-urlencode "q=SELECT sum(\"Confirmed\") FROM \"covid19\".\"autogen\".\"CoronaNew\" WHERE \"country\"='United Kingdom' AND time >= now() - 2d GROUP BY time(24h) fill(null) ORDER BY time DESC" | jq '.results[0].series[0].values[1] | nth(1)')"
	con2="$(curl -s 'http://localhost:8086/query?pretty=true' --data-urlencode "db=covid19" --data-urlencode "q=SELECT sum(\"Confirmed\") FROM \"covid19\".\"autogen\".\"CoronaNew\" WHERE \"country\"='United Kingdom' AND time >= now() - 3d GROUP BY time(24h) fill(null) ORDER BY time DESC" | jq '.results[0].series[0].values[2] | nth(1)')"
	con3="$(curl -s 'http://localhost:8086/query?pretty=true' --data-urlencode "db=covid19" --data-urlencode "q=SELECT sum(\"Confirmed\") FROM \"covid19\".\"autogen\".\"CoronaNew\" WHERE \"country\"='United Kingdom' AND time >= now() - 9d GROUP BY time(24h) fill(null) ORDER BY time DESC" | jq '.results[0].series[0].values[8] | nth(1)')"
	death="$(curl -s 'http://localhost:8086/query?pretty=true' --data-urlencode "db=covid19" --data-urlencode "q=SELECT sum(\"Deaths\") FROM \"covid19\".\"autogen\".\"CoronaNew\" WHERE \"country\"='United Kingdom' AND time >= now() - 2d GROUP BY time(24h) fill(null) ORDER BY time DESC" | jq '.results[0].series[0].values[1] | nth(1)')"
	death2="$(curl -s 'http://localhost:8086/query?pretty=true' --data-urlencode "db=covid19" --data-urlencode "q=SELECT sum(\"Deaths\") FROM \"covid19\".\"autogen\".\"CoronaNew\" WHERE \"country\"='United Kingdom' AND time >= now() - 3d GROUP BY time(24h) fill(null) ORDER BY time DESC" | jq '.results[0].series[0].values[2] | nth(1)')"
	death3="$(curl -s 'http://localhost:8086/query?pretty=true' --data-urlencode "db=covid19" --data-urlencode "q=SELECT sum(\"Deaths\") FROM \"covid19\".\"autogen\".\"CoronaNew\" WHERE \"country\"='United Kingdom' AND time >= now() - 9d GROUP BY time(24h) fill(null) ORDER BY time DESC" | jq '.results[0].series[0].values[8] | nth(1)')"
	fi
	##echo "$con"
done


	
if [ "$con" != null ]
then
	tim="${temp%\"}"
	tim="${tim#\"}"
	#echo "$con3"
	
	conInc="$(($con-$con2))"
	deathInc="$(($death-$death2))"
	
	conInc2="$(($con-$con3))"
	deathInc2="$(($death-$death3))"
	
	conPer=`ps -ef | grep "port 10 -" | grep -v "grep port 10 -" | awk -v t1="$con2" -v t2="$con" 'BEGIN{print (t2-t1)/((t2+t1)/2) * 100}'`
	deathPer=`ps -ef | grep "port 10 -" | grep -v "grep port 10 -" | awk -v t1="$death2" -v t2="$death" 'BEGIN{print (t2-t1)/((t2+t1)/2) * 100}'`
	
	conPer2=`ps -ef | grep "port 10 -" | grep -v "grep port 10 -" | awk -v t1="$con3" -v t2="$con" 'BEGIN{print (t2-t1)/((t2+t1)/2) * 100}'`
	deathPer2=`ps -ef | grep "port 10 -" | grep -v "grep port 10 -" | awk -v t1="$death3" -v t2="$death" 'BEGIN{print (t2-t1)/((t2+t1)/2) * 100}'`
	
	msg="The Latest UK Data is: Total contracted: $con. Deaths: $death. Last updated: $tim"
	msg2="Cases since yesterday: $conInc (Percentage Increase: $conPer%). Cases since 7 days ago: $conInc2 (Percentage Increase: $conPer2%)."
	msg3="Deaths since yesterday: $deathInc (Percentage Increase: $deathPer%). Deaths since 7 days ago: $deathInc2 (Percentage Increase: $deathPer2%)."
	
	msg_content=\"$msg\"
	msg2_content=\"$msg2\"
	msg3_content=\"$msg3\"
	
	##echo "$msg_content"
	curl -H "Content-Type: application/json" -X POST -d "{\"content\": $msg_content}" $url
	sleep 1
	##echo "$msg2_content"
	curl -H "Content-Type: application/json" -X POST -d "{\"content\": $msg2_content}" $url
	sleep 1
	##echo "$msg3_content"
	curl -H "Content-Type: application/json" -X POST -d "{\"content\": $msg3_content}" $url
	
	#echo "$msg_content"
	#echo "$msg2_content"
	#echo "$msg3_content"
else
	msg="There has been too much necromancy today, please try again tomorrow."
	msg_content=\"$msg\"
	##echo "$msg_content"
	curl -H "Content-Type: application/json" -X POST -d "{\"content\": $msg_content}" $url
fi
