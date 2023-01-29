#!/usr/bin/env bash

HOST="${1:-$HOST}"

attr="$PRJ_ROOT#nixosConfigurations.\"$HOST\".config.system.build.njk.vmLocalQemu"

nix build "$attr" "${@:2}"

exec $PRJ_ROOT/result/bin/start-local-qemu
