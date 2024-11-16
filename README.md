# Unofficial Docker images and K8s/Podman manifests for 
[UniFi Network Application](https://www.ui.com/download)

## Usage
### Podman
```
# build image
podman build -t localhost/unifi:8.6.9 image

# prepare secret
./gen-secret.sh | podman kube play -

# run
podman kube play manifest.yaml

# stop
podman kube down manifest.yaml

# cleanup
podman secret rm unifi-secret
podman volume ls -q|egrep '^unifi-(secret|config|data|logs)'|xargs podman volume rm
```
