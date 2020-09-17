# Virtualizor

Virtualizor is a powerful web based VPS Control Panel which a user can deploy and manage VPS on servers with a single click. This will install the master server from which you can contrl your slave servers.

A docker create template for *nix systems (see [here for OS X and Windows)](https://github.com/Nottt/virtualizor/blob/master/README.md#os-x-and-windows):

```
docker create --rm \
           --name virtualizor \
           -p 4084:4084 \
           -p 4085:4085
           -e PUID=1000 \
           -e PGID=1000 \
           -e PASSWORD=password \
           -e EMAIL=email@gmail.com \          
           -v /etc/localtime:/etc/localtime:ro \
           -v /opt/virtualizor:/usr/local/emps/ \
           nottt/virtualizor
```
## Parameters

* `-e PGID` for GroupID
* `-e PUID` for UserID 
* `-e PASSWORD` - Root password to access your admin panel 
* `-e EMAIL` - Email from which server will send emails 
* `-v /etc/localtime:/etc/localtime:ro` - Sync time with host
* `-p *:*` - Ports used, only change the left ports.

**When editing `-v` and `-p` paremeters, the host is always the left and the container the right. Only change the left**

For shell access while the container is running do `docker exec -it virtualizor bash`.

## Setting up the application 

If you have done everything correctly you should see output similar to this with `docker logs virtualizor`

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

If you see this you can login to your admin panel, if not check your variables.

#### OS X and Windows

Windows and OS X platforms does not have `/etc/localtime` to retrieve timezone information, so you need to add a `-e TZ=Europe/Amsterdam` variable to your docker command and remove `-v /etc/localtime:/etc/localtime:ro \`. 

[List of Time Zones here](https://timezonedb.com/time-zones)


sudo docker build -t virtualizor .
sudo docker start virtualizor
sudo docker stop virtualizor
sudo docker logs virtualizor
sudo rm -rf /opt/virtualizor/*

sudo docker create \
--name virtualizor \
-p 4084:4084 \
-p 4085:4085 \
-e PUID=0 \
-e PGID=0 \
-e PASSWORD=pass \
-e EMAIL=email@email.asd \
-v /etc/localtime:/etc/localtime:ro \
-v /opt/virtualizor:/usr/local/emps/ \
virtualizor