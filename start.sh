#!/bin/bash

BIN_PATH=${1:-"./canary"}

# Ensure logs directory exists
if [ ! -d "logs" ]; then
    mkdir -p logs
fi

# Check if config.lua exists, if not create it
if [ ! -f "config.lua" ]; then
    echo -e "\e[01;33m config.lua file not found, creating a new one... \e[0m"
    cp config.lua.dist config.lua && ./docker/config.sh --env docker/.env
fi

ulimit -c unlimited

# Function to stop the server and exit the script when 'q' is pressed
stop_script() {
    echo -e "\n\e[01;31mStopping server and exiting Bash script...\e[0m"
    kill -TERM "$SERVER_PID" 2>/dev/null
    wait "$SERVER_PID" 2>/dev/null
    exit 0
}

# Function to restart the server when Ctrl+C is pressed
restart_server() {
    echo -e "\n\e[01;33mRestarting server...\e[0m"
    kill -TERM "$SERVER_PID" 2>/dev/null
    wait "$SERVER_PID" 2>/dev/null
}

# Handle 'Ctrl+C' to restart the server
trap restart_server SIGINT

# Start the server loop
while true; do
    sleep 2

    # Display a starting server message
    echo -e "\e[01;32mStarting server...\e[0m"

    # Start the server and ensure output is printed immediately (unbuffered)
    stdbuf -oL -eL "$BIN_PATH" 2>&1 | awk '{ print strftime("%F %T - "), $0; fflush(); }' | tee "logs/$(date +"%F %H-%M-%S.log")" &

    SERVER_PID=$!  # Get the server process ID

    # Wait for user input in a non-blocking way
    while true; do
        read -rsn1 -t 1 input
        if [[ "$input" == "q" ]]; then
            stop_script  # Stops the server and exits Bash
        fi
        # If the process is no longer running, break out and restart
        if ! kill -0 "$SERVER_PID" 2>/dev/null; then
            break
        fi
    done
done
