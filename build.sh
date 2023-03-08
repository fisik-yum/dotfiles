#!/bin/bash

export project=$(go list -m) #get project name

build() { 
    go build -ldflags "-s -w"; 
}

postbuild(){
	echo "Copying files"
	mv "$project" build/
	
}

execute(){
	cd build || exit 
	./"$project"
}

echo "Building project $project"
if [ -d "build" ] 
then
    rm -rf build/*
else
	mkdir build/
fi

build
postbuild
execute
