#!/usr/bin/env bash
set -e

# Read and set environment variables.
if [ -f .env ]; then
  pushd .. > /dev/null
  export $(cat ~/moodle-docker/.env | xargs | envsubst)
  #source <(cat .env | sed -e '/^#/d;/^\s*$/d' -e "s/'/'\\\''/g" -e "s/=\(.*\)/='\1'/g")
  popd > /dev/null
fi

# RESET

if [ "$1" = "reset" ] && [ -d "$MOODLE_DOCKER_WWWROOT" ] && [ "$(ls -A $MOODLE_DOCKER_WWWROOT)" ]; then
    echo "Deleting theMoodle application directory..."
    rm -rf $MOODLE_DOCKER_WWWROOT
fi

# UPDATE

if [ "$1" = "update" ]; then
    pushd $MOODLE_DOCKER_WWWROOT > /dev/null
    git pull
    git submodule update --remote
    echo "Be sure to login to Moodle to complete the upgrade."
    popd > /dev/null
fi

# INSTALL

# Moodle Applicaton.
if [ ! -d "$MOODLE_DOCKER_WWWROOT" ]; then
    mkdir $MOODLE_DOCKER_WWWROOT
fi
if [ ! "$(ls -A $MOODLE_DOCKER_WWWROOT)" ]; then
    if [ -z $2 ]; then
        REPO="Aprende-com/moodle-dev.git"
    else
        REPO="$2"
    fi
    pushd $MOODLE_DOCKER_WWWROOT > /dev/null
    echo "Creating the Moodle application directory..."
    git clone git@github.com:$REPO .
    if [ -f .gitmodules ]; then
        git submodule update --init --recursive .
        if [ ! -z "$3" ]; then
            submodules=$(git config --file .gitmodules --get-regexp path | awk '{ print $2 }')
            for path in $arr; do
                pushd $path > /dev/null
                branchexists=$(git branch --list ${3})
                if [ ! -z ${branchexists} ]; then
                    git checkout $3
                fi
                popd > /dev/null
            done;
        fi
    fi
    popd > /dev/null

    # Add a Docker specific config file into Moodle.
    cp config.docker-template.php $MOODLE_DOCKER_WWWROOT/config.php

    # Add an initialization (install and configure) script into Moodle.
    cp mdl-init.sh $MOODLE_DOCKER_WWWROOT/mdl-init.sh

    # Install some additional development tools.
    git clone https://github.com/mudrd8mz/moodle-tool_pluginskel.git $MOODLE_DOCKER_WWWROOT/admin/tool/pluginskel
    # git clone https://github.com/moodlehq/moodle-local_codechecker.git $MOODLE_DOCKER_WWWROOT/local/codechecker
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

# TODO: XDEBUG

# Set some wise setting for live debugging - change this as needed
# read -r -d '' conf <<'EOF'
# ; Settings for Xdebug Docker configuration
# xdebug.mode = debug
# xdebug.client_host = host.docker.internal
# EOF
# moodle-docker-compose exec webserver bash -c "echo '$conf' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini"
# # Enable XDebug extension in Apache and restart the webserver container
# moodle-docker-compose exec webserver docker-php-ext-enable xdebug
# moodle-docker-compose restart webserver

sleep 5
docker exec -ti moodle-db-1 mysql -e "drop database if exists moodle"
docker exec -it moodle-webserver-1 bash mdl-init.sh

echo "Some useful commands:"
echo "- docker exec -ti moodle-db-1 mysql         MySQL as root."
echo "- docker exec -ti moodle-webserver-1 bash   Bash command prompt."
echo "- docker ps                                 List of running container."
echo "- ./up"
echo "- ./down"
echo "- ./start"
echo "- ./stop"
echo ""
echo "Useful URLs:"
echo "- https://localhost:8100                    Access the Moodle App."
echo "- https://localhost:8001                    Access phpMyAdmin."
echo "- https://localhost:8000                    Access the Moodle site."
echo ""
echo "Site Usernames and Passwords:"
echo "- admin / sandbox"
echo "- manager / sandbox"
echo "- teacher / sandbox"
echo "- student / sandbox"

unset MOODLE_DOCKER_DB
unset MOODLE_DOCKER_DBROOT
unset MOODLE_DOCKER_WWWROOT
unset MOODLE_DOCKER_DATAROOT
unset MOODLE_DOCKER_SELENIUM_VNC_PORT
unset MOODLE_DOCKER_BROWSER
unset MOODLE_DOCKER_APP_VERSION
unset MOODLE_DOCKER_PHP_VERSION
unset MOODLE_DOCKER_WEB_PORT
