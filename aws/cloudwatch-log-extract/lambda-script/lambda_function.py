import json
import boto3
import re
import os
from calendar import timegm
import gzip
import base64



def lambda_handler(event, context):

    capture_group = os.environ['capture_group']
    regex_pattern = os.environ['regex_pattern']
    message_attributes = os.environ['message_attributes']
    destinationSnsTopicArn = os.environ["destinationSnsTopicArn"]

    snsClient = boto3.client('sns')

    if capture_group:
        capture_group = json.loads(capture_group)

    if message_attributes:
        message_attributes = json.loads(message_attributes)

    print(f"Regex pattern is {regex_pattern}")

    print(f"Capture group is {capture_group}")

    encoded_zipped_data = event['awslogs']['data']
    zipped_data = base64.b64decode(encoded_zipped_data)
    data = gzip.decompress(zipped_data)
    payload = json.loads(data)

    publish_dict = {}

    for logs in payload['logEvents']:
        log_message = logs["message"].replace('\t', '').replace('\n', '')

        if regex_pattern:
            matchObject = re.match(regex_pattern, log_message)
            if matchObject:
                if capture_group:
                    for key,value in capture_group.items():
                        publish_dict[value] = matchObject.group(int(key))
                else:
                    publish_dict["message"] = log_message


        else:
            publish_dict["message"] = log_message

        print(f"Publish dict is {publish_dict}")

        # push message to SNS topic
        response = snsClient.publish(
            TopicArn=destinationSnsTopicArn,
            Message=json.dumps(publish_dict),
            Subject="CloudWatch-Logs-Extract",
            MessageStructure='string',
            MessageAttributes={
                '{}'.format(key): {
                    'DataType': 'String',
                    'StringValue': value,
                } for key,value in message_attributes.items()
            },
        )
