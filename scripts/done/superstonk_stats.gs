/*
    BEFORE RUNNING:
    ---------------
    1. If not already done, enable the Google Sheets API
       and check the quota for your project at
       https://console.developers.google.com/apis/api/sheets
    2. Get access keys for your application. See
       https://developers.google.com/api-client-library/javascript/start/start-js#get-access-keys-for-your-application
    3. For additional information on authentication, see
       https://developers.google.com/sheets/api/quickstart/js#step_2_set_up_the_sample
*/

const spreadsheetId = "1H8aKeB9Zg9wXSd5GxNZQA2WdYzs2x8KwEGheLcVrSaY";
const range = "A1:A3";
const valueRange = Sheets.newRowData();
var date = new Date();
date = date.toISOString()

function makeApiCall() {
  var response = UrlFetchApp.fetch("https://www.reddit.com/r/superstonk/about.json");
  var result = JSON.parse(response.getContentText()).data;
  valueRange.values = [ [date, result.active_user_count, result.subscribers] ]
  var request = Sheets.Spreadsheets.Values.append(valueRange, spreadsheetId, range, {
    valueInputOption: 'RAW'
  });
}
