# DIY Home Security Camera
## Uses the ['motion'](https://github.com/Motion-Project/motion) open-source project to build a DIY motion-activated home security camera.

### Architecture
The rough workflow is as follows:

**Motion:** *Uses webcam to detect motion, and captures video*

▼

**./upload.sh:** *Uploads the video to an S3 bucket*

▼

**S3 Bucket:** *Stores video, and triggers lambda function*

▼

**Lambda:** *enerates a pre-signed link to uploaded video in S3, and triggers SES..*

▼

**SES:** *ends email to target address, containing link to video*

▼

**Target email address**

---

### Deployment
Install [terraform](https://www.terraform.io)

Ensure `zip` is installed

Ensure your environment is configured to authenticate with the AWS API, with admin permissions.

Create a tfvars file at `terraform/terraform.tfvars`, with the following variables:
```
lambda_to_email="<EMAIL TO SEND NOTIFICATIONS TO>"
lambda_from_email="<SES-CONFIGURED EMAIL TO SEND NOTIFICATIONS FROM>"
bucket_name="<NAME OF S3 BUCKET TO BE CREATED TO STORE VIDEOS>"
```
You will need an email address already configured in SES to send email notifications from.

Run the follow commands:
```
cd terraform
terraform init
cd ..
./deploy.sh
```

---

### Running
Ensure [motion](https://github.com/Motion-Project/motion) is installed

Ensure your environment is configured to authenticate with the AWS API, with at least the `s3:PutObject` IAM permission.

Add a file called `bucket.conf` at the repo top level, containing the name of the S3 bucket you created to store videos during deployment.

e.g.
```
my-video-bucket
```
Add any further [motion configuration](https://motion-project.github.io/motion_config.html) to motion.conf as you wish

Run `motion`
