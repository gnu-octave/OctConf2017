#!/usr/bin/env bash

# Inspired by: https://www.mediawiki.org/wiki/API:Client_code/Bash

WIKIAPI=$1
USERNAME=$2
USERPASS=$3
PAGE=$4
CONTENT=$(<$5)

# Store cookies in a temporary file
cookie_jar=$(mktemp)

echo "Login (1/2): Get login token..."
TOKEN=$(curl --silent \
  --cookie $cookie_jar \
  --cookie-jar $cookie_jar \
  "${WIKIAPI}?action=query&meta=tokens&type=login&format=json")
TOKEN=$(echo "$TOKEN" | sed -n 's/.*"logintoken":"\(\S\+\)\+\\".*/\1/p')
if [ "$TOKEN" == "null" ]; then
  echo "    FAILED!"
  exit
else
  echo "    SUCCESS: token is: $TOKEN"
fi

echo "Login (2/2): Logging in..."
STATUS=$(curl --silent \
  --cookie $cookie_jar \
  --cookie-jar $cookie_jar \
  --data-urlencode "username=${USERNAME}" \
  --data-urlencode "password=${USERPASS}" \
  --data-urlencode "rememberMe=1" \
  --data-urlencode "logintoken=${TOKEN}" \
  --data-urlencode "loginreturnurl=${WIKIAPI}" \
  "${WIKIAPI}?action=clientlogin&format=json")
USERNAME=$(echo "$STATUS" | sed -n 's/.*"username":"\([^"]*\).*/\1/p')
STATUS=$(echo "$STATUS" | sed -n 's/.*"status":"\([^"]*\).*/\1/p')
if [[ $STATUS == "PASS" ]]; then
  echo "    SUCCESS: logged in as $USERNAME"
else
  echo "    FAILED: STATUS is $STATUS"
  exit
fi

echo " "
echo "Edit (1/3): Get edit token..."
EDITTOKEN=$(curl --silent \
  --cookie $cookie_jar \
  --cookie-jar $cookie_jar \
  "${WIKIAPI}?action=query&meta=tokens&format=json")
EDITTOKEN=$(echo "$EDITTOKEN" | sed -n 's/.*"csrftoken":"\(\S\+\)\+\\".*/\1/p')
if [ "$EDITTOKEN" == "null" ]; then
  echo "    FAILED!"
  exit
else
  echo "    SUCCESS: token is: $EDITTOKEN"
fi

echo "Edit (2/3): Update page ${PAGE}..."
echo " "
CR=$(curl -S \
  --cookie $cookie_jar \
  --cookie-jar $cookie_jar \
  --data-urlencode "title=${PAGE}" \
  --data-urlencode "text=${CONTENT}" \
  --data-urlencode "token=${EDITTOKEN}" \
  "${WIKIAPI}?action=edit&format=json")
echo " "
#echo "$CR" | jq .

echo "Edit (3/3): Update images of ${PAGE}..."
echo " "
for ((i=6 ; i <= $# ; i++)); do
    echo "  Image ($(expr $i - 5)/$(expr $# - 5)): ${!i}"
    echo " "
    FNAME=$(basename "${!i}")
    CR=$(curl -S \
      --cookie $cookie_jar \
      --cookie-jar $cookie_jar \
      --form "filename=$FNAME" \
      --form "file=@${!i}" \
      --form "ignorewarnings=1" \
      --form "token=${EDITTOKEN}" \
      "${WIKIAPI}?action=upload&format=json")
    echo " "
    # echo "$CR" | jq .
done
