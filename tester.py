from subprocess import call
import glob
import sys
import os, errno



feature = sys.argv[1]
test_sources = glob.glob("tests/*" + feature + "*")
try:
    os.makedirs("tests/" + feature)
except OSError as e:
    if e.errno != errno.EEXIST:
        raise

tests = [test.split(".")[0].split("/")[1] for test in test_sources]
want_passes = []
want_fails = []
for test in tests:
    if "test" in test:
        want_passes.append("tests/" + test)
    elif "fail":
        want_fails.append("tests/" + test)

print "=========================================="
print "We are now testing this feature: " + feature
print "------------------------------------------"

print "=========================================="
print "Here are the tests that should be passing: "
print "------------------------------------------"
print want_passes

for test in want_passes:
    print "__________________________________________"
    print test
    print "``````````````````````````````````````````"

    print "Here is the code: "
    call(["cat", test])
    f = open(test + ".ll", "w")
    call(["./numnum", "<", test + ".num"], stdout=f)
    f.close()
    print ""
    print "Running " + test
    call(["lli", test + ".ll"])
    print ""
    print "Expected output: " + test + ".out"
    call(["cat", test + ".out"])
    print ""
    print "End of test for " + test

print "=========================================="
print "Here are the tests that should be failing: "
print "------------------------------------------"
print want_fails

for test in want_fails:
    print "__________________________________________"
    print test
    print "``````````````````````````````````````````"

    print "Here is the code: "
    call(["cat", test])
    f = open(test + ".ll", "w")
    call(["./numnum", "<", test + ".num"], stdout=f)
    f.close()
    print ""
    print "Running " + test
    call(["lli", test + ".ll"])
    print ""
    print "Expected output: " + test + ".err"
    call(["cat", test + ".err"])
    print ""
    print "End of test for " + test
