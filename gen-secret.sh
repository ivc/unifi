#!/bin/sh
cat <<SECRET_EOF
apiVersion: v1
kind: Secret
metadata:
  name: unifi-secret
stringData:
  db_password: "$(LC_ALL=C tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 23 && echo)"
SECRET_EOF
