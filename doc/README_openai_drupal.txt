curl https://api.openai.com/v1/chat/completions   -H "Content-Type: application/json"   -H "Authorization: Bearer $OPENAI_API_KEY"   -d '{
    "model": "gpt-3.5-turbo",
    "messages": [
      {
        "role": "system",
        "content": "You are a poetic assistant, skilled in explaining complex programming concepts with creative flair."
      },
      {
        "role": "user",
        "content": "Compose a poem that explains the concept of recursion in programming."
      }
    ]
  }'

curl --include \
  --request POST \
  --user admin:$pi_passwd \
  --header 'Content-type: application/hal+json' \
  http://pi.local/node?_format=hal_json \
  --data-binary '{
    "_links": {
      "type":{"href":"http://pi.local/rest/type/node/article"}
    },
    "title":[{"value":"Test Tree #1" }],
    "body":[{"value": "<h1>Hello, world!</h1><img src='http://ish-drupal-prod.s3.amazonaws.com/public/2023-09/200x200%20piousbox%20favicon.png?VersionId=6QVFTwCGApZMbrkmP_MlEhaCB2_5J1DG' alt='' />", "format": "full_html" }],
    "type":[{"target_id":"article"}],
    "field_image_thumb_url":[{"value": "http://ish-drupal-prod.s3.amazonaws.com/public/2023-09/200x200%20piousbox%20favicon.png?VersionId=6QVFTwCGApZMbrkmP_MlEhaCB2_5J1DG" }],
    "status": [{"value": 1}],
    "_embedded": {
      "http://pi.local/rest/relation/node/article/field_issue": [
        { "uuid": [{ "value": "56229a95-d675-43e1-99b1-f9e11b5579c5" }] }
      ],
      "http://pi.local/rest/relation/node/article/field_tags": [
        { "uuid": [{ "value": "45646a7d-1a16-42e8-b758-f6e1c8d976f7" }] },
        { "uuid": [{ "value": "834e34e2-05ae-498d-b876-453798872ce1" }] }
      ]
    }
  }'


curl --include \
  --request POST \
  --user admin:$pi_passwd \
  --header 'Content-type: application/hal+json' \
  http://pi.local/entity/file?_format=hal_json \
  --data-binary '{
    "_links": { "type": { "href": "http://pi.local/rest/type/file/image" } },
    "filename": [
      {
        "value": "favicon-32x32.png"
      }
    ],
    "filemime": [
      {
        "value": "image/png"
      }
    ],
    "type":[{"target_id":"image"}],
    "data": [
      {
        "value": "/9j/4AAQSkZJRgABAQEASABIAAD/2wBDAAYEBAUEBAYFBQUGBgYHCQ4JCQgICRINDQoOFRIWFhUSFBQXGiEcFxgfGRQUHScdHyIjJSUlFhwpLCgkKyEkJST/2wBDAQYGBgkICREJCREkGBQYJCQkJCQkJCQkJCQkJCQkJCQkJCQkJCQkJCQkJCQkJCQkJCQkJCQkJCQkJCQkJCQkJCT/wgARCAAyADIDASIAAhEBAxEB/8QAGAABAQEBAQAAAAAAAAAAAAAAAQADAgX/xAAWAQEBAQAAAAAAAAAAAAAAAAAAAQX/2gAMAwEAAhADEAAAAfTEysMEAeVqjURARQQKjUhIRYgrmNipAqgpSo//xAAUEAEAAAAAAAAAAAAAAAAAAABQ/9oACAEBAAEFAkf/xAAUEQEAAAAAAAAAAAAAAAAAAABA/9oACAEDAQE/AQf/xAAUEQEAAAAAAAAAAAAAAAAAAABA/9oACAECAQE/AQf/xAAUEAEAAAAAAAAAAAAAAAAAAABQ/9oACAEBAAY/Akf/xAAZEAACAwEAAAAAAAAAAAAAAAAAARARIED/2gAIAQEAAT8hy8PvssY4Y5//2gAMAwEAAgADAAAAEBDRANssv3ci/wCOOAP/xAAVEQEBAAAAAAAAAAAAAAAAAAABQP/aAAgBAwEBPxAg/8QAFhEAAwAAAAAAAAAAAAAAAAAAABEw/9oACAECAQE/EBX/AP/EABoQAQEBAQADAAAAAAAAAAAAAAEAERAgITH/2gAIAQEAAT8QZmeLjzEpM22y2y2y22yzPuWbJbdm2WbJllllnzAfnP/Z"
      }
    ]
  }'









curl --include \
  --request POST \
  --user admin:$pi_passwd \
  --header 'Content-type: application/hal+json' \
  http://pi.local/entity/file?_format=hal_json \
  --data-binary '{
    "_links": {
      "type": {
        "href": "http://pi.local/rest/type/file/image"
      }
    },
    "filename": [
      {
        "value": "favicon-32x32.png"
      }
    ],
    "filemime": [
      {
        "value": "image/png"
      }
    ],
    "filesize": [
      {
        "value": "488"
      }
    ],
    "type": [
      {
        "target_id": "image"
      }
    ],
    "data": [
      {
        "value": "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgBAMAAACBVGfHAAAABGdBTUEAALGPC/xhBQAAAAFzUkdCAK7OHOkAAAAJcEhZcwAACxMAAAsTAQCanBgAAAAkUExURUxpcSOq4SOq4SOq4SOq4SOq4SOq4SOq4SOq4SOq4SOq4SOq4U0m8UcAAAAMdFJOUwD/EvAm2qhTPMRrkl4CMYAAAAE1SURBVCjPXZG/S8NQEMePR7Ehnb48khC7BEFFnYJD6/aWOLilVBy6WBVc648/oCii1KlFKDrFwV2tqH+edy9Rk7zh8e7Dfe++944oP5dUO59RDQyPqrFK/WqKCzxUwA30oJyymervlVK8PsVBOd85hh6pyflfhwXg024cjguwBqCjhsCsSOAn+k4MBGpUWAB6Tb6W1VxAgv+MfcPgWUBgazjxoYwlQLrsmBa6MhbH3hep2yu6QJuowWL9Yfs1U4QRSbWOjRts0DMCdEbqjl8s1kYkPqmX7YGRfgy4aJe2IB+0wZJI2s7ojEGbWtJejL1aL55h+wGDVWTWix47+cAug6kAycjs+LkkjFzku0h6dC3D01KxCmdOLrt7pyQ0+Z/tRXT/eEr0dvL7y6zkrbhPtYVPrOAHKZQ53IyepQMAAAAASUVORK5CYII="
      }
    ]
  }'




curl --include \
  --request POST \
  --user admin:$pi_passwd \
  --header 'Content-type: application/hal+json' \
  http://wco.local:8088/node?_format=hal_json \
  --data-binary '{
    "_links": {
      "type":{"href":"http://wco.local:8088/rest/type/node/article"}
    },
    "title":[{"value":"Test Tree #1" }],
    "body":[{"value": "<h1>Hello, world!</h1><img src='http://ish-drupal-prod.s3.amazonaws.com/public/2023-09/200x200%20piousbox%20favicon.png?VersionId=6QVFTwCGApZMbrkmP_MlEhaCB2_5J1DG' alt='' />", "format": "full_html" }],
    "type":[{"target_id":"article"}],
    "field_image_thumb_url":[{"value": "http://ish-drupal-prod.s3.amazonaws.com/public/2023-09/200x200%20piousbox%20favicon.png?VersionId=6QVFTwCGApZMbrkmP_MlEhaCB2_5J1DG" }],
    "status": [{"value": 1}]
  }'