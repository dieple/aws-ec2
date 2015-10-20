#!/bin/bash

###
# Wrapper script for knife ec2 server create...
###

PROG="`basename $0`"
EIP=""
NAME=""


usage()
{
	echo ""
	echo "Usage: $PROG [options]"
	echo ""
        echo "[-e Elastic IP]		Associate existing elastic IP address with instance after launch"
	echo "[-n name]		Developer's name"
	echo ""
}


#
# Main program
#

while getopts "e:n:?" 2> /dev/null ARG
do
	case $ARG in

		e)	EIP=$OPTARG;;

		n)	NAME=$OPTARG;;

		?)	usage
			exit 1;;
	esac	
done

if [ "$EIP" = "" ]
then
        echo ""
        echo "$PROG: An elastic IP address is required !"
        echo ""
	usage
        exit 1
fi

if [ "$NAME" = "" ]
then
        echo ""
        echo "$PROG: Developer's name image is required !"
        echo ""
	usage
        exit 1
fi


###
# use knide to create tthe image on aws
###

knife ec2 server create --image ami-77291500 \
			--flavor t2.medium \
			--run-list ‘role[base]’ \
			--security-group-id sg-fd07c699 \
			--region eu-west-1 \
			--node-name $NAME -T Name=$NAME \
			--subnet subnet-5766f50e \
			--ssh-user ubuntu \
			--ssh-key DevOpsDeveloper \
			--identity-file "~/.ssh/DevOpsDevloper.pem" \
			--associate-eip $EIP
