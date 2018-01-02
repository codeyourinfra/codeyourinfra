#!/bin/sh

playbookSyntaxCheck()
{
	PLAYBOOK_FILE=$1
	INVENTORY_FILE=$2
	if [ "x$INVENTORY_FILE" == "x" ]; then
		ansible-playbook $PLAYBOOK_FILE --syntax-check
	else
		ansible-playbook $PLAYBOOK_FILE -i $INVENTORY_FILE --syntax-check
	fi
	if [ $? -ne 0 ]; then
		echo "Syntax error in $PLAYBOOK_FILE"
		exit 1
	fi
	echo "$PLAYBOOK_FILE syntax is OK"
}