## Docker run
```
sudo docker run --name dayz -v /data/Docker/dayz:/dayzserver -e USERNAME=XXX -e PASSWORD=XXX -e CODE=XXX -e UPDATE_SERVER=false -d --restart=unless-stopped -p 2302:2302/udp -p 2302:2302/tcp -p 2303:2303/udp -p 2303:2303/tcp -p 2304:2304/udp -p 2304:2304/tcp -p 2305:2305/udp -p 2305:2305/tcp -p 27016:27016/udp -p 27016:27016/tcp -p 8766:8766/udp -p 8766:8766/tcp ghcr.io/fredolx/dayz-docker:e910f56473ac9df3747bbcfff7b3e23a6c191f6c
```
