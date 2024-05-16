# meraki-monsters-root

A tool to generate a disk image, to be used with an SSD/HDD, to get access to the root shell on the Cisco Meraki MX250/MX450 (Monsters/Monstermash)

## What this does & Who this is for

This is a tool to allow security researchers to get root access on the Cisco Meraki MX250/MX450 via UART. That is all.

## Usage

1. Build the docker image, and run it to generate the disk image
```
docker build -t meraki-monsters-root:latest .
docker run --rm --privileged -v "$(pwd):/repo" -it meraki-monsters-root:latest /repo/src/build.sh
```
2. Once done, write the disk.img file to an SSD/HDD.
3. Replace the SSD inside your MX250/MX450 with the one you wrote the disk.img to.
4. WITHOUT CONNECTING NETWORKING, boot the MX250/MX450 and enjoy root shell access via UART. :)

## UART Pinout

You should know this, but below is the pinout, where pin 1 is marked by the white circle on the PCB. These pins are on the back of the PCB between the cooling fans and CPU heatsink.

1. 5V
2. RX
3. TX
4. GND

## How this works

In Cisco's firmware for the MX250/MX450 (and probably many more), it looks for a FS with label "meraki_storage" to mount to /storage which is where the device config lives. What we do here is create a partition with that name on the HDD that enumerates before the USB bus, so we can have this mount before the internal USB storage device where /storage normally lives. This allows us to pass in a configuration that enables root shell access via UART.

This has been tested on multiple firmwares for the MX250/MX450, and has been tested up to firmware x86-gen2-wired-18-1-202308242224-Gd6f99ef7-rel-tuba.

## Disclaimer

This is for Security Researchers only, and should NEVER BE USED ON PRODUCTION EQUIPMENT. Expect Cisco to blacklist your device if they determine you did this, and I am not responsible for any damage to your device or any action taken against you by Cisco Meraki. Proceed at your own risk!
