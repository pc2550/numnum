from subprocess import call
import glob
import sys
import os, errno

"""
Sharon Chen
December 20, 2017
tester.py
This program tests numnum features that have tests in the tests directory.

usage: python tester.py <feature> <show_code>
"""


feature = sys.argv[1]
show_code = sys.argv[2].lower() == "true"


def main():

    test_sources = glob.glob("tests/*" + feature + "*")
    try:
        os.makedirs("tests/" + feature)
    except OSError as e:
        if e.errno != errno.EEXIST:
            raise

    tests = [test.split(".")[0].split("/")[1] for test in test_sources if ".num" in test]
    tests.sort()
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
        try:
            run_test(test, True)
        except:
            continue

    print "=========================================="
    print "Here are the tests that should be failing: "
    print "------------------------------------------"
    print want_fails

    for test in want_fails:
        try:
            run_test(test, False)
        except:
            continue


def run_test(test, want_pass):
    """Run this one test, which either should pass or fail."""

    print "__________________________________________"
    print test
    print "``````````````````````````````````````````"

    if show_code:
        print "Here is the code: "
        call(["cat", test + ".num"])
    
    in_f = open(test + ".num", "r")
    out_f = open(test + ".ll", "w")
    call(["./numnum"], stdin=in_f, stdout=out_f)
    print ""
    print "Running: " + test + ".num"
    call(["lli", test + ".ll"])
    print ""
    print "Expected output: " + test + ".out"

    if want_pass:
        ext = ".out"
    else:
        ext = ".err"

    call(["cat", test + ext])
    print ""
    print "End of test for " + test
    in_f.close()
    out_f.close()

    os.remove(test + ".ll")

main()
