### Image to bootstrap rancher ha install script


This is to be used with rancher-ha install this is basically an image that aims to generate the rancher-ha.sh:

```
docker run -d -p 8080:8080 \
--link mysql-rancher \
--name=rancher-bootstrap \
-e CATTLE_DB_CATTLE_MYSQL_HOST=mysql-rancher \
-e CATTLE_DB_CATTLE_MYSQL_PORT=3306 \
-e CATTLE_DB_CATTLE_MYSQL_NAME=cattle \
-e CATTLE_DB_CATTLE_USERNAME=rancher \
-e CATTLE_DB_CATTLE_PASSWORD=rancherpassword \
-v /var/run/docker.sock:/var/run/docker.sock \
rancher/server:v1.2.0-pre4-rc7

docker run \
-d \
--name=mysql-rancher \
-e MYSQL_ROOT_PASSWORD=root_password \
-e MYSQL_DATABASE=cattle \
-e MYSQL_USER=rancher \
-e MYSQL_PASSWORD=rancherpassword \
-p 3306:3306 \
-v /tmp/rancherdb:/var/lib/mysql \
mysql:latest

bs_ct=$(docker create \
--link rancher-bootstrap \
-e URL=http://rancher-bootstrap:8080/admin/ha \
-e NODES=3 \
-e FQDN_URL=rancher.example.com \
lusu777/rancher-ha-auto)


docker start $bs_ct

docker cp $bs_ct:/tmp/rancher-ha.sh .
```
