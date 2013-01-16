#!/bin/bash

FILE=$1
BASE=${1%.*}							# remove ".*"
BIT="32"

function clean {
	if [ -f bin/$BASE.o ]
	then
		rm bin/$BASE.o
	fi
	if [ -f bin/$BASE ]
	then
		rm bin/$BASE
	fi
}

function buildGAS {

	if [ $BIT -eq "32" ]
	then
		COMPILE_MODE="--32"
		LINKER_MODE="-m elf_i386";
	else
		COMPILE_MODE=""
		LINKER_MODE="";
	fi

	CMD="as $COMPILE_MODE $FILE -o bin/$BASE.o"			# assemble
	echo $CMD
	$CMD	
	if [ -f bin/$BASE.o ]
	then
		CMD="ld $LINKER_MODE bin/$BASE.o -o bin/$BASE"		# link
		echo $CMD
		$CMD							
		
		rm bin/$BASE.o						# cleanup
	fi
}

function buildNASM {

	if [ $BIT -eq "32" ]
	then
		COMPILE_MODE="-f elf"
		LINKER_MODE="-m elf_i386";
	else
		COMPILE_MODE="-f elf64"
		LINKER_MODE="";
	fi

	CMD="nasm $COMPILE_MODE $FILE -o bin/$BASE.o"			# assemble
	echo $CMD
	$CMD	$EXT
	if [ -f bin/$BASE.o ]
	then
		CMD="ld $LINKER_MODE bin/$BASE.o -o bin/$BASE"		# link
		echo $CMD
		$CMD							
		
		rm bin/$BASE.o						# cleanup
	fi
}

function run {
	if [ -f bin/$BASE ]
	then
		./bin/$BASE					# run
		echo $?						# exit return status of program
	fi
}

# start
clean
if [[ $FILE == *.asm ]]
then 
	buildNASM
	run
elif [[ $FILE == *.s ]]
then
	buildGAS
	run
else
	echo "Not a NASM File (.asm)"
	echo "Not a GAS File (.s)"
fi

# nasm -felf32 myprog.asm
# gcc -o myprog -m32 myprog.o
