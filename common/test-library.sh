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
		teardown
		exit 1
	fi
	echo "$PLAYBOOK_FILE syntax is OK"
}

assertPlaybookExecutionSuccess()
{
	LAST_NUM_LINES=$1
	EXPECTED_SUCCESS_LINES=$2
	ACTUAL_SUCCESS_LINES=$(tail -$LAST_NUM_LINES ${tmpfile} | grep -c "failed=0")
	if [ ${ACTUAL_SUCCESS_LINES} -ne $EXPECTED_SUCCESS_LINES ]; then
		echo "Error on playbook execution"
		teardown
		exit 1
	fi
}