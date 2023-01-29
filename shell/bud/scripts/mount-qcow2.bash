#!/usr/bin/env bash

HOST=$1
IMAGE_FILE=$2

# export PATH=/run/wrappers/bin:/run/current-system/sw/bin:$PATH

_fs_config() {
    nix eval --impure --raw \
        --expr \
        "with builtins; (getFlake (getEnv \"PRJ_ROOT\")).lib.hostConfig (getEnv \"HOST\")"

    # nix eval --raw --impure --expr "import ${gpg_template} \"$1\"" > $temp_loc/template.txt
}

_attach_nbd() {
    local nbd_device=$1
    local filename=$2
    sudo modprobe nbd
    sudo qemu-nbd -c $nbd_device -f qcow $filename
}

# _attach_and_mount() {
#     local lsblk=$(
#     sudo lsblk --json | jq '.blockdevices | .[] | select(.name=="nbd0") | .children | length')
#     #
#     # sudo qemu-nbd -c /dev/nbd0 -f qcow2 $IMAGE_FILE

#     if [ "$lsblk" -lt "1" ]; then
#         _mount_install
#     else
#         _partition_format && _mount_install
#     fi
# }

# _attach_and_mount
# echo $HOST $IMAGE_FILE done!
# attr="$PRJ_ROOT#nixosConfigurations.\"$HOST\".config.system.build.njk.vmLocalQemu"

# nix build "$attr" "${@:2}"

# exec $PRJ_ROOT/result/bin/start-local-qemu

# _attach_nbd /dev/nbd0 $IMAGE_FILE
