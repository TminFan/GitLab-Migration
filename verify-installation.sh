#!/bin/bash -e

if ! docker --version; then
    echo "ERROR: Did Docker get installed?"
    exit 1
fi

if [ ! -f /.dockerenv ]; then
    if  ! docker run --rm hello-world; then
        echo "ERROR: Could not get docker to run the hello world container"
        exit 2
    fi
fi

echo "INFO: Sucessfully verified docker installation!"