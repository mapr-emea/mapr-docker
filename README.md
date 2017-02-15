# MapR on Docker

## Create Docker Machine

Provide 8GB memory and 50 GB disk

```
docker-machine create --driver virtualbox  --virtualbox-memory "8192" --virtualbox-disk-size 50000 dev 
eval $(docker-machine env dev)
```

## How to build
```
cd ubuntu
docker build -t devproof/ubuntu --no-cache .
cd mapr52
docker build -t devproof/mapr52 --no-cache .
```

## How to run
```
docker run -it -p 8443:8443 -p 8047:8047 devproof/mapr52
```