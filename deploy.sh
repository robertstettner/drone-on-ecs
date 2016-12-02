#!/bin/bash -a

CONOUT=/dev/tty
if [[ -z $DEBUG ]]; then CONOUT=/dev/null; fi

CF_VPC="vpc-id"
CF_PublicSubnets="subnet-1,subnet-2"
CF_PrivateSubnets="subnet-3,subnet-4"
CF_DatabaseSubnets="subnet-5,subnet-6"
CF_KeyName="key"
CF_HostedZoneId="12345"
CF_HostedZoneName="example.com"
CF_DroneSecret="secret"
CF_DroneBitbucketClient="foo"
CF_DroneBitbucketSecret="bar"
CF_DroneAdmins="admin"
CF_DatabaseName="dronedb"
CF_DatabaseUsername="drone"
CF_DatabasePassword="pass"
CF_DockerUsername="user"
CF_DockerPassword="pass"

ACTION="create"
STACK_NAME="drone-ci"

STACK_EXISTS=$(aws cloudformation describe-stacks --stack-name $STACK_NAME &> /dev/null; echo "$?")

if [[ $STACK_EXISTS -eq 0 ]]; then
    ACTION="update"
fi

FILENAME=`node genParams.js`

echo "Executing: cloudformation $ACTION-stack"
launch_stack=$(aws cloudformation $ACTION-stack \
    --stack-name $STACK_NAME \
    --template-body file://template.yml \
    --capabilities CAPABILITY_IAM \
    --parameters file://$FILENAME &> launch.out; echo "$?")
if [[ -n `grep "No updates are to be performed" launch.out; rm launch.out` ]]; then
    echo "Exiting: no changes to update"
    exit 0
fi
if [[ $launch_stack -ne 0 ]]; then echo "Exiting: failed to $ACTION-stack"; exit 1; fi

