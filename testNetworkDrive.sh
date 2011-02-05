#!/bin/bash
#PBS -v TESTSTDOUT,TESTSTDERR,TESTNAME,NODENAME

echo "COLDFACT" > $TESTSTDOUT
cp /net/coldfact/data/awcheng/testnet/test_network_drive_do_not_remove.txt /mit/awcheng/testnetDst/coldfact.$TESTNAME.$NODENAME.00  2> $TESTSTDERR
echo "CRATE" >> $TESTSTDOUT
cp /net/crate-01/data/burge-stuff/awcheng/testnet/test_network_drive_do_not_remove.txt /mit/awcheng/testnetDst/crate.$TESTNAME.$NODENAME.00  2>> $TESTSTDERR
echo "DONE" >> $TESTSTDOUT
