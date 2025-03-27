python_env() {
    if [ -n "$VIRTUAL_ENV" ]; then
        # Show the venv.
        echo -e "venv/\e[1m$VIRTUAL_ENV_PROMPT\e[0m"
    elif [ -n "$CONDA_DEFAULT_ENV" ]; then
        # Return the conda environment name.
        echo -e "conda/\e[1m$CONDA_DEFAULT_ENV\e[0m"
    fi
}
