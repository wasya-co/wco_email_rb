
import os
import boto3
import email
import re
from botocore.exceptions import ClientError
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.application import MIMEApplication
import requests

region                = os.environ['Region']
office_api_endpoint   = os.environ.get('POX_ENDPOINT', None) # https://email.wasya.co/email/messages/from-ses
office_api_key        = os.environ.get('POX_KEY', None)
office_api_secret     = os.environ.get('POX_SECRET', None)
incoming_email_bucket = os.environ['MailS3Bucket']
incoming_email_prefix = os.environ.get('MailS3Prefix', None)
sender                = os.environ['MailSender']
recipient             = os.environ['MailRecipient']

def get_message_from_s3(message_id):
    if incoming_email_prefix:
        object_path = (incoming_email_prefix + "/" + message_id)
    else:
        object_path = message_id

    object_http_path = f"https://s3.console.aws.amazon.com/s3/object/{incoming_email_bucket}/{object_path}?region={region}"

    client_s3 = boto3.client("s3")
    object_s3 = client_s3.get_object(Bucket=incoming_email_bucket, Key=object_path)
    file = object_s3['Body'].read()

    file_dict = {
        "file": file,
        "path": object_http_path,
        "object_path": object_path,
    }
    return file_dict

def create_message(file_dict):
    separator = ";"
    mailobject = email.message_from_string(file_dict['file'].decode('utf-8'))
    subject_original = mailobject['Subject']
    subject = "FW: " + subject_original
    body_text = ("The attached message was received from "
              + separator.join(mailobject.get_all('From'))
              + ". This message is archived at " + file_dict['path'])

    # The file name to use for the attached message. Uses regex to remove all
    # non-alphanumeric characters, and appends a file extension.
    filename = re.sub('[^0-9a-zA-Z]+', '_', subject_original) + ".eml"

    msg = MIMEMultipart()
    text_part = MIMEText(body_text, _subtype="html")
    msg.attach(text_part)

    msg['Subject'] = subject
    msg['From'] = sender
    msg['To'] = recipient

    att = MIMEApplication(file_dict["file"], filename)
    att.add_header("Content-Disposition", 'attachment', filename=filename)

    msg.attach(att)

    message = {
        "Source": sender,
        "Destinations": recipient,
        "Data": msg.as_string()
    }
    return message

def send_email(message):
    client_ses = boto3.client('ses', region)

    try:
        response = client_ses.send_raw_email(
            Source=message['Source'],
            Destinations=[
                message['Destinations']
            ],
            RawMessage={
                'Data':message['Data']
            }
        )
    except ClientError as e:
        output = e.response['Error']['Message']
    else:
        output = "Email sent! Message ID: " + response['MessageId']

    return output

def lambda_handler(event, context):

    message_id = event['Records'][0]['ses']['mail']['messageId']
    print(f"Received message ID {message_id}")

    result = requests.post(office_api_endpoint,
      data = { 'object_path': f"https://{incoming_email_bucket}.s3.amazonaws.com/{message_id}",
        'bucket': incoming_email_bucket,
        'key': office_api_key,
        'object_key': message_id,
        'secret': office_api_secret })
    print(result)
