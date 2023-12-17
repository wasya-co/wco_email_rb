#!/bin/bash

set -ex

## config
spreadsheet_id="1H8aKeB9Zg9wXSd5GxNZQA2WdYzs2x8KwEGheLcVrSaY"
api_key="<>"
access_token=$api_key

# get stats from reddit api
# parse them
reddit_resp=$( curl https://www.reddit.com/r/superstonk/about.json --user-agent "piousbox" )
active_users=$( echo $reddit_resp | jq .data.active_user_count )
subscribers=$( echo $reddit_resp | jq .data.subscribers )
timestamp=$( date +"%Y-%m-%d" )

echo $active_users
echo $subscribers

# shove them into google sheets
curl -X POST "https://sheets.googleapis.com/v4/spreadsheets/$spreadsheet_id/values/A1%3A3:append?key=$api_key?insertDataOption=INSERT_ROWS&responseValueRenderOption=UNFORMATTED_VALUE&valueInputOption=RAW" \
  --header "Authorization: Bearer $access_token" \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
  --data "{\"values\":[[\"$timestamp\",\"$active_users\",\"$subscribers\"]]}"
