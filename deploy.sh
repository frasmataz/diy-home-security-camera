#!/bin/bash
cd src
zip ../terraform/lambda.zip lambda.py
cd ../terraform
terraform apply
