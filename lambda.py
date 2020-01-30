import boto3
import os

def run(event, context):
    sesClient = boto3.client('ses')
    s3Client = boto3.client('s3')

    s3Bucket = event['Records'][0]['s3']['bucket']['name']
    s3Key = event['Records'][0]['s3']['object']['key']

    s3url = s3Client.generate_presigned_url(
            'get_object',
            Params={
                'Bucket': s3Bucket,
                'Key': s3Key
            },
            ExpiresIn=600);

    print('s3url = ' + s3url)

    sesClient.send_email(
        Source=os.environ['fromEmail'],
        Destination={
            'ToAddresses': [
                os.environ['toEmail']
            ]
        },
        Message={
            'Subject': {
                'Data': 'Video caught by motion camera'
            },
            'Body': {
                'Text': {
                    'Data': s3url
                }
            }
        }
    )

