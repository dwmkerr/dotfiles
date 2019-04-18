#!/usr/bin/env bash

# If we have Java installed, then set the JAVA_HOME directory and make sure
# the JAVA_HOME is in the bin path.
if [ -n `which java` ]; then
    export JAVA_HOME=$(/usr/libexec/java_home)
    export PATH=${JAVA_HOME}/bin:$PATH
fi
