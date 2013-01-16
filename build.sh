#!/bin/bash

FILE=$1
BASE=${1%.*}							# remove ".*"

COMPILE_MODE="--32"
LINKER_MODE="-m elf_i386";

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
	CMD="as $COMPILE_MODE $FILE -o bin/$BASE.o"			# assemble
	echo $CMD
	$CMD	
	if [ -f bin/$BASE.o ];
	then
		CMD="ld $LINKER_MODE bin/$BASE.o -o bin/$BASE"		# link
		echo $CMD
		$CMD							
		
		rm bin/$BASE.o						# cleanup
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

# TODO make compatible with NASM
# nasm -felf32 myprog.asm
# gcc -o myprog -m32 myprog.o
