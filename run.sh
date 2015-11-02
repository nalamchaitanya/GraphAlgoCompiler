#
# CS2110 Testbench
# Runs tests

TEST_DIR=public
TEST_COUNT=10
PROG=a.out
ARGS=

./$PROG < sssp.algo > sssp.c;
gcc sssp.c -o b.out;
./$PROG < dfs.algo > dfs.c;
gcc dfs.c -o c.out;


j=0
for i in `seq 1 $TEST_COUNT`;
do
    echo -n "Running SSSP $i... "
	inp="input/$i.txt";
    outs="ssspmy/$i.ans";
	acts="sssp/SSSP_$i.txt";
	./b.out $TEST_DIR/$inp > $TEST_DIR/$outs;
    diff -b $TEST_DIR/$outs $TEST_DIR/$acts > /dev/null;
    if [[ $? == 0 ]] ; then
        echo "Passed."
        j=$((j+1))
    else
        echo "Failed."
    fi
done;
echo "Done ($j/$i) passed in SSSP.";
echo "---------------------***----------------------"
j=0
for i in `seq 1 $TEST_COUNT`;
do
    echo -n "Running DFS $i... "
	inp="input/$i.txt";
    outd="dfsmy/$i.ans";
    actd="dfs/dfs_$i.txt";
	./c.out $TEST_DIR/$inp > $TEST_DIR/$outd;
    diff -b $TEST_DIR/$outd $TEST_DIR/$actd > /dev/null;
    if [[ $? == 0 ]] ; then
        echo "Passed."
        j=$((j+1))
    else
        echo "Failed."
    fi
done;
echo "Done ($j/$i) passed in DFS.";
