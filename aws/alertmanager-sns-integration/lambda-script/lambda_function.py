import json
import boto3
import os
import re
import sentry_sdk
import logging
from sentry_sdk.integrations.aws_lambda import AwsLambdaIntegration
from sentry_sdk.integrations.logging import LoggingIntegration


sentry_logging = LoggingIntegration(
    level=logging.INFO,           # Capture info and above as breadcrumbs
    event_level=logging.WARNING   # Send warnings as events
)

awsSecretsClient = boto3.client('secretsmanager')

sentrySecretName = os.environ['sentrySecretName']

sentryEnvironment = os.environ['sentryEnvironment']

awsSecretResponse = awsSecretsClient.get_secret_value(
    SecretId=sentrySecretName,
)

awsSentrySecret = json.loads(awsSecretResponse['SecretString'])

sentryDsn = awsSentrySecret['SENTRY_DSN']

sentry_sdk.init(
    dsn=sentryDsn,
    integrations=[
        sentry_logging,
        AwsLambdaIntegration(),
    ],
    environment=sentryEnvironment
)

def lambda_handler(event, context):

    alertMessageBody = event['Records'][0]['Sns']['Message']

    snsSubject = event['Records'][0]['Sns']['Subject']

    alertMessageBody = alertMessageBody.replace("\n","")
    
    matchObject = re.match(r'(.*).Alerts ([\w]+):Labels: - (.*)Annotations: -(.*).Source:(.*)', alertMessageBody)

    # If message is from Alertmanager
    if matchObject != None:
        snsMessage = matchObject.group(1)
        snsAertStatus = matchObject.group(2)
        snsAlertLabels = matchObject.group(3)
        snsAlertAnnotations = matchObject.group(4)
        snsAlertSource = matchObject.group(5)

        snsAlertLabels = snsAlertLabels.replace(" - ","\n")

        slothIdMatchObject = re.search(r'(?:^| - )sloth_id = (.+?)(?: - |$)', snsAlertAnnotations)
        if slothIdMatchObject != None:
            snsSubject = snsSubject + " " + slothIdMatchObject.group(1)

        logging.warning(snsSubject, extra=dict(alertMessageBody=snsMessage,alertStatus=snsAertStatus,labels=snsAlertLabels,annotations=snsAlertAnnotations,source=snsAlertSource))

    else:
        # if message is not from Alertmanager
        
        messageBody = json.loads(alertMessageBody)

        snsSubject = messageBody["message"]

        messageBodyExtra = messageBody.pop("message")

        logging.warning(snsSubject, extra=messageBodyExtra)

    print("Message published to Sentry successfully")
