#!/bin/bash

RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
BLUE='\e[1;34m'
NC='\e[0m' # No Color

function fail() {
    echo -e "${RED}$@ ${NC}" 1>&2
    exit 1
}

[[ -z "$1" ]] && fail "File name must not be empty" || FILE=$1

if ! [ -f "$FILE" ]; then
    fail "File '$FILE' does not exist"
fi

# read urls from file
while read line; do
    [[ $line == *"auth_server_url"* ]] && auth_server_url=`cut -d "=" -f 2 <<< "$line"`
    [[ $line == *"token_server_url"* ]] && token_server_url=`cut -d "=" -f 2 <<< "$line"`
    [[ $line == *"redirect_uri"* ]] && redirect_uri=`cut -d "=" -f 2 <<< "$line"`
done < $FILE

[[ -z "$2" ]] && fail "Client ID must not be empty" || client_id=$2
[[ -z "$3" ]] && fail "Client secret must not be empty" || client_secret=$3
[[ -z "$auth_server_url" ]] && fail "Auth Server URL must not be empty"
[[ -z "$redirect_uri" ]] && fail "Redirect URI must not be empty"

# auth in browser
uuid=$(uuidgen)
state="state-$uuid"

echo "$auth_server_url?client_id=$client_id&response_type=code&scope=openid&redirect_uri=$redirect_uri&state=$state"
echo -e "\n ^ Click the link above to go to authentication"

# start http server
code=`python2 server.py $redirect_uri`

if [[ -z "$code" || "$code" == "error" ]] ; then
    fail "Authorization code is empty"
fi

echo "Authorization code: '$code'"

# get access token
resp=$(curl -v -X POST \
-H "Content-type:application/x-www-form-urlencoded" \
"$token_server_url" \
-d "client_id=$client_id&client_secret=$client_secret&grant_type=authorization_code&redirect_uri=$redirect_uri&code=$code")

echo -e "\n\nHere Tokens are:"
echo $resp | python -m json.tool

