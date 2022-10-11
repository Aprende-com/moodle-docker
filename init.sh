#!/usr/bin/env bash
set -e

# Read and set environment variables.
if [ -f .env ]; then
  source <(cat .env | sed -e '/^#/d;/^\s*$/d' -e "s/'/'\\\''/g" -e "s/=\(.*\)/='\1'/g")
fi

# RESET

if [ "$1" = "reset" ] && [ -d "$MOODLE_DOCKER_WWWROOT" ] && [ "$(ls -A $MOODLE_DOCKER_WWWROOT)" ]; then
        echo "Deleting theMoodle application directory..."
        rm -rf $MOODLE_DOCKER_WWWROOT
    fi
fi

# UPDATE

if [ "$1" = "update"]; then
    # TODO - This will update Moodle and the plugins.
    pushd $MOODLE_DOCKER_WWWROOT
    git pull
    git submodule update --remote
    echo "Be sure to login to Moodle to complete the upgrade."
    popd
fi

# INSTALL

# Moodle Applicaton.
if [ ! -d "$MOODLE_DOCKER_WWWROOT" ]; then
    mkdir $MOODLE_DOCKER_WWWROOT
fi
if [ ! "$(ls -A $MOODLE_DOCKER_WWWROOT)" ]; then
    if [ $2 = "" ]; then
        REPO = "Aprende-com/moodle-dev.git"
    else
        REPO = "$2/moodle.git"
    fi
    pushd $MOODLE_DOCKER_WWWROOT
    echo "Creating the Moodle application directory..."
    git clone git@github.com:$REPO .
    if [ -f .gitmodules ]; then
        git submodule update --init --recursive .
    fi
    popd

    # Add a Docker specific config file into Moodle.
    cp config.docker-template.php $MOODLE_DOCKER_WWWROOT/config.php

    # Add an initialization (install and configure) script into Moodle.
    cp mdl-init.sh $MOODLE_DOCKER_WWWROOT/mdl-init.sh

    # Install some additional development tools.
    git clone https://github.com/mudrd8mz/moodle-tool_pluginskel.git $MOODLE_DOCKER_WWWROOT/admin/tool/pluginskel
    git clone https://github.com/moodlehq/moodle-local_codechecker.git $MOODLE_DOCKER_WWWROOT/local/codechecker
    git clone https://github.com/moodlehq/moodle-local_moodlecheck $MOODLE_DOCKER_WWWROOT/local/moodlecheck
    git clone https://github.com/davidscotson/moodle-tool_themetester.git $MOODLE_DOCKER_WWWROOT/tool/themetester
    git clone https://github.com/gjb2048/moodle-block_theme_selector.git $MOODLE_DOCKER_WWWROOT/blocks/theme_selector
    git clone https://github.com/grabs/moodle-local_adminer.git $MOODLE_DOCKER_WWWROOT/local/adminer
fi

# Starts docker
bin/moodle-docker-compose up -d
# Wait for DB to come up (important for oracle/mssql)
bin/moodle-docker-wait-for-db
# Starts Containers
bin/moodle-docker-compose start

# XDEBUG

# Set some wise setting for live debugging - change this as needed
read -r -d '' conf <<'EOF'
; Settings for Xdebug Docker configuration
xdebug.mode = debug
xdebug.client_host = host.docker.internal
EOF
moodle-docker-compose exec webserver bash -c "echo '$conf' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini"
# Enable XDebug extension in Apache and restart the webserver container
moodle-docker-compose exec webserver docker-php-ext-enable xdebug
moodle-docker-compose restart webserver

unset MOODLE_DOCKER_DB
unset MOODLE_DOCKER_DBROOT
unset MOODLE_DOCKER_WWWROOT
unset MOODLE_DOCKER_DATAROOT
unset MOODLE_DOCKER_SELENIUM_VNC_PORT
unset MOODLE_DOCKER_BROWSER
unset MOODLE_DOCKER_APP_VERSION
unset MOODLE_DOCKER_PHP_VERSION
