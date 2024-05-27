# Unofficial Docker images and K8s/Podman manifests for 
[UniFi Network Application](https://community.ui.com/releases/UniFi-Network-Application-8-1-127/571d2218-216c-4769-a292-796cff379561)

## Usage
### Podman
```
# build image
podman build -t localhost/unifi:8.1.127 image

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
