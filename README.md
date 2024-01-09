# Argilla Docker Deploy

This repository contains a basic bash script to run Argilla, PostgreSQL and ElasticSearch using Docker and Docker Compose. The script will automatically install Docker and download the `docker-compose.yaml` to run Argilla.

> [!WARNING]  
> The script has been tested on a machine with Ubuntu 22.04.3 LTS (Jammy Jellyfish)


## How to use it

The first step is to download the `deploy-argilla.sh` script:

```bash
curl -O https://raw.githubusercontent.com/argilla-io/argilla-docker-deploy/main/deploy-argilla.sh
```

The user executing the script must be in the `sudo` group and be able to execute `sudo` command without password (`NOPASSWD`). Before executing the script, the user can set the following environment variables for creating the `argilla` default user:

```
export ARGILLA_ENABLE_DEFAULT_USER=true
export ARGILLA_DEFAULT_USER_PASSWORD=the_password
export ARGILLA_DEFAULT_USER_API_KEY=the_api_key
./deploy-script.sh
```
