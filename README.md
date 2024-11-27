## Docker run
```
sudo docker run --name dayz -v /data/Docker/dayz:/dayzserver -e USERNAME=XXX -e PASSWORD=XXX -e CODE=XXX -e UPDATE_SERVER=false -d --restart=unless-stopped -p 2302:2302/udp -p 2303:2303/udp -p 2304:2304/udp -p 2305:2305/udp -p 27016:27016/udp ghcr.io/fredolx/dayz-docker:00e1b4e2e6d501cdb585d1205b021cba930babbd
```
