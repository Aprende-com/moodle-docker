#!/usr/bin/env bash
set -e

# Read and set environment variables.
if [ -f .env ]; then
  pushd .. > /dev/null
  export $(cat ~/moodle-docker/.env | xargs | envsubst)
  popd > /dev/null
fi

# RESET

if [ "$1" = "reset" ] && [ -d "$MOODLE_DOCKER_WWWROOT" ]; then
    echo "Deleting the Moodle application directory..."
    sudo rm -rf $MOODLE_DOCKER_WWWROOT
fi

# UPDATE

if [ "$1" = "update" ]; then
    pushd $MOODLE_DOCKER_WWWROOT > /dev/null
    git pull
    git submodule update --remote
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

    # Install some additional development tools.
    git clone https://github.com/mudrd8mz/moodle-tool_pluginskel.git $MOODLE_DOCKER_WWWROOT/admin/tool/pluginskel
    # git clone https://github.com/moodlehq/moodle-local_codechecker.git $MOODLE_DOCKER_WWWROOT/local/codechecker
    git clone https://github.com/moodlehq/moodle-local_moodlecheck $MOODLE_DOCKER_WWWROOT/local/moodlecheck
    git clone https://github.com/davidscotson/moodle-tool_themetester.git $MOODLE_DOCKER_WWWROOT/tool/themetester
    git clone https://github.com/gjb2048/moodle-block_theme_selector.git $MOODLE_DOCKER_WWWROOT/blocks/theme_selector
    git clone https://github.com/grabs/moodle-local_adminer.git $MOODLE_DOCKER_WWWROOT/local/adminer
    git clone https://github.com/michael-milette/moodle-local_login $MOODLE_DOCKER_WWWROOT/local/login

    # Install, Initialize and configure Moodle.
    cp mdl-init.sh $MOODLE_DOCKER_WWWROOT/mdl-init.sh

    # Add A-Test users.
    docker cp ./assets/users/test-users.csv moodle-webserver-1:/var/www/moodledata/assets/
fi

# Starts docker
bin/moodle-docker-compose up -d
# Wait for DB to come up (important for oracle/mssql)
bin/moodle-docker-wait-for-db
# Starts Containers
bin/moodle-docker-compose start

# ===========================
echo "=== Install Xdebug."
# ===========================

read -r -d '' conf <<'EOF'
; Settings for Xdebug Docker configuration
xdebug.mode = debug,trace,profile
xdebug.start_with_request = trigger
xdebug.max_nesting_level = 1000
xdebug.discover_client_host = true
xdebug.cli_color = 2
xdebug.outputdir = "\tmp\"
xdebug.profiler_output_name = "cachegrind.out.%t-%s"
xdebug.use_compression = false
xdebug.client_host = host.docker.internal
EOF
docker exec -ti moodle-webserver-1 bash -c "echo '$conf' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini"
docker exec -ti moodle-webserver-1 pecl install xdebug
docker exec -ti moodle-webserver-1 docker-php-ext-enable xdebug
docker exec -ti moodle-webserver-1 /etc/init.d/apache2 reload

if [ "$1" = "reset" ]; then
    sleep 5
    # ===========================
    echo "Installing composer."
    # ===========================
    docker exec -ti moodle-webserver-1 bash -c "curl -s https://getcomposer.org/installer|php"
    # ===========================
    echo "Creating the database."
    # ===========================
    docker exec -ti moodle-db-1 mysql -e "DROP DATABASE IF EXISTS moodle"
    docker exec -ti moodle-db-1 mysql -e "CREATE DATABASE moodle DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
    docker exec -ti moodle-webserver-1 bash -c mdl-init.sh
fi

# unset MOODLE_DOCKER_DB
# unset MOODLE_DOCKER_DBROOT
# unset MOODLE_DOCKER_WWWROOT
# unset MOODLE_DOCKER_DATAROOT
# unset MOODLE_DOCKER_SELENIUM_VNC_PORT
# unset MOODLE_DOCKER_BROWSER
# unset MOODLE_DOCKER_APP_VERSION
# unset MOODLE_DOCKER_PHP_VERSION
# unset MOODLE_DOCKER_WEB_PORT

echo "================================= DONE ================================="
echo "Some useful commands:"
echo "- docker exec -ti moodle-db-1 mysql         MySQL as root."
echo "- docker exec -ti moodle-webserver-1 bash   Bash command prompt."
echo "- docker ps                  List of running container."
echo "- ./init.sh                  Use './init reset to completely reset environment."
echo "- ./up                       Bring up a container. Includes `./up.`"
echo "- ./down                     Shutdown a container. Will result in data loss."
echo "- ./start                    Start a container."
echo "- ./stop                     Stop a container without loosing data"
echo "- ./mdocker                  Run any command in the webserver."
echo ""
echo "From inside the container:"
echo "- moosh                      See https://moosh-online.com/ for details."
echo "- composer"
echo ""
echo "Useful URLs:"
echo "- https://localhost:8100     Access the Moodle App."
echo "- https://localhost:8900     Access phpMyAdmin."
echo "- https://localhost:8000     Access the Moodle site."
echo ""
echo "Site Credentials:            Database Credentials:"
echo "- admin / moodle             - DB Host: db"
echo "- manager / moodle           - DB Name: moodle"
echo "- teacher / moodle           - DB User: moodle"
echo "- student / moodle           - DB Password: m@0dleing"
echo ""
echo "Be sure to login to Moodle to complete the upgrade."
