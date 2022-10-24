Moodle-Docker-Aprende
---------------------

Moodle Docker Aprende is a fully containerized environment for developing the Aprende LMS. It includes:

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
* Python 2.7
* Graphviz
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
* themetester
* theme_selector
* adminer

It also configures many Aprende LMS specific settings. More coming in the future.

# System Requirements (pre-requisites)

## For Linux and Mac OS

You must first install docker and docker-compose.

## For Windows

You must first install:
- WSL2
- Ubuntu 20.04 in WSL2
- Install Docker for Windows

## For All Operating Systems

- You must have git install in the shell (in WSL on Windows)
- You must have access to Aprende-com's repositories on GitHub.
- You must generate and setup an SSH Key for GitHub.

# Getting Started

Open a shell prompt. On Windows, start WSL2 by running the WSL command. Then:

    git clone git@github.com:Aprende-com/moodle-docker.git moodle-docker --branch aprende
    cd moodle-docker
    chmod +x moodle

Before you run the following command, it is important to understand that, if you have a directory called ~/moodle, it will be deleted and replaced.But don't worry, you will be prompted before this happens.

To start the environment, run:

./moodle up

The process will take about 10 minutes depending on the speed of your computer.

# Using Moodle-Docker-Aprende

You can see the following list of CLI tools anytime by using the "./moodle help" command.

## Some Useful Commands

| Command                  | Description                                           |
|--------------------------|-------------------------------------------------------|
| ./moodle                 | Access the Bash command line on webserver as root.    |
| ./moodle help            | Display this help.                                    |
| ./moodle db              | Access the MySQL (MariaDB) command line as root user. |
| ./moodle up              | Builds and starts websites. See URLs below.           |
| ./moodle down            | Shutdown a container.                                 |
| ./moodle reset           | Builds and starts websites. Will result in deletion of all data. See URLs below. |
| ./moodle start           | Start a container.                                    |
| ./moodle stop            | Stop a container without loosing data.                |
| ./moodle status          | List of running container.                            |
| ./moodle update          | Update running container with latest code changes.    |
| ./moodle [other command] | Run the command on the webserver.                     |
| **From inside the container:**                                                   |
| moosh                    | See https://moosh-online.com/ for details.            |
| composer                 |                                                       |

## Useful URLs

| URL                          | Description                |
|------------------------------|----------------------------|
| http://localhost:8000       | Access the Moodle LMS site. |
| http://localhost:8025       | Access the MailHog site.    |
| http://localhost:8080       | Access the MailHog site.    |
| http://localhost:8100/admin | Access the Keycloak.        |
| http://localhost:8900       | Access phpMyAdmin.          |

## Additional Exposed Ports

| Port           | Description              |
|----------------|--------------------------|
| localhost:1025 | SMTP server for MailHog. |
| localhost:9004 | Xdebug.                  |
| localhost:3307 | MariaDB server.          |

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
