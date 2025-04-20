# LTO Tape

This repository contains information that i found useful while setting up and creating LTO tapes.

# Table of Contents
1. [Linux](#linux)
    1. [Writing Tapes](#linuxwritetapes)
    1. [Writing Encrypted Tapes](#linuxwritingencryptedtapes)
    2. [Reading Tapes](#linuxreadtapes)
    2. [Reading Encrypted Tapes](#linuxreadencryptedtapes)
    3. [Wiping Tapes](#linuxwiping)
    4. [Troubleshooting](#linuxtroubleshooting)
    5. [Backup Shell Script](backup-script.sh)
    
2. [Windows](#windows)
    1. [Troubleshooting](#windowstroubleshooting)

## [Linux](#linux)
### [Writing Tapes](#linuxwritetapes)

```tar czvf /dev/st0 /home/database```

- c creates new tar archive.
- z compresses archive
- v verbose mode.
- /dev/st0 is the tape device
- /home/database is the directory that is being backed up to tape.

or 

**writing tape in filename order**

```find . -type f | sort | tar -cvf /dev/st0 -T -```

**Avoiding shoe shining**

Shoe shining (also called backhitching) is when a tape drive constantly stops, rewinds a bit, and starts again because it's not receiving data fast enough to keep streaming steadily.

```tar -cf - . | sudo mbuffer -m 1G -P 100 -s 256k -o /dev/st0```

📋 What it does:

- Creates a tar archive of the current directory (.) and sends it to standard output (-cf -).
- Pipes the output through mbuffer, a memory buffer tool that smooths out disk/tape write speeds.
- Writes the buffered stream to an LTO-7 tape drive (device /dev/st0).

💡 Why this setup is good for LTO-7:
- mbuffer prevents underruns that can reduce tape streaming speed and longevity.
- -m 1G: Uses 1 GB of memory buffer — great for LTO-7’s high streaming speeds (~300 MB/s native).
- -P 100: Shows progress every 100 operations (helps with monitoring).
- -s 256k: Block size of 256 KB, which balances performance and compatibility with LTO-7 drives.
- -o /dev/st0: Sends the output to the tape device.

### [Writing Encrypted Tapes](#linuxwritingencryptedtapes)
```sudo tar cvf - Directory/ | gpg --symmetric --cipher-algo AES256 | sudo dd of=/dev/st0 bs=64k status=progress```

### [Reading Tapes](#linuxreadtapes)
See files that are stored on the tape.

```tar tvf /dev/st0```

Restoring to a directory.

```tar tvf /dev/st0 -C /PATH/TO/RESTORE/BACKUP```

### [Reading Encrypted Tapes](#linuxreadencryptedtapes)
See file files are stored on the tape.

```sudo dd if=/dev/st0 bs=64k | gpg --decrypt | tar xvf - ```


### [Wiping Tapes](#linuxwiping)

```mt -f /dev/st0 erase```

### [Troubleshooting](#linuxtroubleshooting)
```dmesg | grep st```

```lspci```

## [Windows](#windows)

[Iperius](https://www.iperiusbackup.co.uk/)

### [Troubleshooting](#windowstroubleshooting)
[xTalk Management Console](https://www.quantum.com/en/service-support/downloads-and-firmware/sage/)
