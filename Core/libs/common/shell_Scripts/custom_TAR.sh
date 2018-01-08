#!/bin/bash

if [[ "$3" == "--exclude='" ]]; then
	TAR_CMD="tar -czf"
	for arg in $@ ; do
		if [[ $arg != "--exclude='" ]];
		then
			TAR_CMD="$TAR_CMD $arg"
		fi
	done
	
else
	TAR_CMD="tar -czf $@"
fi

eval $(echo $TAR_CMD)