Moodle-Docker-Aprende
---------------------

Moodle Docker Aprende is a fully containerized environment for developing the Aprende LMS. It includes:

* Moodle
* Linux Ubuntu 20.04
* Apache
* PHP
* MariaDB
* adk (Aprende Moodle Development Kit)
* Bash
* Composer
* Graphviz
* MailHog
* Moosh
* phpMyAdmin
* PHPUnit
* Pseudo Cron
* PsySH
* Python 3.9
* Selenium
* Spanish (Mexico) language packs
* All themes and plugins (including images) used in the Aprende LMS.
* A set of test users (see list below)
* Custom profile fields (coming in the future)
* Custom course fields (coming in the future)
* Sample courses (coming in the future)

The following development-related plugins also come pre-installed:

* pluginskel
* codechecker
* moodlecheck
* theme_selector
* adminer

It also configures many Aprende LMS specific settings. More coming in the future.

# System Requirements (pre-requisites)

## For Linux and MacOS

You must first install [Docker Desktop](https://www.docker.com/) or Docker and Docker-compose.

## For Windows

You must first install:
- WSL2
- Ubuntu 20.04 in WSL2
- Install [Docker Desktop](https://www.docker.com/) for Windows

## For All Operating Systems

- You must have git install in the shell (in WSL on Windows)
- You must have access to Aprende-com's repositories on GitHub.
- You must generate and setup an SSH Key for GitHub.

# Getting Started

Open a shell prompt. On Windows, start WSL2 by running the WSL command. Then:

    cd ~
    git clone git@github.com:Aprende-com/moodle-docker.git moodle-docker --branch aprende
    cd moodle-docker
    chmod +x moodle

Before you run the following command, it is important to understand that, if you already have a directory called ~/moodle, it will be deleted and replaced.

*You will be prompted before this happens.*

To start the environment, run:

bash moodle reset

You will be prompted for:

* The version of Moodle that you want to install
* Your sudo password.

The process will take about 30 minutes depending on the speed of your computer.

# Using Moodle-Docker-Aprende

You can see the following list of CLI tools anytime by using the "bash moodle help" command.

## Some Useful Commands

| Command                     | Description                                           |
|-----------------------------|-------------------------------------------------------|
| bash moodle                 | Access the Bash command line on webserver as root.    |
| bash moodle help            | Display this help.                                    |
| bash moodle db              | Access the MySQL (MariaDB) command line as root user. |
| bash moodle up              | Builds and starts websites. See URLs below.           |
| bash moodle down            | Shutdown a container.                                 |
| bash moodle reset           | Builds and starts websites. Will result in deletion of all data. See URLs below. |
| bash moodle start           | Start a container.                                    |
| bash moodle stop            | Stop a container without loosing data.                |
| bash moodle status          | List of running container.                            |
| bash moodle logs            | View logs from the Moodle Webserver.                  |
| bash moodle update          | Update running container with latest code changes.    |
| bash moodle [other command] | Run the command on the webserver.                     |
| **From inside the container:**                                                      |
| adk                         | See https://github.com/Aprende-com/moodle_development_kit. |"
| moosh                       | See https://moosh-online.com/ for details.            |
| composer                    |                                                       |
| python3                     |                                                       |
| nvm / npm / node            |                                                       |
| phpunit                     | Run phpunit on complete instance of Moodle.           |
| psysh                       | Run PshySH in Moodle.                                 |

## Useful URLs

| URL                         | Description                 |
|-----------------------------|-----------------------------|
| http://localhost:8000       | Access the Moodle LMS site. |
| http://localhost:8025       | Access the MailHog site.    |
| http://localhost:8080/admin | Access the Keycloak site.   |
| http://localhost:8100       | Access the Moodle app.      |
| http://localhost:8900       | Access phpMyAdmin.          |

## Additional Exposed Ports

| Port           | Description              |
|----------------|--------------------------|
| localhost:1025 | SMTP server for MailHog. |
| localhost:9003 | Xdebug.                  |
| localhost:3306 | MariaDB server.          |

## Moodle LMS Site Credentials

- admin / moodle
- manager / moodle
- teacher / moodle
- student / moodle

## Database Credentials

- DB Host: db
- DB Name: moodle
- DB User: moodle
- DB Password: m@0dl3ing

Be sure to login to Moodle to complete the upgrade.

# Future

In the future, I am considering the following enhancements:

- Make it possible to run multiple versions of Moodle at the same time. Examples might include, sites based on Aprende's dev, qa, prod branches, and Moodle's MOODLE_311_STABLE, MOODLE_410_STABLE and master branches. This will help developers identify whether issues are instance/version specific and enable developers to work on future releases of the Aprende LMS. Such a feature is partially implemented but **completely untested**. Currently, you can use the undocumented `./moodle up RepoURL branch` command. Example: `./moodle up moodle/moodle.git MOODLE_311_STABLE`. The limitation is that it will replace your current instance of Moodle instead of adding a new separate instance.

If you have any suggestions or requests, please let me know. Pull requests are always welcome.
