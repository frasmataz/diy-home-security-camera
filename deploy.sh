#!/bin/bash
zip lambda.zip lambda.py
cd terraform
terraform apply
