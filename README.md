# LTO Tape

This repository contains information that i found useful while setting up and creating LTO tapes.

# Table of Contents
1. [Linux](#linux)
    1. [Writing Tapes](#linuxwritetapes)
    2. [Reading Tapes](#linuxreadtapes)
    3. [Troubleshooting](#linuxtroubleshooting)
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

### [Reading Tapes](#linuxreadtapes)

### [Troubleshooting](#linuxtroubleshooting)
```dmesg | grep st```

```lspci```

## [Windows](#windows)

[Iperius](https://www.iperiusbackup.co.uk/)

### [Troubleshooting](#windowstroubleshooting)
[xTalk Management Console](https://www.quantum.com/en/service-support/downloads-and-firmware/sage/)