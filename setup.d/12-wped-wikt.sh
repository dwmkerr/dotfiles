# Setup wiktionary cli.
if ask "$os: Install wped/wikt?" Y; then
    if [[ "$os" == "osx" ]]; then
        brew install php-cli php-curl php-xml elinks
        wget https://raw.githubusercontent.com/mevdschee/wped/master/wped.php -O wped
        chmod 755 wped
        sudo mv wped /usr/local/bin/wped
        sudo ln -s /usr/local/bin/wped /usr/local/bin/wikt
    elif [[ "$os" == "ubuntu" ]]; then
        sudo apt-get install php-cli php-curl php-xml elinks
        wget https://raw.githubusercontent.com/mevdschee/wped/master/wped.php -O wped
        chmod 755 wped
        sudo mv wped /usr/bin/wped
        sudo ln -s /usr/bin/wped /usr/bin/wikt
    fi
fi

