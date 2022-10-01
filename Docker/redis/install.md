```
docker run -d -p 6739:6739 --privileged=true \
-v <PATH>/redis.conf:/usr/local/etc/redis/redis.conf
-v <PATH>/data:/data
redis
redis-server /usr/local/etc/redis/redis.conf
```
