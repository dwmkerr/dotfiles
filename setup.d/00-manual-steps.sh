# Ask to install enterprise applications
if ask "$os: List applications that must be manually installed?" N; then
    echo "Slack"
    echo "Docker Desktop: https://docs.docker.com/desktop/setup/install/mac-install/"
    echo "Creative Cloud"
fi

if ask "$os: List applications that have paid subscriptions?" N; then
    echo "Amplitube"
    echo "Amplitube"
    echo "Dash"
    echo "Epic Games Launcher"
    echo "Guitar Pro 8"
fi
