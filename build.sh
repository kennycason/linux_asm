#!/bin/bash

FILE=$1
BASE=${1%.*}							# remove ".*"

function clean {
	if [ -f bin/$BASE.o ];
	then
		rm bin/$BASE.o
	fi
	if [ -f bin/$BASE ];
	then
		rm bin/$BASE
	fi
}

function build {
	as $FILE -o bin/$BASE.o				# assemble
	if [ -f bin/$BASE.o ];
	then
		ld bin/$BASE.o -o bin/$BASE	# link
		rm bin/$BASE.o					# cleanup
	fi
}

function run {
	if [ -f bin/$BASE ];
	then
		./bin/$BASE					# run
		echo $?							# exit return status of program
	fi
}

clean
build
run