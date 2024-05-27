#!/bin/bash
set -e
SERVER_LOG=/var/log/unifi/server.log
SYSTEM_PROPERTIES=/usr/lib/unifi/data/system.properties
: ${MEMORY_LIMIT:=1024M}

file_env() {
	local var="$1"
	local fileVar="${var}_FILE"
	local def="${2:-}"
	if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
		echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
		exit 1
	fi
	local val="$def"
	if [ "${!var:-}" ]; then
		val="${!var}"
	elif [ "${!fileVar:-}" ]; then
		val="$(< "${!fileVar}")"
	fi
	export "$var"="$val"
	unset "$fileVar"
}

tail_server_log() {
    touch "$SERVER_LOG"
    tail -f "$SERVER_LOG" &
}

generate_config() {
    file_env 'SYSTEM_PROPERTIES_TEMPLATE'
    file_env 'MONGO_UNIFI_PASSWORD'
    [ -z "$SYSTEM_PROPERTIES_TEMPLATE" ] && return
    export MONGO_UNIFI_PASSWORD
    echo "${SYSTEM_PROPERTIES_TEMPLATE}" | envsubst > "$SYSTEM_PROPERTIES"
}

ace_jar() {
    [ -e "$SYSTEM_PROPERTIES" ] || generate_config
    tail_server_log
    exec java \
        -Dfile.encoding=UTF-8 \
        -Djava.awt.headless=true \
        -Dapple.awt.UIElement=true \
        -Dunifi.core.enabled=false \
        -Dunifi.mongodb.service.enabled=false \
        -Xmx"${MEMORY_LIMIT}" \
        -XX:+UseParallelGC \
        -XX:+ExitOnOutOfMemoryError \
        -XX:+CrashOnOutOfMemoryError \
        -XX:ErrorFile=/usr/lib/unifi/logs/unifi_crash.log \
        -Xlog:gc:logs/gc.log:time:filecount=2,filesize=5M \
        --add-opens=java.base/java.lang=ALL-UNNAMED \
        --add-opens=java.base/java.time=ALL-UNNAMED \
        --add-opens=java.base/sun.security.util=ALL-UNNAMED \
        --add-opens=java.base/java.io=ALL-UNNAMED \
        --add-opens=java.rmi/sun.rmi.transport=ALL-UNNAMED \
        -jar /usr/lib/unifi/lib/ace.jar start
}

case "$1" in
    ace.jar)
        ace_jar
        ;;
    *)
        echo "unknown command: $*"
        exit 1
        ;;
esac
