#!/bin/bash
set -e

our_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Tempdir for our partition
GENIMAGE_ROOT=$(mktemp -d)

# "fake" file so generation is happy
cp ${our_path}/config ${GENIMAGE_ROOT}/config
cp ${GENIMAGE_ROOT}/config ${GENIMAGE_ROOT}/config.local

# Generate our ext4 partition
genimage \
    --rootpath "${GENIMAGE_ROOT}" \
    --tmppath "/tmp/genimage-part-tmppath" \
    --inputpath "/repo" \
    --outputpath "/repo" \
    --config "/repo/src/genimage-part.cfg"

# Now do some jank to try and save our config file from being blown away
MOUNT_TMPDIR=$(mktemp -d)
mount -o loop,rw /repo/storage.ext4 ${MOUNT_TMPDIR}
chattr +i ${MOUNT_TMPDIR}/config
umount ${MOUNT_TMPDIR}

# Finally, generate the disk image
genimage \
    --rootpath "${MOUNT_TMPDIR}" \
    --tmppath "/tmp/genimage-img-tmppath" \
    --inputpath "/repo" \
    --outputpath "/repo" \
    --config "/repo/src/genimage-img.cfg"

# Cleanup
rm /repo/storage.ext4
rm -rf ${GENIMAGE_ROOT}
rm -rf ${MOUNT_TMPDIR}
