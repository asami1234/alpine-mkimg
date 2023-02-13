## build image, run container
```
make build
make run
```

## execute container, run script
```
docker exec -it test sh
sh build.sh
cd /root/iso # you can get iso file
```

## copy file to docker image
```
docker cp test:/root/iso/alpine-preseed-edge-x86_64.iso .
```

## fix genapkovl-preseed.sh
```
add network setting
add apk package
change permitrootlogin yes
copy nwipe binary
change root password
change nwipe mode
copy nwipe to /usr/local/bin
```