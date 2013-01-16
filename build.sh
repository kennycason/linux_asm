#!/bin/sh

INPUT=${1%.asm}						# remove ".asm"
INPUT=${INPUT%.s}					# remove ".s"

rm bin/$INPUT.o						# cleanup existing code
rm bin/$INPUT

as $1 -o bin/$INPUT.o				# assemble
if [ -f bin/$INPUT.o ];
then
	ld bin/$INPUT.o -o bin/$INPUT	# link
	rm bin/$INPUT.o					# cleanup
	./bin/$INPUT					# run
	echo $?							# exit return status of program
fi