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

    alarmMessage = json.loads(event['Records'][0]['Sns']['Message'])

    alarmSubject = event['Records'][0]['Sns']['Subject']

    logging.warning(alarmSubject, extra=alarmMessage)
    
    print("Message published to Sentry successfully")

