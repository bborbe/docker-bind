# Bind

## Run

```
docker run \
-p 53:53/tcp \
-p 53:53/udp \
-v example:/etc/bind \
-v example:/var/lib/bind \
bborbe/bind:latest
```
