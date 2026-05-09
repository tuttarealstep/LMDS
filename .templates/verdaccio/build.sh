#!/bin/bash
set -euo pipefail

mkdir -p ./services/verdaccio/conf
mkdir -p ./services/verdaccio/plugins
mkdir -p ./volumes/verdaccio/storage

touch ./services/verdaccio/conf/htpasswd

if command -v sudo >/dev/null 2>&1; then
	SUDO=sudo
else
	SUDO=
fi

if ! $SUDO chown -R 10001:65533 ./services/verdaccio/conf ./services/verdaccio/plugins ./volumes/verdaccio/storage; then
	echo "Warning: unable to chown Verdaccio folders. Ensure they are writable by uid 10001 before starting."
fi

if ! $SUDO chmod -R u+rwX,g+rwX ./services/verdaccio/conf ./services/verdaccio/plugins ./volumes/verdaccio/storage; then
	echo "Warning: unable to chmod Verdaccio folders."
fi
