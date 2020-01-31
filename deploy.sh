#!/bin/bash
zip terraform/lambda.zip src/lambda.py
cd terraform
terraform apply
