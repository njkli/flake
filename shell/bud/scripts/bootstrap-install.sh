SALT_LENGTH=16
SALT="$(dd if=/dev/random bs=1 count=$SALT_LENGTH 2>/dev/null | rbtohex)"
USER_PASSPHRASE='gavno.123!'
CHALLENGE="$(echo -n $SALT | openssl dgst -binary -sha512 | rbtohex)"
RESPONSE=$(ykchalresp -2 -x $CHALLENGE 2>/dev/null)
KEY_LENGTH=512
ITERATIONS=1000000
LUKS_KEY="$(echo -n $USER_PASSPHRASE | pbkdf2-sha512 $(($KEY_LENGTH / 8)) $ITERATIONS $RESPONSE | rbtohex)"
CIPHER=aes-xts-plain64
HASH=sha512
echo -n "$LUKS_KEY" | hextorb | cryptsetup luksFormat --cipher="$CIPHER" --key-size="$KEY_LENGTH" --hash="$HASH" --key-file=- /dev/disk/by-partlabel/luksDevice

mkdir -p /mnt/_boot
mkdir -p /mnt/install
mkfs.vfat /dev/disk/by-partlabel/bootEFI
mount /dev//disk/by-partlabel/bootEFI /mnt/_boot
mkdir -p /mnt/_boot/crypt-storage
echo -ne "$SALT\n$ITERATIONS" > /mnt/_boot/crypt-storage/default
echo -n "$LUKS_KEY" | hextorb | cryptsetup open /dev/disk/by-partlabel/luksDevice encrypted --key-file=-

zpool create -f -O acltype=posixacl -O xattr=sa -O compression=lz4 -O mountpoint=none -R /mnt/install rpool /dev/mapper/encrypted
zfs create -p -o mountpoint=legacy rpool/local/root
zfs snapshot rpool/local/root@blank
zfs create -o refreservation=1G -o mountpoint=none rpool/reserved
zfs create -p -o mountpoint=legacy rpool/local/nix
zfs create -p -o mountpoint=legacy rpool/persist/home
zfs create -p -o mountpoint=legacy rpool/persist/misc
mount -t zfs rpool/local/root /mnt/install
mkdir -p /mnt/install/boot
mount

mkdir -p /mnt/install/nix
mount -t zfs rpool/local/nix /mnt/install/nix
mkdir /mnt/install/home
mount -t zfs rpool/persist/home /mnt/install/home
mkdir -p /mnt/install/persist
mount -t zfs rpool/persist/misc /mnt/install/persist
