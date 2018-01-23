#!/bin/bash

checkPlaybookSyntax()
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
		teardown
		exit 1
	fi
	echo "$PLAYBOOK_FILE syntax is OK"
}

assertEquals()
{
	EXPECTED=$1
	ACTUAL=$2
	if [ "$ACTUAL" != "$EXPECTED" ]; then
		echo "Assertion error: $EXPECTED expected, but $ACTUAL gotten"
		teardown
		exit 1
	fi
}

assertFileExists()
{
	FILE_PATH=$1
	if [ ! -f $FILE_PATH ]; then
		echo "The file $FILE_PATH does not exist"
		teardown
		exit 1
	fi
}