Moodle-Docker-Aprende
---------------------

Moodle Docker Aprende is a fully containerized environment for developing the Aprende LMS. It includes the following tools:

* Moodle
* Linux Ubuntu 20.04
* Apache
* PHP
* MariaDB
* Composer
* Moosh
* Bash
* phpMyAdmin
* MailHog
* Selenium
* Pseudo Cron
* Spanish (Mexico) language packs

It also installs many Aprende proprietary and 3rd party themes and plugins and settings as well as a set of test users.

The following development-related plugins also come installed:

* pluginskel
* codechecker
* moodlecheck
* themetester
* theme_selector
* adminer

# System Requirements (pre-requisites)

## For Linux and Mac OS

You must first install docker and docker-compose.

## For Windows

You must first install:
- WSL2
- Ubuntu 20.04 in WSL2
- Install Docker for Windows

## For all operating systems

- You must have git install in the shell (in WSL on Windows)
- You must have access to Aprende-com's repositories on GitHub.
- You must generate and setup an SSH Key for GitHub.

# Getting Started

Open a shell prompt. On Windows, start WSL2 by running the WSL command. Then:

git clone git@github.com:Aprende-com/moodle-docker.git moodle-docker
cd moodle-docker
chmod +x moodle

Before you run the following command, it is important to understand that, if you have a directory called ~/moodle, it will be deleted and replaced.

To start the environment, run:

./moodle up

The process will take about 10 minutes depending on the speed of your computer.

# Using Moodle-Docker-Aprende

You can see the following list of CLI tools anytime by using the "./moodle help" command.

Some useful commands:
- docker ps -l               List of running container.
- ./moodle                   Bash command prompt on webserver.
- ./moodle help              Display this help.
- ./moodle db                Access to the MySQL (MariaDB) command line as root user.
- ./moodle up                Builds and starts a Moodle site. See URLs below.
- ./moodle down              Shutdown a container. Will result in data loss.
- ./moodle start             Start a container.
- ./moodle stop              Stop a container without loosing data
- ./moodle [other command]   Run the command on the webserver.

From inside the container:
- moosh                      See https://moosh-online.com/ for details.
- composer

Useful URLs:
- https://localhost:8000     Access the Moodle LMS site.
- https://localhost:8025     Access the MailHog site.
- https://localhost:8100     Access the Moodle App.
- https://localhost:8900     Access phpMyAdmin.

Site Credentials:            Database Credentials:
- admin / moodle             - DB Host: db
- manager / moodle           - DB Name: moodle
- teacher / moodle           - DB User: moodle
- student / moodle           - DB Password: m@0dleing

Be sure to login to Moodle to complete the upgrade.
