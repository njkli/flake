#!/usr/bin/env bash

_find_key() {
    local key=$1
}

WORKINGDIR=$PRJ_ROOT/secrets
MASTERKEY=$WORKINGDIR/master_key_id.txt
# cd $WORKINGDIR
ragenix -i $MASTERKEY --rules $WORKINGDIR/secrets.nix --edit $1
