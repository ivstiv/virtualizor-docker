# Virtualizor inside Docker

Virtualizor is a powerful web based VPS Control Panel which a user can deploy and manage VPS on servers with a single click. This will install the master server from which you can control your slave servers. The virtualizor.sh script provided in the repo can facilitate most if not all actions needed to manage your panel. Alternatively you can use our example docker-compose templates if you are more comfortable with compose.

## Pre-built images:

| Maintainer | Repository |
| :--------: | ---------- |
| ivstiv | [![Docker Pulls](https://img.shields.io/docker/pulls/ivstiv/virtualizor-docker?logo=docker&logoColor=white&style=for-the-badge)](https://hub.docker.com/r/ivstiv/virtualizor-docker "open on dockerhub") |
| Sonoran Software | [![Docker Pulls](https://img.shields.io/docker/pulls/sonoransoftware/virtualizor-docker?logo=docker&logoColor=white&style=for-the-badge)](https://hub.docker.com/r/sonoransoftware/virtualizor-docker "open on dockerhub") |

## Config Parameters

```
USER_HTTP_PORT=4082          # User panel http
USER_HTTPS_PORT=4083         # User panel https
ADMIN_HTTP_PORT=4084         # Admin panel http
ADMIN_HTTPS_PORT=4085        # Admin panel https
PUID=1000                    # User ID
PGID=1000                    # Group ID
EMAIL=your@email.here        # Emails will be sent from this email
PANEL_DIR=/opt/virtualizor   # Directory containing all of the panel's files
```

## Installation

**This assumes that you already have docker installed.**

1. Fetch the repo

   `git clone https://github.com/Ivstiv/virtualizor-docker.git && cd virtualizor-docker`

2. Create & Edit your config

   `cp example-config.sh config.sh`

3. Build the image

   `sh virtualizor.sh build`

4. Install the panel

   `sh virtualizor.sh install`

   If you have done everything correctly you should see output similar to this:

   ```
   Congratulations, Virtualizor has been successfully installed

   API KEY : key
   API Password : password

   You can login to the Virtualizor Admin Panel
   using your ROOT details at the following URL :
   https://IP:4085/
   OR
   http://IP:4084/
   ```

   If you see this you can login to your admin panel, if not check your variables or firewall.
   Use CTRL+C to exit the installation. (This would also stop the container)

5. Start the panel running in the background

   `sh virtualizor.sh start`

## Script manual

```
virtualizor.sh — A tool to easily control your virtualizor instance.

Examples:
  sh virtualizor.sh start
  sh virtualizor.sh reinstall

Options:
  start     Starts the container
  stop      Stops the container
  install   Creates a container and runs the installation script
  reinstall Deletes all panel data and installs a fresh panel
  uninstall Completely removes all traces of virtualizor
  build     Rebuilds the image
  shell     Starts a shell inside the panel's container
  help      Shows this message
```

## Docker-Compose

### Build locally:

If you would like to use this docker image with docker-compose, there is an example [docker-compose.yml](docker-compose.yml) in this repository. Simply clone the repository to the folder you would like to store your data and run the command `docker-compose up -d`.

### Use prebuilt image:

We provide hosted prebuilt images on Docker Hub, see those [images above](#pre-built-images). You can use the [altered example dockerhub_docker-compose.yml here](dockerhub_docker-compose.yml).

## Keep it updated

In order to keep the container packages up to date you would unfortunately have to suppress the unsigned repositories of OpenVZ and virtualizor:
[Ref](https://wiki.openvz.org/Installation_on_Debian_9)

```
docker exec -it virtualizor apt-get --allow-unauthenticated update
docker exec -it virtualizor apt-get upgrade -y
```

## Pushing an image

```
VERSION=$(date +'%Y-%m-%d')-1
docker login
docker build -t ivstiv/virtualizor-docker:latest -t "ivstiv/virtualizor-docker:$VERSION" . --load
docker push ivstiv/virtualizor-docker:latest
docker push "ivstiv/virtualizor-docker:$VERSION"
docker logout
```

## Credits & Links

- This was initially developed as a standalone installation image by [Nottt](https://github.com/Nottt?tab=repositories). Ivstiv has preserved his license and this was even forked off his repo until he removed it or made it private.
- [s6-overlay project](https://github.com/just-containers/s6-overlay)
- [Virtualizor home page](https://www.virtualizor.com)
- If you have any questions you can find Ivstiv in his [Discord server](https://discord.gg/VMSDGVD).
- [Sonoran Software Systems LLC](https://sonoran.software) uses Virtualizor day to day for their [VPS server hosting](https://sonoranservers.com/). They provide this repo to publish a docker image on https://hub.docker.com/r/sonoransoftware/virtualizor-docker

[Join our Discord Server](https://Discord.SonoranSoftware.com)

<a href="https://sonoran.software" target="_blank"><img width=25% src="https://sonoransoftware.com/assets/images/logos/logo_blue_grey.png" title="Sonoran Software Website" alt="Sonoran Software Systems"></a>
