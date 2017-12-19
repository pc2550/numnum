#!/bin/sh

LLI="lli"
#LLI="/usr/local/opt/llvm/bin/lli"

# Path to the numnum compiler.  Usually "./numnum.native"
# Try "_build/numnum.native" if ocamlbuild was unable to create a symbolic link.
NUMNUM="./numnum.native"

# Run <args>
# Report the command, run it, and report any errors
Run() {
    echo $* 1>&2
    eval $* || {
	SignalError "$1 failed on $*"
	return 1
    }
}


Run "$NUMNUM" "<" $1 ">" "${basename}.ll" &&
Run "$LLC" "${basename}.ll"
Run "$LLI" "${basename}.ll"
