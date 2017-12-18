make numnum
mkdir tests/test-elif-results
for i in {1..17}
do
	echo ""
	echo "test-elif$i"
	echo ""
	echo "Here is the code: "
	cat tests/test-elif$i.num
	./numnum < tests/test-elif$i.num > test-elif$i.ll
	echo ""
	echo "running test-elif$i"
	lli test-elif$i.ll
	echo ""
	echo "what should have been printed out"
	cat tests/test-elif$i.out
	echo ""
	echo "end of test-eli$i"
	echo ""
	echo ""
	echo ""

done
echo "done testing elif ^_^"


./numnum < tests/fail-elif1.num > fail-elif1.ll
lli fail-elif1.ll
echo ""
echo "what should have been printed out"
cat tests/fail-elif1.err

./numnum < tests/fail-elif2.num > fail-elif2.ll
lli fail-elif2.ll
echo ""
echo "what should have been printed out"
cat tests/fail-elif2.err


