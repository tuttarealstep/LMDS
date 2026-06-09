#!/bin/bash
set -euo pipefail

mkdir -p ./volumes/verdaccio/conf
mkdir -p ./volumes/verdaccio/plugins
mkdir -p ./volumes/verdaccio/storage

# Migrate existing config and plugins from the template-managed service path
# the first time Verdaccio is rebuilt with the persistent layout.
if [ -d ./services/verdaccio/conf ] && [ -z "$(ls -A ./volumes/verdaccio/conf 2>/dev/null)" ]; then
	cp -a ./services/verdaccio/conf/. ./volumes/verdaccio/conf/
fi

if [ -d ./services/verdaccio/plugins ] && [ -z "$(ls -A ./volumes/verdaccio/plugins 2>/dev/null)" ]; then
	cp -a ./services/verdaccio/plugins/. ./volumes/verdaccio/plugins/
fi

if [ ! -f ./volumes/verdaccio/conf/config.yaml ]; then
	cp ./.templates/verdaccio/conf/config.yaml ./volumes/verdaccio/conf/config.yaml
fi

touch ./volumes/verdaccio/conf/htpasswd

if command -v sudo >/dev/null 2>&1; then
	SUDO=sudo
else
	SUDO=
fi

run_maybe_sudo() {
	if [ -n "$SUDO" ]; then
		sudo "$@"
	else
		"$@"
	fi
}

if ! run_maybe_sudo chown -R 10001:65533 ./volumes/verdaccio/conf ./volumes/verdaccio/plugins ./volumes/verdaccio/storage; then
	echo "Warning: unable to chown Verdaccio folders. Ensure they are writable by uid 10001 before starting."
fi

if ! run_maybe_sudo chmod -R u+rwX,g+rwX ./volumes/verdaccio/conf ./volumes/verdaccio/plugins ./volumes/verdaccio/storage; then
	echo "Warning: unable to chmod Verdaccio folders."
fi
