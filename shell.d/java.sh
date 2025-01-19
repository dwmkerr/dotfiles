# #!/usr/bin/env bash

# If maven is installed, add it to the path.
maven_path="/usr/local/opt/apache-maven-3.9.0/bin"
if [ -d "${maven_path}" ]; then
    export PATH="${maven_path}:$PATH"
fi

# If we have Java installed, then set the JAVA_HOME directory and make sure
# the JAVA_HOME is in the bin path.
java_version="17"
if [ -x "$(command -v "java")" ]; then
    if [ -f "/usr/libexec/java_home" ]; then
        # If we have the java_home util (i.e. on a Mac) then use it...
        export JAVA_HOME="$(/usr/libexec/java_home -v ${java_version})";
        export PATH="${JAVA_HOME}/bin:$PATH";
    elif [ -f "$(which javac)" ]; then
        # ...otherwise try and work it out from the location of javac.
        export JAVA_HOME=$(dirname $(dirname $(readlink -e $(which javac))));
    fi
fi
